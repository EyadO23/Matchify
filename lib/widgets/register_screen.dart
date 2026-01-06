import 'package:flutter/material.dart';
import 'package:matchifiy/models/user.dart';
import 'dart:developer';
import 'package:matchifiy/services/auth_service.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF1E1E2E);
  static const Color inputFieldBg = Color(0xFF28283D);
  static const Color gradientStart = Color(0xFF8A2BE2);
  static const Color gradientEnd = Color(0xFFE0B0FF);
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isSigningUp = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    final loc = AppLocalizations.of(context);

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.pleaseFillFields)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      log(result.toString());
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result != null && result.containsKey('token')) {
        final name = result['name'];
        final username = result['username'];
        final email = result['email'];
        await TokenStorage.saveToken(result['token']);
        await TokenStorage.saveUserData(
          name: name, // أو الاسم القادم من قاعدة بياناتك
          email: email,
          username: username,

          // name: user['full_name'], // أو الاسم القادم من قاعدة بياناتك
          // email: user['email'],
          // username: user['username'],
        );

        // Navigator.pushReplacementNamed(context, '/analysis');
        Navigator.pushReplacementNamed(context, '/home');
        // log(result['name']);
        // log(result['email']);
        // log(result['user']['username']);
        // log('nameis$name');
        // log(email);
        // log(username);
        // log(result['token']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.loginFailedMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.error}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleSignUp() async {
    final loc = AppLocalizations.of(context);

    // التحقق من تعبئة جميع الحقول
    if (_nameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.pleaseFillFields)), // نص مترجم
      );
      return;
    }

    // التحقق من تطابق كلمات المرور
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.passwordsNotMatch)), // نص مترجم
      );
      return;
    }

    setState(() {
      _isSigningUp = true;
    });

    try {
      final user = User(
        id: 0,
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        profilePictureUrl: null,
        apiToken: '',
      );

      final success = await AuthService.register(
        user,
        _passwordController.text.trim(),
        _confirmPasswordController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isSigningUp = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.registrationSuccess), // نص مترجم
            backgroundColor: AppColors.gradientStart,
          ),
        );
        _handleSignIn();
        // Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.registrationFailed), // نص مترجم
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      log('Sign up error: $e');
      setState(() {
        _isSigningUp = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${loc.error}: $e'),
          backgroundColor: Colors.red,
        ), // نص مترجم
      );
    }
  }

  // دالة تبديل اللغة
  // void _toggleLanguage() {
  //   final currentLocale = Localizations.localeOf(context);
  //   final newLocale =
  //       currentLocale.languageCode == 'ar'
  //           ? const Locale('en', '')
  //           : const Locale('ar', '');
  //   MyApp.of(context).setLocale(newLocale);
  // }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // استخدام Directionality لتحديد اتجاه الكتابة (RTL/LTR)
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: CustomBackgroundScaffold(
        // child: Scaffold(
        // backgroundColor: AppColors.primaryDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            // زر تبديل اللغة
            // TextButton(
            //   onPressed: _toggleLanguage,
            //   child: Text(
            //     isArabic ? 'English' : 'العربية',
            //     style: const TextStyle(
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                loc.createAccount, // نص مترجم
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                loc.enterDetails, // نص مترجم
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 40),

              // حقول الإدخال باستخدام النصوص المترجمة
              _buildInputField(loc.fullName, _nameController, 'Ghaleb Marwa'),
              const SizedBox(height: 20),

              _buildInputField(loc.username, _usernameController, 'Ghaleb2004'),
              const SizedBox(height: 20),

              _buildInputField(
                loc.email,
                _emailController,
                'matchify@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // حقل كلمة المرور
              _buildPasswordInputField(
                loc.password,
                _passwordController,
                isConfirmField: false,
              ),
              const SizedBox(height: 20),

              // حقل تأكيد كلمة المرور
              _buildPasswordInputField(
                loc.confirmPassword,
                _confirmPasswordController,
                isConfirmField: true,
              ),

              const SizedBox(height: 60),
              _buildSignUpButton(loc.signUp), // نص الزر مترجم
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ********** دالة مساعدة لحقول الإدخال العادية **********
  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String placeholder, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          // تحديد اتجاه المحاذاة حسب اللغة
          textAlign:
              Localizations.localeOf(context).languageCode == 'ar'
                  ? TextAlign.right
                  : TextAlign.left,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: AppColors.inputFieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 15.0,
            ),
          ),
        ),
      ],
    );
  }

  // ********** دالة مساعدة لحقول كلمة المرور **********
  Widget _buildPasswordInputField(
    String label,
    TextEditingController controller, {
    required bool isConfirmField,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText:
              isConfirmField ? !_isConfirmPasswordVisible : !_isPasswordVisible,
          style: const TextStyle(color: Colors.white),
          // تحديد اتجاه المحاذاة حسب اللغة
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            hintText: '*********',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: AppColors.inputFieldBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 15.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmField
                    ? (_isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off)
                    : (_isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  if (isConfirmField) {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  } else {
                    _isPasswordVisible = !_isPasswordVisible;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // ********** زر التسجيل **********
  Widget _buildSignUpButton(String buttonText) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          // colors: [AppColors.gradientStart, AppColors.gradientEnd],
          colors: [
            Color.fromARGB(255, 114, 116, 228),
            Color.fromARGB(255, 146, 163, 208),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ElevatedButton(
        onPressed: _isSigningUp ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child:
            _isSigningUp
                ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                )
                : Text(
                  buttonText, // النص المترجم
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}
