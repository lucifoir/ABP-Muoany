const pool = require('../config/db');
const axios = require('axios'); // untuk call Flask API

exports.addRecord = async (req, res) => {
  const { type, title, amount, description, transaction_date } = req.body;
  const userId = req.user.id;

  try {
    // 1. Predict category dari Flask
    const flaskResponse = await axios.post('http://localhost:5001/predict', {
      title: title
    });

    const predictedCategoryName = flaskResponse.data.predicted_category;

    // 2. Get category_id dari database
    const categoryQuery = await pool.query('SELECT id FROM categories WHERE name = $1', [predictedCategoryName]);
    if (categoryQuery.rows.length === 0) {
      return res.status(400).json({ message: 'Predicted category not found in database' });
    }
    const categoryId = categoryQuery.rows[0].id;

    // 3. Insert record ke database
    const newRecord = await pool.query(
      'INSERT INTO records (user_id, category_id, type, amount, description, transaction_date) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [userId, categoryId, type, amount, description, transaction_date]
    );

    res.status(201).json({ record: newRecord.rows[0] });

  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Server error' });
  }
};

// Get all records for the logged-in user
exports.getRecords = async (req, res) => {
  const userId = req.user.id;

  try {
    const records = await pool.query(`
      SELECT r.id, c.name AS category_name, r.type, r.amount, r.description, r.transaction_date
      FROM records r
      JOIN categories c ON r.category_id = c.id
      WHERE r.user_id = $1
      ORDER BY r.transaction_date DESC
    `, [userId]);

    res.json({ records: records.rows });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Server error' });
  }
};
