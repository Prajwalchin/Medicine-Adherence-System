const express = require('express');
const authController = require('../controllers/authController.js');
const { authUser } = require('../middlewares/authUser.js');


const router = express.Router();

router.post('/login', authController.login);
router.post('/complete-registration', authUser, authController.register);
router.get('/logout', authController.logout);
router.get('/validate', authController.validate);
router.post('/initializelogin', authController.initializeLogin);

module.exports = router;