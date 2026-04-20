const express = require('express');

const upload = require('../middleware/upload');
const { createSosEvent } = require('../controllers/sosController');

const router = express.Router();

router.post('/sos', upload.any(), createSosEvent);

module.exports = router;
