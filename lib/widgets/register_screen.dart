import 'package:flutter/material.dart';
import 'package:matchifiy/models/user.dart';
import 'dart:developer';
import 'package:matchifiy/services/auth_service.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/services/fcm_service.dart';
import 'package:matchifiy/services/firebase_messaging_service.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF1E1E2E);
  static const Color inputFieldBg = Color(0xFF28283D);
  static const Color gradientStart = Color.fromARGB(255, 137, 182, 217);
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

  void _handleSignUp() async {
    final loc = AppLocalizations.of(context);

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

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.passwordsNotMatch)));
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

      final result = await AuthService.register(
        user,
        _passwordController.text.trim(),
        _confirmPasswordController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isSigningUp = false;
      });

      if (result != null && result.containsKey('token')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.registrationSuccess), // نص مترجم
            backgroundColor: AppColors.gradientStart,
          ),
        );
        final name = result['name'];
        final username = result['username'];
        final email = result['email'];
        await TokenStorage.saveToken(result['token']);
        await TokenStorage.saveUserData(
          name: name,
          email: email,
          username: username,
          role: result['role'],
        );

        final fcmToken = await FirebaseMessagingService.init();
        final fcmTokenStoreged = await TokenStorage.getFcmToken();
        if (fcmToken != null && fcmTokenStoreged == null) {
          final success = await FcmService.sendTokenToBackend(fcmToken);

          if (success) {
            log(' FCM token saved successfully');
          } else {
            log(' Failed to save FCM token');
          }
        }
        Navigator.pushReplacementNamed(context, '/analysis');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.registrationFailed),
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
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: CustomBackgroundScaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                loc.createAccount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                loc.enterDetails,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 40),

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

              _buildPasswordInputField(
                loc.password,
                _passwordController,
                isConfirmField: false,
              ),
              const SizedBox(height: 20),

              _buildPasswordInputField(
                loc.confirmPassword,
                _confirmPasswordController,
                isConfirmField: true,
              ),

              const SizedBox(height: 60),
              _buildSignUpButton(loc.signUp),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildSignUpButton(String buttonText) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, Color.fromARGB(255, 137, 182, 217)],
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
                  buttonText,
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
