import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:safe_zone/features/services/models/services_models.dart';
import 'package:safe_zone/l10n/generated/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesProvider extends ChangeNotifier {
  static const String _mediaBucket = 'incident-media';

  List<ServicesModels> localizedServices(AppLocalizations l10n) => [
    ServicesModels(
      title: l10n.police,
      subTitle: l10n.law_enforcement_emergency,
      number: '122',
    ),
    ServicesModels(
      title: l10n.ambluance,
      subTitle: l10n.medical_emergency_services,
      number: '123',
    ),
    ServicesModels(
      title: l10n.fire_department,
      subTitle: l10n.fire_and_rescue_service,
      number: '180',
    ),
  ];

  final incidentController = TextEditingController();
  final descriptionController = TextEditingController();

  PlatformFile? selectedMedia;
  bool isPickingMedia = false;
  bool isSubmittingReport = false;
  String? lastReportError;

  String? get selectedMediaName => selectedMedia?.name;

  String? get selectedMediaType {
    final extension = selectedMedia?.extension?.toLowerCase();
    if (extension == null) return null;

    const imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'};
    const videoExtensions = {'mp4', 'mov', 'avi', 'mkv', 'webm', '3gp'};

    if (imageExtensions.contains(extension)) return 'image';
    if (videoExtensions.contains(extension)) return 'video';
    return 'media';
  }

  Future<void> pickMedia() async {
    isPickingMedia = true;
    lastReportError = null;
    notifyListeners();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'webp',
          'heic',
          'mp4',
          'mov',
          'avi',
          'mkv',
          'webm',
          '3gp',
        ],
      );
      selectedMedia = result?.files.single;
    } finally {
      isPickingMedia = false;
      notifyListeners();
    }
  }

  Future<void> submitIncidentReport(AppLocalizations l10n) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception(l10n.please_login_before_report);
    }

    final incidentType = incidentController.text.trim();
    final description = descriptionController.text.trim();
    if (incidentType.isEmpty && description.isEmpty && selectedMedia == null) {
      throw Exception(l10n.please_add_incident_details);
    }

    isSubmittingReport = true;
    lastReportError = null;
    notifyListeners();

    try {
      String? mediaUrl;
      String? mediaPath;
      final media = selectedMedia;

      if (media?.path != null) {
        final file = File(media!.path!);
        final extension = media.extension ?? 'bin';
        mediaPath =
            '${user.uid}/${DateTime.now().millisecondsSinceEpoch}.$extension';

        try {
          await Supabase.instance.client.storage
              .from(_mediaBucket)
              .upload(
                mediaPath,
                file,
                fileOptions: FileOptions(
                  upsert: true,
                  contentType: _contentTypeFor(media.extension),
                ),
              );

          mediaUrl = Supabase.instance.client.storage
              .from(_mediaBucket)
              .getPublicUrl(mediaPath);
        } catch (_) {
          throw Exception(l10n.media_upload_failed);
        }
      }

      await FirebaseFirestore.instance.collection('incidentReports').add({
        'uid': user.uid,
        'userEmail': user.email,
        'incidentType': incidentType,
        'description': description,
        'mediaUrl': mediaUrl,
        'mediaPath': mediaPath,
        'mediaType': selectedMediaType,
        'createdAt': FieldValue.serverTimestamp(),
      });

      incidentController.clear();
      descriptionController.clear();
      selectedMedia = null;
    } catch (error) {
      lastReportError = error.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isSubmittingReport = false;
      notifyListeners();
    }
  }

  String? _contentTypeFor(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'webm':
        return 'video/webm';
      case '3gp':
        return 'video/3gpp';
      case 'avi':
        return 'video/x-msvideo';
      case 'mkv':
        return 'video/x-matroska';
    }
    return null;
  }

  List<SafeTipsModel> localizedSafeTips(AppLocalizations l10n) => [
    SafeTipsModel(
      icon: Icons.remove_red_eye_outlined,
      title: l10n.stay_aware_of_your_surroundings,
    ),
    SafeTipsModel(
      icon: Icons.location_on_outlined,
      title: l10n.avoid_dark_and_isolated_areas,
    ),
    SafeTipsModel(
      icon: Icons.people_alt_outlined,
      title: l10n.walk_in_groups_when_possible,
    ),
  ];

  @override
  void dispose() {
    incidentController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
