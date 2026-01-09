// import 'package:flutter/material.dart';

// class AppLocalizations {
//   final Locale locale;
//   AppLocalizations(this.locale);

//   static const Map<String, Map<String, String>> _localizedValues = {
//     'en': {
//       // General
//       'error': 'Error',
//       'language_name': 'English',
//       'switch_to_arabic': 'Switch to Arabic',

//       // Sign In Screen
//       'welcome_title': 'Welcome Back',
//       'welcome_subtitle': 'Sign in to continue to your account.',
//       'email': 'Email',
//       'password': 'Password',
//       'forgot_password': 'Forgot Password?',
//       'sign_in': 'SIGN IN',
//       'no_account': 'Don\'t have an account?',
//       'register_now': 'Register Now',
//       'login_failed_message': 'Login failed. Please check your credentials.',
//       'please_fill_fields': 'Please fill all fields.',
//       'or_login_with': 'Or log in with',
//       'google': 'Google',
//       'signing_in': 'Signing In...',
//       'google_login_failed': 'Google sign-in failed. Please try again.',

//       // Register Screen
//       'create_account': 'Create Account',
//       'enter_details': 'Enter your details to create an account',
//       'full_name': 'Full Name',
//       'username': 'Username',
//       'confirm_password': 'Confirm Password',
//       'sign_up': 'SIGN UP',
//       'passwords_not_match': 'Passwords do not match.',
//       'registration_success': 'Account registered successfully!',
//       'registration_failed':
//           'Registration failed. Check your data or try again later.',

//       // Match Analysis Screen
//       'match_analysis': 'Match Analysis',
//       'video_link_label': 'Enter the video link',
//       'video_link_hint': 'https://example.com/match.mp4',
//       'player_name_label': 'Favorite Player Name (optional)',
//       'player_name_hint': 'Enter player name',
//       'select_filter_type': 'Select Filter Type',
//       'filter_goals': 'Goals Only',
//       'filter_red_card': 'Red Card',
//       'filter_yellow_card': 'Yellow Card',
//       'filter_player_shots': 'Favorite player shots',
//       'select_summary_length': 'Select Summary Length',
//       'summary_long': 'Long',
//       'summary_short': 'Short',
//       'start_analysis': 'Start Analysis',
//       'please_enter_link': 'Please enter a video link.',
//       'analysis_finished': 'Analysis finished',
//       'summary': 'Summary',
//       'ai_prediction': 'AI Prediction',
//       'team_a': 'Team A',
//       'team_b': 'Team B',
//       'analyze_now': 'Analyze Now',
//       'recent_matches': 'Recent Matches',
//       'invalidEmail': 'Please enter a valid email.', // بالإنجليزية
//       'passwordTooShort':
//           'Password must be at least 6 characters.', // بالإنجليزية
//     },
//     'ar': {
//       'invalidEmail': 'يرجى إدخال بريد إلكتروني صالح.',
//       'passwordTooShort': 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل.',
//       'connectionError':
//           'حدث خطأ أثناء الاتصال، يرجى المحاولة مرة أخرى.', // لرسائل catch
//       // عام
//       'error': 'خطأ',
//       'language_name': 'العربية',
//       'switch_to_arabic': 'التحويل إلى العربية',

//       // شاشة تسجيل الدخول
//       'welcome_title': 'مرحباً بعودتك',
//       'welcome_subtitle': 'سجل الدخول للمتابعة إلى حسابك.',
//       'email': 'البريد الإلكتروني',
//       'password': 'كلمة المرور',
//       'forgot_password': 'هل نسيت كلمة المرور؟',
//       'sign_in': 'تسجيل الدخول',
//       'no_account': 'ليس لديك حساب؟',
//       'register_now': 'سجل الآن',
//       'login_failed_message': 'فشل تسجيل الدخول. يرجى التحقق من بياناتك.',
//       'please_fill_fields': 'يرجى ملء جميع الحقول.',
//       'or_login_with': 'أو سجل الدخول عبر',
//       'google': 'جوجل',
//       'signing_in': 'جاري تسجيل الدخول...',
//       'google_login_failed':
//           'فشل تسجيل الدخول عبر جوجل. الرجاء المحاولة مرة أخرى.',

//       // شاشة التسجيل
//       'create_account': 'إنشاء حساب',
//       'enter_details': 'أدخل بياناتك لإنشاء حساب',
//       'full_name': 'الاسم الكامل',
//       'username': 'اسم المستخدم',
//       'confirm_password': 'تأكيد كلمة المرور',
//       'sign_up': 'تسجيل جديد',
//       'passwords_not_match': 'كلمات المرور غير متطابقة.',
//       'registration_success': 'تم تسجيل الحساب بنجاح!',
//       'registration_failed': 'فشل التسجيل. تحقق من البيانات وحاول لاحقاً.',

//       // شاشة تحليل المباراة
//       'match_analysis': 'تحليل المباراة',
//       'video_link_label': 'أدخل رابط الفيديو',
//       'video_link_hint': 'https://example.com/match.mp4',
//       'player_name_label': 'اسم اللاعب المفضل (اختياري)',
//       'player_name_hint': 'أدخل اسم اللاعب',
//       'select_filter_type': 'اختر نوع الفلتر',
//       'filter_goals': 'أهداف فقط',
//       'filter_red_card': 'بطاقة حمراء',
//       'filter_yellow_card': 'بطاقة صفراء',
//       'filter_player_shots': 'لقطات لاعب معين',
//       'select_summary_length': 'اختر طول الملخص',
//       'summary_long': 'طويل',
//       'summary_short': 'قصير',
//       'start_analysis': 'بدء التحليل',
//       'please_enter_link': 'يرجى إدخال رابط الفيديو.',
//       'analysis_finished': 'انتهى التحليل',
//       'summary': 'الملخص',
//       'ai_prediction': 'توقعات الذكاء الاصطناعي',
//       'team_a': 'الفريق أ',
//       'team_b': 'الفريق ب',
//       'analyze_now': 'حلل الآن',
//       'recent_matches': 'المباريات الأخيرة',
//     },
//   };

//   String _get(String key) => _localizedValues[locale.languageCode]?[key] ?? key;

//   // Getters - General
//   String get error => _get('error'); // Added for compatibility with error logs
//   String get errorLabel => _get('error');
//   String get languageName => _get('language_name');
//   String get switchToArabic => _get('switch_to_arabic');

//   // Getters - Sign In
//   String get welcomeTitle => _get('welcome_title');
//   String get welcomeSubtitle => _get('welcome_subtitle');
//   String get email => _get('email');
//   String get password => _get('password');
//   String get forgotPassword => _get('forgot_password');
//   String get signIn => _get('sign_in');
//   String get noAccount => _get('no_account');
//   String get registerNow => _get('register_now');
//   String get loginFailedMessage => _get('login_failed_message');
//   String get pleaseFillFields => _get('please_fill_fields');
//   String get orLoginWith => _get('or_login_with');
//   String get google => _get('google');
//   String get signingIn => _get('signing_in');
//   String get googleLoginFailed => _get('google_login_failed');

//   // Getters - Register
//   String get createAccount => _get('create_account');
//   String get enterDetails => _get('enter_details');
//   String get fullName => _get('full_name');
//   String get username => _get('username');
//   String get confirmPassword => _get('confirm_password');
//   String get signUp => _get('sign_up');
//   String get passwordsNotMatch => _get('passwords_not_match');
//   String get registrationSuccess => _get('registration_success');
//   String get registrationFailed => _get('registration_failed');

//   // Getters - Analysis
//   String get matchAnalysis => _get('match_analysis');
//   String get videoLinkLabel => _get('video_link_label');
//   String get videoLinkHint => _get('video_link_hint');
//   String get playerNameLabel => _get('player_name_label');
//   String get playerNameHint => _get('player_name_hint');
//   String get selectFilterType => _get('select_filter_type');
//   String get filterGoals => _get('filter_goals');
//   String get filterRedCard => _get('filter_red_card');
//   String get filterYellowCard => _get('filter_yellow_card');
//   String get filterPlayerShots => _get('filter_player_shots');
//   String get selectSummaryLength => _get('select_summary_length');
//   String get summaryLong => _get('summary_long');
//   String get summaryShort => _get('summary_short');
//   String get startAnalysis => _get('start_analysis');
//   String get pleaseEnterLink => _get('please_enter_link');
//   String get analysisFinished => _get('analysis_finished');
//   String get summaryLabel => _get('summary');

//   // New Getters from Error Logs
//   String get aiPrediction => _get('ai_prediction');
//   String get teamA => _get('team_a');
//   String get teamB => _get('team_b');
//   String get analyzeNow => _get('analyze_now');
//   String get recentMatches => _get('recent_matches');

//   static AppLocalizations of(BuildContext context) =>
//       Localizations.of<AppLocalizations>(context, AppLocalizations)!;

//   static const LocalizationsDelegate<AppLocalizations> delegate =
//       _AppLocalizationsDelegate();
// }

// class _AppLocalizationsDelegate
//     extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();
//   @override
//   bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);
//   @override
//   Future<AppLocalizations> load(Locale locale) async =>
//       AppLocalizations(locale);
//   @override
//   bool shouldReload(_AppLocalizationsDelegate old) => false;
// }
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // ================= General =================
      'error': 'Error',
      'language_name': 'English',
      'switch_to_arabic': 'Switch to Arabic',

      // ================= Sign In Screen =================
      'welcome_title': 'Welcome Back',
      'welcome_subtitle': 'Sign in to continue to your account.',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'sign_in': 'SIGN IN',
      'no_account': 'Don\'t have an account?',
      'register_now': 'Register Now',
      'login_failed_message': 'Login failed. Please check your credentials.',
      'please_fill_fields': 'Please fill all fields.',
      'or_login_with': 'Or log in with',
      'google': 'Google',
      'signing_in': 'Signing In...',
      'google_login_failed': 'Google sign-in failed. Please try again.',

      // ================= Register Screen =================
      'create_account': 'Create Account',
      'enter_details': 'Enter your details to create an account',
      'full_name': 'Full Name',
      'username': 'Username',
      'confirm_password': 'Confirm Password',
      'sign_up': 'SIGN UP',
      'passwords_not_match': 'Passwords do not match.',
      'registration_success': 'Account registered successfully!',
      'registration_failed':
          'Registration failed. Check your data or try again later.',

      // ================= Match Analysis Screen =================
      'match_analysis': 'Match Analysis',
      'video_link_label': 'Enter the video link',
      'video_link_hint': 'https://example.com/match.mp4',
      'player_name_label': 'Favorite Player Name (optional)',
      'player_name_hint': 'Enter player name',
      'select_filter_type': 'Select Filter Type',
      'filter_goals': 'Goals Only',
      'filter_red_card': 'Red Card',
      'filter_yellow_card': 'Yellow Card',
      'filter_player_shots': 'Favorite player shots',
      'select_summary_length': 'Select Summary Length',
      'summary_long': 'Long',
      'summary_short': 'Short',
      'start_analysis': 'Start Analysis',
      'please_enter_link': 'Please enter a video link.',
      'analysis_finished': 'Analysis finished',
      'summary': 'Summary',
      'ai_prediction': 'AI Prediction',
      'team_a': 'Team A',
      'team_b': 'Team B',
      'analyze_now': 'Analyze Now',
      'recent_matches': 'Recent Matches',

      // ================= Validation =================
      'invalidEmail': 'Please enter a valid email.',
      'passwordTooShort': 'Password must be at least 6 characters.',

      // ================= Users Management (NEW) =================
      'users_management_title': 'Users Management',
      'empty_list': 'The list is empty',
      'confirm_delete': 'Confirm Deletion',
      'confirm_delete_message':
          'Do you really want to delete {name} and all their data?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'video_id': 'Video ID',
      'summary_type': 'Type',
      'processing_status': 'Status',
    },

    'ar': {
      // ================= Validation =================
      'invalidEmail': 'يرجى إدخال بريد إلكتروني صالح.',
      'passwordTooShort': 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل.',
      'connectionError': 'حدث خطأ أثناء الاتصال، يرجى المحاولة مرة أخرى.',

      // ================= General =================
      'error': 'خطأ',
      'language_name': 'العربية',
      'switch_to_arabic': 'التحويل إلى العربية',

      // ================= Sign In Screen =================
      'welcome_title': 'مرحباً بعودتك',
      'welcome_subtitle': 'سجل الدخول للمتابعة إلى حسابك.',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'forgot_password': 'هل نسيت كلمة المرور؟',
      'sign_in': 'تسجيل الدخول',
      'no_account': 'ليس لديك حساب؟',
      'register_now': 'سجل الآن',
      'login_failed_message': 'فشل تسجيل الدخول. يرجى التحقق من بياناتك.',
      'please_fill_fields': 'يرجى ملء جميع الحقول.',
      'or_login_with': 'أو سجل الدخول عبر',
      'google': 'جوجل',
      'signing_in': 'جاري تسجيل الدخول...',
      'google_login_failed':
          'فشل تسجيل الدخول عبر جوجل. الرجاء المحاولة مرة أخرى.',

      // ================= Register Screen =================
      'create_account': 'إنشاء حساب',
      'enter_details': 'أدخل بياناتك لإنشاء حساب',
      'full_name': 'الاسم الكامل',
      'username': 'اسم المستخدم',
      'confirm_password': 'تأكيد كلمة المرور',
      'sign_up': 'تسجيل جديد',
      'passwords_not_match': 'كلمات المرور غير متطابقة.',
      'registration_success': 'تم تسجيل الحساب بنجاح!',
      'registration_failed': 'فشل التسجيل. تحقق من البيانات وحاول لاحقاً.',

      // ================= Match Analysis Screen =================
      'match_analysis': 'تحليل المباراة',
      'video_link_label': 'أدخل رابط الفيديو',
      'video_link_hint': 'https://example.com/match.mp4',
      'player_name_label': 'اسم اللاعب المفضل (اختياري)',
      'player_name_hint': 'أدخل اسم اللاعب',
      'select_filter_type': 'اختر نوع الفلتر',
      'filter_goals': 'أهداف فقط',
      'filter_red_card': 'بطاقة حمراء',
      'filter_yellow_card': 'بطاقة صفراء',
      'filter_player_shots': 'لقطات لاعب معين',
      'select_summary_length': 'اختر طول الملخص',
      'summary_long': 'طويل',
      'summary_short': 'قصير',
      'start_analysis': 'بدء التحليل',
      'please_enter_link': 'يرجى إدخال رابط الفيديو.',
      'analysis_finished': 'انتهى التحليل',
      'summary': 'الملخص',
      'ai_prediction': 'توقعات الذكاء الاصطناعي',
      'team_a': 'الفريق أ',
      'team_b': 'الفريق ب',
      'analyze_now': 'حلل الآن',
      'recent_matches': 'المباريات الأخيرة',

      // ================= Users Management (NEW) =================
      'users_management_title': 'إدارة المستخدمين',
      'empty_list': 'القائمة فارغة',
      'confirm_delete': 'تأكيد الحذف',
      'confirm_delete_message': 'هل تريد حقاً حذف {name} وكل بياناته؟',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'video_id': 'فيديو ID',
      'summary_type': 'النوع',
      'processing_status': 'الحالة',
    },
  };

  String _get(String key) => _localizedValues[locale.languageCode]?[key] ?? key;

  // ================= Existing Getters (UNCHANGED) =================
  String get error => _get('error');
  String get errorLabel => _get('error');
  String get languageName => _get('language_name');
  String get switchToArabic => _get('switch_to_arabic');

  String get welcomeTitle => _get('welcome_title');
  String get welcomeSubtitle => _get('welcome_subtitle');
  String get email => _get('email');
  String get password => _get('password');
  String get forgotPassword => _get('forgot_password');
  String get signIn => _get('sign_in');
  String get noAccount => _get('no_account');
  String get registerNow => _get('register_now');
  String get loginFailedMessage => _get('login_failed_message');
  String get pleaseFillFields => _get('please_fill_fields');
  String get orLoginWith => _get('or_login_with');
  String get google => _get('google');
  String get signingIn => _get('signing_in');
  String get googleLoginFailed => _get('google_login_failed');

  String get createAccount => _get('create_account');
  String get enterDetails => _get('enter_details');
  String get fullName => _get('full_name');
  String get username => _get('username');
  String get confirmPassword => _get('confirm_password');
  String get signUp => _get('sign_up');
  String get passwordsNotMatch => _get('passwords_not_match');
  String get registrationSuccess => _get('registration_success');
  String get registrationFailed => _get('registration_failed');

  String get matchAnalysis => _get('match_analysis');
  String get videoLinkLabel => _get('video_link_label');
  String get videoLinkHint => _get('video_link_hint');
  String get playerNameLabel => _get('player_name_label');
  String get playerNameHint => _get('player_name_hint');
  String get selectFilterType => _get('select_filter_type');
  String get filterGoals => _get('filter_goals');
  String get filterRedCard => _get('filter_red_card');
  String get filterYellowCard => _get('filter_yellow_card');
  String get filterPlayerShots => _get('filter_player_shots');
  String get selectSummaryLength => _get('select_summary_length');
  String get summaryLong => _get('summary_long');
  String get summaryShort => _get('summary_short');
  String get startAnalysis => _get('start_analysis');
  String get pleaseEnterLink => _get('please_enter_link');
  String get analysisFinished => _get('analysis_finished');
  String get summaryLabel => _get('summary');
  String get aiPrediction => _get('ai_prediction');
  String get teamA => _get('team_a');
  String get teamB => _get('team_b');
  String get analyzeNow => _get('analyze_now');
  String get recentMatches => _get('recent_matches');

  // ================= Users Management Getters (NEW) =================
  String get usersManagementTitle => _get('users_management_title');
  String get emptyList => _get('empty_list');
  String get confirmDelete => _get('confirm_delete');
  String confirmDeleteMessage(String name) =>
      _get('confirm_delete_message').replaceAll('{name}', name);
  String get cancel => _get('cancel');
  String get delete => _get('delete');

  // ================= ADD translate =================
  /// Generic translate method for dynamic keys or legacy usage
  String translate(String key) => _get(key);

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
