const { admin } = require('../config/firebase');

const firestore = admin.firestore();

async function notifyTrustedContacts({ userId, latitude, longitude }) {
  if (!userId) {
    return { sent: 0, trustedCount: 0 };
  }

  const trustedSnapshot = await firestore
    .collection('users')
    .doc(userId)
    .collection('trustedContacts')
    .get();

  if (trustedSnapshot.empty) {
    return { sent: 0, trustedCount: 0 };
  }

  const senderSnapshot = await firestore.collection('users').doc(userId).get();
  const senderName = senderSnapshot.data()?.name || 'Someone';
  const mapUrl = `https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}`;

  let sent = 0;
  const notificationWrites = [];

  for (const trustedDoc of trustedSnapshot.docs) {
    const trustedUid = trustedDoc.id;
    const trustedUserSnapshot = await firestore.collection('users').doc(trustedUid).get();
    const trustedUser = trustedUserSnapshot.data() || {};

    const notificationRef = firestore
      .collection('users')
      .doc(trustedUid)
      .collection('notifications')
      .doc();

    notificationWrites.push(
      notificationRef.set({
        title: 'SOS Alert',
        body: `${senderName} needs help. Location: ${mapUrl}`,
        date: new Date().toISOString(),
      }),
    );

    if (!trustedUser.fcmToken) {
      continue;
    }

    try {
      await admin.messaging().send({
        token: trustedUser.fcmToken,
        notification: {
          title: 'SOS Alert',
          body: `${senderName} needs help. Tap to view the location.`,
        },
        data: {
          type: 'sos',
          senderUid: userId,
          lat: String(latitude),
          lon: String(longitude),
          mapUrl,
        },
      });
      sent += 1;
    } catch (error) {
      console.error(`Failed to send SOS push to ${trustedUid}:`, error.message);
    }
  }

  await Promise.all(notificationWrites);

  return {
    sent,
    trustedCount: trustedSnapshot.size,
  };
}

module.exports = {
  notifyTrustedContacts,
};
