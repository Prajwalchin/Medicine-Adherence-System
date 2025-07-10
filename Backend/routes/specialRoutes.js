const express = require('express');
const specialController = require('../controllers/specialController.js');
const { authUser } = require('../middlewares/authUser.js');

const router = express.Router();

router.get('/dashboard', authUser, specialController.getDashboard);

module.exports = router;