const path = require('path');

const { supabase } = require('../config/supabase');

const AUDIO_BUCKET = 'sos-audio';

function buildStoragePath(file) {
  const originalName = path.basename(file.originalname || 'audio.aac');
  return `sos/${Date.now()}_${originalName}`;
}

async function uploadAudio(file) {
  const storagePath = buildStoragePath(file);
  const { error } = await supabase.storage
    .from(AUDIO_BUCKET)
    .upload(storagePath, file.buffer, {
      contentType: file.mimetype || 'application/octet-stream',
      upsert: false,
    });

  if (error) {
    const uploadError = new Error(`Supabase storage upload failed: ${error.message}`);
    uploadError.statusCode = 500;
    throw uploadError;
  }

  const {
    data: { publicUrl },
  } = supabase.storage.from(AUDIO_BUCKET).getPublicUrl(storagePath);

  return {
    audioUrl: publicUrl,
    storagePath,
  };
}

async function removeAudio(storagePath) {
  if (!storagePath) {
    return;
  }

  const { error } = await supabase.storage.from(AUDIO_BUCKET).remove([
    storagePath,
  ]);

  if (error) {
    console.error('Failed to remove orphaned Supabase audio:', error.message);
  }
}

module.exports = {
  uploadAudio,
  removeAudio,
};
