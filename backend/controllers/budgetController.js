const pool = require("../config/db");

// Create or update a budget
exports.upsertBudget = async (req, res) => {
  const { category_name, limit_amount, month_year } = req.body;
  const userId = req.user.id;
  const currentMonthYear = new Date().toISOString().slice(0, 7); // 'YYYY-MM'

  try {
    const existing = await pool.query(
      `SELECT * FROM budgets WHERE user_id = $1 AND category_name = $2 AND month_year = $3`,
      [userId, category_name, currentMonthYear]
    );

    if (existing.rows.length > 0) {
      // update
      await pool.query(
        `UPDATE budgets SET limit_amount = $1 WHERE user_id = $2 AND category_name = $3 AND month_year = $4`,
        [limit_amount, userId, category_name, currentMonthYear]
      );
      res.status(200).json({ message: "Budget updated" });
    } else {
      // insert
      const result = await pool.query(
        `INSERT INTO budgets (user_id, category_name, limit_amount, spent_amount, month_year)
           VALUES ($1, $2, $3, 0, $4) RETURNING *`,
        [userId, category_name, limit_amount, currentMonthYear]
      );
      res.status(201).json({ budget: result.rows[0] });
    }
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Server error" });
  }
};

exports.deleteBudgetById = async (req, res) => {
  const { id } = req.params;
  const userId = req.user.id;

  try {
    const result = await pool.query(
      `DELETE FROM budgets WHERE id = $1 AND user_id = $2`,
      [id, userId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Budget not found or unauthorized" });
    }

    res.status(200).json({ message: "Budget deleted successfully" });
  } catch (error) {
    console.error("❌ Error deleting budget:", error.message);
    res.status(500).json({ message: "Server error" });
  }
};

exports.updateBudgetById = async (req, res) => {
  const { category_name, limit_amount } = req.body;
  const { id } = req.params;
  const userId = req.user.id;

  try {
    await pool.query(
      `UPDATE budgets SET category_name = $1, limit_amount = $2 WHERE id = $3 AND user_id = $4`,
      [category_name, limit_amount, id, userId]
    );

    res.status(200).json({ message: "Budget updated" });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: "Server error" });
  }
};

// Get budgets for user (optionally filter by month)
exports.getBudgets = async (req, res) => {
  const userId = req.user.id;

  try {
    const result = await pool.query(
      `
      SELECT 
        b.id,
        b.category_name,
        b.limit_amount,
        COALESCE((
          SELECT SUM(r.amount)
          FROM records r
          JOIN categories c ON r.category_id = c.id
          WHERE r.user_id = b.user_id
            AND c.name = b.category_name
            AND TO_CHAR(r.transaction_date, 'YYYY-MM') = b.month_year
            AND r.type = 'expense'
        ), 0) AS spent_amount
      FROM budgets b
      WHERE b.user_id = $1
    `,
      [userId]
    );

    res.status(200).json({ budgets: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

