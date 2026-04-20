const { supabase } = require('../config/supabase');
const { uploadAudio, removeAudio } = require('../services/storageService');
const { sendSosSms } = require('../services/smsService');

function pickAudioFile(files = []) {
  if (!Array.isArray(files) || files.length === 0) {
    return null;
  }

  return files.find((file) => file.fieldname === 'audio') || null;
}

function parseRequiredNumber(value, fieldName) {
  const parsedValue = Number(value);

  if (!Number.isFinite(parsedValue)) {
    const error = new Error(`${fieldName} must be a valid number.`);
    error.statusCode = 400;
    throw error;
  }

  return parsedValue;
}

function parseOptionalUid(value) {
  if (typeof value !== 'string') {
    return null;
  }

  const trimmedValue = value.trim();
  return trimmedValue === '' ? null : trimmedValue;
}

async function createSosEvent(req, res, next) {
  try {
    const audioFile = pickAudioFile(req.files);

    if (!audioFile) {
      const error = new Error('An audio file is required in multipart/form-data.');
      error.statusCode = 400;
      throw error;
    }

    const latitude = parseRequiredNumber(req.body.lat, 'lat');
    const longitude = parseRequiredNumber(req.body.lon, 'lon');
    const userId = parseOptionalUid(req.body.uid);

    const { audioUrl, storagePath } = await uploadAudio(audioFile);

    const { data, error: dbError } = await supabase
      .from('sos_events')
      .insert({
        user_id: userId,
        latitude,
        longitude,
        audio_url: audioUrl,
      })
      .select('id, user_id, latitude, longitude, audio_url, created_at')
      .single();

    if (dbError) {
      await removeAudio(storagePath);

      const error = new Error(`Supabase database insert failed: ${dbError.message}`);
      error.statusCode = 500;
      throw error;
    }

    let smsSent = false;

    try {
      const smsResult = await sendSosSms({
        userId,
        latitude,
        longitude,
        audioUrl,
      });
      smsSent = Boolean(smsResult.sent);
    } catch (smsError) {
      console.error('SMS delivery failed:', smsError.message);
    }

    return res.status(201).json({
      success: true,
      message: 'SOS received successfully.',
      data: {
        id: data.id,
        userId: data.user_id,
        latitude: data.latitude,
        longitude: data.longitude,
        audioUrl: data.audio_url,
        createdAt: data.created_at,
        smsSent,
      },
    });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  createSosEvent,
};
