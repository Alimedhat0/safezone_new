import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Safe Zone'**
  String get app_name;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get nav_location;

  /// No description provided for @nav_services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get nav_services;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @nav_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get nav_settings;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login_title;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @please_enter_your_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get please_enter_your_email;

  /// No description provided for @please_enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Password'**
  String get please_enter_your_password;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forget_password;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @continue_with_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continue_with_google;

  /// No description provided for @dont_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_an_account;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @enter_your_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name'**
  String get enter_your_name;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @log_in_alt.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get log_in_alt;

  /// No description provided for @reset_your_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get reset_your_password;

  /// No description provided for @enter_email_to_receive_reset_code.
  ///
  /// In en, this message translates to:
  /// **'Enter Your email to receive a reset code.'**
  String get enter_email_to_receive_reset_code;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @enter_your_email_address.
  ///
  /// In en, this message translates to:
  /// **'Enter Your email address'**
  String get enter_your_email_address;

  /// No description provided for @send_reset_link.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get send_reset_link;

  /// No description provided for @change_email.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get change_email;

  /// No description provided for @change_email_description.
  ///
  /// In en, this message translates to:
  /// **'Update your email address. We will send you a verification code to confirm the change.\nPlease check your gmail SPAM after update'**
  String get change_email_description;

  /// No description provided for @current_email.
  ///
  /// In en, this message translates to:
  /// **'Current Email'**
  String get current_email;

  /// No description provided for @new_email_address.
  ///
  /// In en, this message translates to:
  /// **'New Email Address'**
  String get new_email_address;

  /// No description provided for @enter_new_email_address.
  ///
  /// In en, this message translates to:
  /// **'Enter new email address'**
  String get enter_new_email_address;

  /// No description provided for @please_enter_a_new_email_address.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new email address'**
  String get please_enter_a_new_email_address;

  /// No description provided for @confirm_new_email.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Email'**
  String get confirm_new_email;

  /// No description provided for @reenter_new_email_address.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new email address'**
  String get reenter_new_email_address;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @send_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get send_verification_code;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @change_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and choose a new one to secure your account.'**
  String get change_password_description;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @enter_current_password.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enter_current_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @enter_new_password.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enter_new_password;

  /// No description provided for @please_enter_a_new_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new Password'**
  String get please_enter_a_new_password;

  /// No description provided for @confirm_new_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirm_new_password;

  /// No description provided for @reenter_new_password.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get reenter_new_password;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enter_your_name_alt.
  ///
  /// In en, this message translates to:
  /// **'Enter your Name'**
  String get enter_your_name_alt;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'phone'**
  String get phone;

  /// No description provided for @enter_your_phone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone'**
  String get enter_your_phone;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @change_photo.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get change_photo;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get date_of_birth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @please_select_gender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get please_select_gender;

  /// No description provided for @gender_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get gender_male;

  /// No description provided for @gender_female.
  ///
  /// In en, this message translates to:
  /// **'Femail'**
  String get gender_female;

  /// No description provided for @profile_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated_successfully;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknown_error;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @basic_information.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basic_information;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @view_previous_reports.
  ///
  /// In en, this message translates to:
  /// **'View Pervious reports'**
  String get view_previous_reports;

  /// No description provided for @view_profile.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get view_profile;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @emergency_and_safety.
  ///
  /// In en, this message translates to:
  /// **'Emegency & Safety'**
  String get emergency_and_safety;

  /// No description provided for @trusted_contacts.
  ///
  /// In en, this message translates to:
  /// **'Trusted Contacts'**
  String get trusted_contacts;

  /// No description provided for @emergency_triggers.
  ///
  /// In en, this message translates to:
  /// **'Emergency Triggers'**
  String get emergency_triggers;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @app_theme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get app_theme;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @report_a_problem.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get report_a_problem;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @live_location_sharing.
  ///
  /// In en, this message translates to:
  /// **'Live Location Sharing'**
  String get live_location_sharing;

  /// No description provided for @auto_sos_timer.
  ///
  /// In en, this message translates to:
  /// **'Auto-SOS Timer'**
  String get auto_sos_timer;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @push_notification.
  ///
  /// In en, this message translates to:
  /// **'Push Notification'**
  String get push_notification;

  /// No description provided for @alert_sounds.
  ///
  /// In en, this message translates to:
  /// **'Alert Sounds'**
  String get alert_sounds;

  /// No description provided for @vibration_alerts.
  ///
  /// In en, this message translates to:
  /// **'Vibration Alerts'**
  String get vibration_alerts;

  /// No description provided for @privacy_and_permissions.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Permissions'**
  String get privacy_and_permissions;

  /// No description provided for @location_access.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get location_access;

  /// No description provided for @camera_access.
  ///
  /// In en, this message translates to:
  /// **'Camera Access'**
  String get camera_access;

  /// No description provided for @microphone_access.
  ///
  /// In en, this message translates to:
  /// **'Microphone Access'**
  String get microphone_access;

  /// No description provided for @app_preferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get app_preferences;

  /// No description provided for @help_and_support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help_and_support;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @share_location.
  ///
  /// In en, this message translates to:
  /// **'Share location'**
  String get share_location;

  /// No description provided for @send_your_location_to_contacts.
  ///
  /// In en, this message translates to:
  /// **'send your location to contacts.'**
  String get send_your_location_to_contacts;

  /// No description provided for @live_tracking.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get live_tracking;

  /// No description provided for @last_updated_just_now.
  ///
  /// In en, this message translates to:
  /// **'Last updated: Just now'**
  String get last_updated_just_now;

  /// No description provided for @sms_message.
  ///
  /// In en, this message translates to:
  /// **'SMS message'**
  String get sms_message;

  /// No description provided for @send_message_to_police.
  ///
  /// In en, this message translates to:
  /// **'send  a message to the police'**
  String get send_message_to_police;

  /// No description provided for @emergency_call.
  ///
  /// In en, this message translates to:
  /// **'Emergency Call'**
  String get emergency_call;

  /// No description provided for @call_emergency_services_directly.
  ///
  /// In en, this message translates to:
  /// **'call emergency services directly'**
  String get call_emergency_services_directly;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @home_no_contacts.
  ///
  /// In en, this message translates to:
  /// **'There is no contacts {count}'**
  String home_no_contacts(int count);

  /// No description provided for @sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;

  /// No description provided for @unknown_location.
  ///
  /// In en, this message translates to:
  /// **'Unknown location'**
  String get unknown_location;

  /// No description provided for @error_getting_location.
  ///
  /// In en, this message translates to:
  /// **'Error getting location'**
  String get error_getting_location;

  /// No description provided for @emergency_contacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergency_contacts;

  /// No description provided for @emergency_sos.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get emergency_sos;

  /// No description provided for @police.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get police;

  /// No description provided for @fire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get fire;

  /// No description provided for @ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get ambulance;

  /// No description provided for @domestic_violence_hotline.
  ///
  /// In en, this message translates to:
  /// **'Domestic Violence Hotline'**
  String get domestic_violence_hotline;

  /// No description provided for @mental_health_support_hotline.
  ///
  /// In en, this message translates to:
  /// **'Mental Health Support Hotline'**
  String get mental_health_support_hotline;

  /// No description provided for @road_highway_emergency_services.
  ///
  /// In en, this message translates to:
  /// **'Read Highway Emergency Services'**
  String get road_highway_emergency_services;

  /// No description provided for @national_emergency_hotlines.
  ///
  /// In en, this message translates to:
  /// **'National emergency hotlines'**
  String get national_emergency_hotlines;

  /// No description provided for @report_incident.
  ///
  /// In en, this message translates to:
  /// **'Report Incident'**
  String get report_incident;

  /// No description provided for @document_safety_concerns.
  ///
  /// In en, this message translates to:
  /// **'Document safety concerns'**
  String get document_safety_concerns;

  /// No description provided for @incident_type.
  ///
  /// In en, this message translates to:
  /// **'Incident Type'**
  String get incident_type;

  /// No description provided for @select_incident_type.
  ///
  /// In en, this message translates to:
  /// **'Select incident type'**
  String get select_incident_type;

  /// No description provided for @upload_media.
  ///
  /// In en, this message translates to:
  /// **'Upload Media'**
  String get upload_media;

  /// No description provided for @share_location_title.
  ///
  /// In en, this message translates to:
  /// **'Share Location'**
  String get share_location_title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @describe_what_happened.
  ///
  /// In en, this message translates to:
  /// **'Describe what happened...'**
  String get describe_what_happened;

  /// No description provided for @submit_report.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submit_report;

  /// No description provided for @safe_guide.
  ///
  /// In en, this message translates to:
  /// **'Safe guide'**
  String get safe_guide;

  /// No description provided for @daily_safe_tips.
  ///
  /// In en, this message translates to:
  /// **'Daily safe tips'**
  String get daily_safe_tips;

  /// No description provided for @more_tips.
  ///
  /// In en, this message translates to:
  /// **'More Tips'**
  String get more_tips;

  /// No description provided for @law_enforcement_emergency.
  ///
  /// In en, this message translates to:
  /// **'Law enforcement emergency'**
  String get law_enforcement_emergency;

  /// No description provided for @ambluance.
  ///
  /// In en, this message translates to:
  /// **'Ambluance'**
  String get ambluance;

  /// No description provided for @medical_emergency_services.
  ///
  /// In en, this message translates to:
  /// **'Medical emergency services'**
  String get medical_emergency_services;

  /// No description provided for @fire_department.
  ///
  /// In en, this message translates to:
  /// **'FireDepartment'**
  String get fire_department;

  /// No description provided for @fire_and_rescue_service.
  ///
  /// In en, this message translates to:
  /// **'Fire and rescue service'**
  String get fire_and_rescue_service;

  /// No description provided for @stay_aware_of_your_surroundings.
  ///
  /// In en, this message translates to:
  /// **'Stay aware of your surroundings'**
  String get stay_aware_of_your_surroundings;

  /// No description provided for @avoid_dark_and_isolated_areas.
  ///
  /// In en, this message translates to:
  /// **'Avoid dark and isolated areas'**
  String get avoid_dark_and_isolated_areas;

  /// No description provided for @walk_in_groups_when_possible.
  ///
  /// In en, this message translates to:
  /// **'Walk in groups when possible'**
  String get walk_in_groups_when_possible;

  /// No description provided for @emergency_trigger.
  ///
  /// In en, this message translates to:
  /// **'Emergency Trigger'**
  String get emergency_trigger;

  /// No description provided for @choose_your_emergency_trigger.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Emergency Trigger'**
  String get choose_your_emergency_trigger;

  /// No description provided for @voice_activation.
  ///
  /// In en, this message translates to:
  /// **'Voice Activation'**
  String get voice_activation;

  /// No description provided for @trigger_sos_secret_keyword.
  ///
  /// In en, this message translates to:
  /// **'Trigger SOS when you say a secret keyword'**
  String get trigger_sos_secret_keyword;

  /// No description provided for @shake_the_phone.
  ///
  /// In en, this message translates to:
  /// **'Shake The Phone'**
  String get shake_the_phone;

  /// No description provided for @shake_phone_to_send_alert.
  ///
  /// In en, this message translates to:
  /// **'Shake your phone vigorously to send an emergency alert'**
  String get shake_phone_to_send_alert;

  /// No description provided for @press_power_button_three_times.
  ///
  /// In en, this message translates to:
  /// **'Press Power Button 3 \nTimes'**
  String get press_power_button_three_times;

  /// No description provided for @press_power_button_to_trigger_sos.
  ///
  /// In en, this message translates to:
  /// **'Quickly press the power button three times to trigger SOS'**
  String get press_power_button_to_trigger_sos;

  /// No description provided for @test_trigger.
  ///
  /// In en, this message translates to:
  /// **'Test Trigger'**
  String get test_trigger;

  /// No description provided for @use_triggers_carefully.
  ///
  /// In en, this message translates to:
  /// **'Use triggers carefully to avoid false alerts.'**
  String get use_triggers_carefully;

  /// No description provided for @set_your_emergency_keyword.
  ///
  /// In en, this message translates to:
  /// **'Set Your Emegency Keyword'**
  String get set_your_emergency_keyword;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @tap_to_record_keyword.
  ///
  /// In en, this message translates to:
  /// **'Tap to Record your keyword'**
  String get tap_to_record_keyword;

  /// No description provided for @recommended_one_or_two_words.
  ///
  /// In en, this message translates to:
  /// **'Recommended: 1–2 words only'**
  String get recommended_one_or_two_words;

  /// No description provided for @preview_recorded_keyword.
  ///
  /// In en, this message translates to:
  /// **'Preview your recorded keyword'**
  String get preview_recorded_keyword;

  /// No description provided for @delete_audio.
  ///
  /// In en, this message translates to:
  /// **'Delete Audio?'**
  String get delete_audio;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm_keyword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Keyword'**
  String get confirm_keyword;

  /// No description provided for @detection_sensitivity.
  ///
  /// In en, this message translates to:
  /// **'Detection Sensitivity'**
  String get detection_sensitivity;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @test_voice_trigger.
  ///
  /// In en, this message translates to:
  /// **'Test Voice Trigger'**
  String get test_voice_trigger;

  /// No description provided for @mic_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Mic permission denied'**
  String get mic_permission_denied;

  /// No description provided for @trusted.
  ///
  /// In en, this message translates to:
  /// **'trusted'**
  String get trusted;

  /// No description provided for @search_user_here.
  ///
  /// In en, this message translates to:
  /// **'Search user here...'**
  String get search_user_here;

  /// No description provided for @enter_message_here.
  ///
  /// In en, this message translates to:
  /// **'Enter Message here'**
  String get enter_message_here;

  /// No description provided for @map_style_streets_ar.
  ///
  /// In en, this message translates to:
  /// **'خريطة شوارع'**
  String get map_style_streets_ar;

  /// No description provided for @map_style_hybrid_ar.
  ///
  /// In en, this message translates to:
  /// **'هجينة'**
  String get map_style_hybrid_ar;

  /// No description provided for @map_style_satellite_ar.
  ///
  /// In en, this message translates to:
  /// **'قمر صناعي'**
  String get map_style_satellite_ar;

  /// No description provided for @map_style_streets_arabic_ar.
  ///
  /// In en, this message translates to:
  /// **'شوارع عربية'**
  String get map_style_streets_arabic_ar;

  /// No description provided for @map_style_topo_ar.
  ///
  /// In en, this message translates to:
  /// **'تضاريس'**
  String get map_style_topo_ar;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
