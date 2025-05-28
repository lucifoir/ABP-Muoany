const pool = require("../config/db");
const axios = require("axios"); // untuk call Flask API

exports.addRecord = async (req, res) => {
  const { type, amount, description, transaction_date } = req.body;
  const userId = req.user.id;

  console.log("📥 Add Record Request:", req.body); // 👈 tambahkan ini
  console.log("User ID:", req.user?.id);

  try {
    // 1. Predict category dari Flask
    const flaskResponse = await axios.post("http://localhost:5001/predict", {
      title: description,
    });

    console.log("🎯 Flask prediction result:", flaskResponse.data);

    const predictedCategoryName = flaskResponse.data.predicted_category;

    // 2. Get category_id dan name dari database
    const categoryQuery = await pool.query(
      "SELECT id, name FROM categories WHERE name = $1",
      [predictedCategoryName]
    );

    if (categoryQuery.rows.length === 0) {
      return res
        .status(400)
        .json({ message: "Predicted category not found in database" });
    }

    const categoryId = categoryQuery.rows[0].id;
    const categoryName = categoryQuery.rows[0].name;

    console.log("✅ Predicted:", predictedCategoryName);
    console.log("✅ Category from DB:", categoryQuery.rows[0]);
    console.log("✅ Inserting record for user:", userId);

    // 3. Insert record ke database
    const insertedRecord = await pool.query(
      `INSERT INTO records (user_id, category_id, type, amount, description, transaction_date)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [userId, categoryId, type, amount, description, transaction_date]
    );

    // 4. Gabungkan record dengan nama kategori
    const record = {
      ...insertedRecord.rows[0],
      category_name: categoryName,
    };

    res.status(201).json({ record });
  } catch (error) {
    console.error("❌ Add record error:", error.message);
    res.status(500).json({ message: "Server error" });
  }
};

// Get all records for the logged-in user
exports.getRecords = async (req, res) => {
  const userId = req.user.id;

  try {
    const records = await pool.query(
      `
      SELECT r.id, c.name AS category_name, r.type, r.amount, r.description, r.transaction_date
      FROM records r
      JOIN categories c ON r.category_id = c.id
      WHERE r.user_id = $1
      ORDER BY r.transaction_date DESC
    `,
      [userId]
    );

    res.json({ records: records.rows });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Server error" });
  }
};
