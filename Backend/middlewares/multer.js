const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + "-" + Date.now() + path.extname(file.originalname));
  },
});

const fileFilter = (req, file, cb) => {
  // const allowedTypes = ["image/jpeg", "image/png", "audio/mpeg", "audio/wav", "image/jpg"];
  // if (allowedTypes.includes(file.mimetype)) {
  //   cb(null, true);
  // } else {
  //   cb(new Error("Only images and audio files are allowed"), false);
  // }
  cb(null, true);
};

const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: { fileSize: 10 * 1024 * 1024 },
});

module.exports = upload;
