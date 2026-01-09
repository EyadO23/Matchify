import 'package:flutter/material.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/services/auth_service.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  String _translate(BuildContext context, String key) {
    final localization = AppLocalizations.of(context);

    switch (key) {
      case 'title':
        return localization.forgotPassword;
      case 'username':
        return localization.username;
      case 'email':
        return localization.email;
      case 'send':
        return localization.locale.languageCode == 'ar'
            ? 'إرسال رابط الاستعادة'
            : 'Send Reset Link';
      case 'subtitle':
        return localization.locale.languageCode == 'ar'
            ? 'أدخل بياناتك لاستلام رابط تعيين كلمة المرور'
            : 'Enter your details to receive a password reset link';
      case 'fill_fields':
        return localization.pleaseFillFields;
      case 'success_msg':
        return localization.locale.languageCode == 'ar'
            ? 'تم إرسال الرابط بنجاح!'
            : 'Reset link sent successfully!';
      default:
        return key;
    }
  }

  Future<void> _handleReset() async {
    final msgFill = _translate(context, 'fill_fields');

    if (_usernameController.text.isEmpty || _emailController.text.isEmpty) {
      _showSnackBar(msgFill, Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.sendResetLink(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      _showSuccessDialog(
        result['message'] ?? _translate(context, 'success_msg'),
      );
    } else {
      _showSnackBar(
        result['message'] ?? AppLocalizations.of(context).error,
        Colors.redAccent,
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.pushNamed(context, '/reset-password'),

                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final isAr = localization.locale.languageCode == 'ar';

    return CustomBackgroundScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.lock_reset_rounded,
                size: 80,
                color: Color.fromARGB(255, 137, 182, 217),
              ),
              const SizedBox(height: 20),
              Text(
                _translate(context, 'title'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _translate(context, 'subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                controller: _usernameController,
                label: _translate(context, 'username'),
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: _translate(context, 'email'),
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleReset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 137, 182, 217),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            _translate(context, 'send'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38),

        prefixIcon: Icon(icon, color: Color.fromARGB(255, 137, 182, 217)),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
