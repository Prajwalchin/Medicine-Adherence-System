const express = require('express');
const generalController = require('../controllers/generalController.js');
const { authUser } = require('../middlewares/authUser.js');

const router = express.Router();

router.get('/quote', authUser, generalController.quoteOfTheDay);

module.exports = router;
