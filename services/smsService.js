const twilio = require('twilio');

const DEFAULT_SMS_TARGET = '01501518172';

function normalizePhoneNumber(phoneNumber) {
  if (!phoneNumber) {
    return null;
  }

  const trimmedValue = String(phoneNumber).trim();

  if (trimmedValue.startsWith('+')) {
    return trimmedValue;
  }

  const digitsOnly = trimmedValue.replace(/\D/g, '');

  if (!digitsOnly) {
    return null;
  }

  if (digitsOnly.startsWith('00')) {
    return `+${digitsOnly.slice(2)}`;
  }

  if (digitsOnly.startsWith('20')) {
    return `+${digitsOnly}`;
  }

  if (digitsOnly.startsWith('0')) {
    // The target number provided for this project is an Egyptian local mobile number.
    return `+20${digitsOnly.slice(1)}`;
  }

  return `+${digitsOnly}`;
}

function maskPhoneNumber(phoneNumber) {
  if (!phoneNumber) {
    return 'not configured';
  }

  return String(phoneNumber).replace(/(\+?\d{4})\d+(\d{2,4})/, '$1****$2');
}

function buildSmsMessage({ latitude, longitude, audioUrl, userId }) {
  const mapsLink = `https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}`;
  const userLine = userId ? `User ID: ${userId}` : 'User ID: not provided';

  return [
    'SOS alert received from Safe Zone.',
    userLine,
    `Location: ${latitude}, ${longitude}`,
    `Google Maps: ${mapsLink}`,
    `Audio: ${audioUrl}`,
  ].join('\n');
}

async function sendSosSms(payload) {
  const accountSid = process.env.TWILIO_ACCOUNT_SID;
  const authToken = process.env.TWILIO_AUTH_TOKEN;
  const fromNumber = process.env.TWILIO_PHONE_NUMBER;
  const toNumber = normalizePhoneNumber(
    process.env.SMS_TO_NUMBER || DEFAULT_SMS_TARGET,
  );

  console.info(`Sending SOS SMS to ${maskPhoneNumber(toNumber)}.`);

  if (!accountSid || !authToken || !fromNumber) {
    console.warn(
      'Twilio is not fully configured. Skipping SMS delivery for this SOS event.',
    );

    return {
      sent: false,
      skipped: true,
      reason: 'missing_twilio_configuration',
      to: toNumber,
    };
  }

  try {
    const client = twilio(accountSid, authToken);
    const message = await client.messages.create({
      body: buildSmsMessage(payload),
      from: fromNumber,
      to: toNumber,
    });

    return {
      sent: true,
      skipped: false,
      sid: message.sid,
      to: toNumber,
    };
  } catch (error) {
    console.error('SMS delivery failed:', error.message);

    return {
      sent: false,
      skipped: false,
      error: error.message,
      to: toNumber,
    };
  }
}

module.exports = {
  sendSosSms,
};
