const express = require('express');
const router = express.Router();
const { addRecord, getRecords } = require('../controllers/recordController');
const { protect } = require('../middlewares/authMiddleware');

router.post('/', protect, addRecord);   // Protected: user must be logged in
router.get('/', protect, getRecords);   // Protected: user must be logged in

module.exports = router;
