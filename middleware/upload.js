const multer = require('multer');

const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 20 * 1024 * 1024,
  },
  fileFilter: (req, file, cb) => {
    const looksLikeAudio =
      (file.mimetype || '').startsWith('audio/') ||
      file.mimetype === 'application/octet-stream' ||
      /\.(aac|m4a|mp3|wav|ogg|webm)$/i.test(file.originalname || '');

    if (!looksLikeAudio) {
      cb(new Error('Only audio uploads are allowed for the SOS endpoint.'));
      return;
    }

    cb(null, true);
  },
});

module.exports = upload;
