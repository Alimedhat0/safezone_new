import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safe_zone/core/services/background_services.dart';
import 'package:safe_zone/features/login/ui/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteAccountProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;
  static const int _batchLimit = 200;

  List<String> listCard = [
    '• Permanently delete all your personal data',
    '• Remove all emergency contacts and settings',
    '• Delete your location history and triggers',
    '• Disable all safety alerts and notifications',
    '• Require creating a new account to use SafeZone',
  ];

  bool isDeletingAccount = false;

  Future<void> _clearLocalUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");
    await clearVoiceKeywords();
  }

  Future<void> _removeSupabaseObject(String bucket, String objectPath) async {
    try {
      await _supabase.storage.from(bucket).remove([objectPath]);
    } catch (e) {
      print('Supabase remove skipped for $bucket/$objectPath: $e');
    }
  }

  String? _extractStoragePathFromUrl(String url, String bucket) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    final marker = '/$bucket/';
    final index = uri.path.indexOf(marker);
    if (index == -1) return null;

    final objectPath = uri.path.substring(index + marker.length).trim();
    if (objectPath.isEmpty) return null;
    return Uri.decodeComponent(objectPath);
  }

  Future<void> _deleteDocsByQuery(
    Query<Map<String, dynamic>> query, {
    Future<void> Function(QueryDocumentSnapshot<Map<String, dynamic>> doc)?
    beforeDelete,
  }) async {
    while (true) {
      final snapshot = await query.limit(_batchLimit).get();
      if (snapshot.docs.isEmpty) return;

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        if (beforeDelete != null) {
          await beforeDelete(doc);
        }
        batch.delete(doc.reference);
      }

      await batch.commit();
    }
  }

  Future<void> _deleteUserSubcollection(String uid, String subcollection) async {
    final ref = _firestore.collection('users').doc(uid).collection(subcollection);

    await _deleteDocsByQuery(ref);
  }

  Future<void> _deleteSecretWordsAndFiles(String uid) async {
    final query = _firestore.collection('secretword').where('uid', isEqualTo: uid);

    await _deleteDocsByQuery(
      query,
      beforeDelete: (doc) async {
        final path = doc.data()['path']?.toString() ?? '';
        final objectPath = _extractStoragePathFromUrl(path, 'secretword');
        if (objectPath != null) {
          await _removeSupabaseObject('secretword', objectPath);
        }
      },
    );
  }

  Future<void> _deleteMessagesAndOwnedVoiceFiles(String uid) async {
    final sentMessagesQuery = _firestore
        .collection('messages')
        .where('senderUid', isEqualTo: uid);

    await _deleteDocsByQuery(
      sentMessagesQuery,
      beforeDelete: (doc) async {
        final data = doc.data();
        final isVoice = data['type']?.toString() == 'voice';
        if (!isVoice) return;

        final voiceUrl = data['content']?.toString() ?? '';
        final objectPath = _extractStoragePathFromUrl(voiceUrl, 'voices');
        if (objectPath != null) {
          await _removeSupabaseObject('voices', objectPath);
        }
      },
    );

    final receivedMessagesQuery = _firestore
        .collection('messages')
        .where('receiverUid', isEqualTo: uid);

    await _deleteDocsByQuery(receivedMessagesQuery);
  }

  Future<void> _deleteReports(String uid) async {
    final query = _firestore
        .collection('reportproblem')
        .where('userId', isEqualTo: uid);

    await _deleteDocsByQuery(query);
  }

  Future<void> _deleteTrustedReferencesFromOthers(String uid) async {
    final query = _firestore
        .collectionGroup('trustedContacts')
        .where('uid', isEqualTo: uid);

    try {
      await _deleteDocsByQuery(query);
    } catch (e) {
      print('Failed to clean trusted references from other users: $e');
    }
  }

  Future<void> _deleteUserDocAndNestedData(String uid) async {
    await _deleteUserSubcollection(uid, 'contacts');
    await _deleteUserSubcollection(uid, 'trustedContacts');
    await _deleteUserSubcollection(uid, 'notifications');
    await _firestore.collection('users').doc(uid).delete();
  }

  Future<void> _deleteRemoteUserData(String uid) async {
    await _deleteSecretWordsAndFiles(uid);
    await _deleteMessagesAndOwnedVoiceFiles(uid);
    await _deleteReports(uid);
    await _deleteTrustedReferencesFromOthers(uid);
    await _deleteUserDocAndNestedData(uid);
  }

  Future<void> deleteCurrentAccount(BuildContext context) async {
    if (isDeletingAccount) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(msg: 'No active account found');
      return;
    }

    isDeletingAccount = true;
    notifyListeners();

    try {
      await stopVoiceService();
      await _deleteRemoteUserData(user.uid);
      await user.delete();
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
      await _clearLocalUserData();
      Fluttertoast.showToast(msg: 'Account deleted successfully');

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Fluttertoast.showToast(
          msg:
              'For security, please login again and retry to finish account deletion',
        );
      } else {
        Fluttertoast.showToast(msg: e.message ?? 'Failed to delete account');
      }
    } catch (_) {
      Fluttertoast.showToast(msg: 'Failed to delete account');
    } finally {
      isDeletingAccount = false;
      notifyListeners();
    }
  }
}
