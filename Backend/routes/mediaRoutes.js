const express = require("express");
const mediaController = require("../controllers/mediaController");
const { authUser } = require('../middlewares/authUser.js');

const router = express.Router();

router.post("/uploadPrescription", authUser, mediaController.uploadPrescription);
router.post("/uploadVoiceNote/:course_id", mediaController.uploadVoiceNote);

module.exports = router;
