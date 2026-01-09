import 'package:flutter/material.dart';
import 'package:matchifiy/services/auth_service.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialToken;

  const ResetPasswordScreen({
    super.key,
    this.initialEmail,
    this.initialToken,
    required String tokenFromEmail,
    required String emailFromEmail,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController _emailController;
  late TextEditingController _tokenController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? "");
    _tokenController = TextEditingController(text: widget.initialToken ?? "");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleReset() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (_emailController.text.isEmpty ||
        _tokenController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      _showSnackBar(
        isArabic ? "يرجى تعبئة جميع الحقول" : "Please fill all fields",
        isError: true,
      );
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      _showSnackBar(
        isArabic ? "كلمتا المرور غير متطابقتين" : "Passwords do not match",
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dynamic result = await AuthService.resetPassword(
        email: _emailController.text.trim(),
        token: _tokenController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmController.text,
      );

      setState(() => _isLoading = false);

      final bool isSuccess = result['success'] == true;

      if (isSuccess) {
        _showSnackBar(
          isArabic
              ? "تم تغيير كلمة المرور بنجاح!"
              : "Password changed successfully!",
          isError: false,
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
        });
      } else {
        String errorMessage = isArabic ? "حدث خطأ ما" : "An error occurred";
        if (result != null && result['data'] != null) {
          errorMessage =
              result['data']['message']?.toString() ??
              (isArabic ? "خطأ من السيرفر" : "Error from server");
        }
        _showSnackBar(errorMessage, isError: true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar(
        isArabic ? "خطأ في الاتصال: $e" : "Connection error: $e",
        isError: true,
      );
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return CustomBackgroundScaffold(
      appBar: AppBar(
        title: Text(isArabic ? "كلمة المرور الجديدة" : "New Password"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic ? "إعادة تعيين الحساب" : "Reset Your Account",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? "قم بتعيين كلمة المرور الجديدة أدناه لاستعادة الوصول إلى حسابك."
                  : "Set your new password below to regain access to your account.",
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 30),

            _buildField(
              controller: _emailController,
              label: isArabic ? "البريد الإلكتروني" : "Email Address",
              hint: isArabic ? "example@yourname.com" : "yourname@example.com",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              readOnly: widget.initialEmail != null,
            ),
            const SizedBox(height: 18),

            _buildField(
              controller: _tokenController,
              label: isArabic ? "رمز التحقق" : "Verification Code (Token)",
              hint:
                  isArabic
                      ? "أدخل الرمز المرسل بالبريد"
                      : "Enter code from email",
              icon: Icons.security_outlined,
              readOnly: widget.initialToken != null,
            ),
            const SizedBox(height: 18),

            _buildField(
              controller: _passwordController,
              label: isArabic ? "كلمة المرور الجديدة" : "New Password",
              hint: "••••••••",
              icon: Icons.lock_outline,
              isPass: true,
              isObscured: _isObscure,
              onToggleVisibility:
                  () => setState(() => _isObscure = !_isObscure),
            ),
            const SizedBox(height: 18),

            _buildField(
              controller: _confirmController,
              label: isArabic ? "تأكيد كلمة المرور" : "Confirm New Password",
              hint: "••••••••",
              icon: Icons.lock_reset_outlined,
              isPass: true,
              isObscured: _isConfirmObscure,
              onToggleVisibility:
                  () => setState(() => _isConfirmObscure = !_isConfirmObscure),
            ),
            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 137, 182, 217),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                onPressed: _isLoading ? null : _handleReset,
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          isArabic ? "تحديث كلمة المرور" : "Update Password",
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
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPass = false,
    bool isObscured = false,
    bool readOnly = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: isPass ? isObscured : false,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: TextStyle(color: readOnly ? Colors.white38 : Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
            prefixIcon: Icon(
              icon,
              color: const Color.fromARGB(255, 137, 182, 217),
              size: 22,
            ),
            suffixIcon:
                isPass
                    ? IconButton(
                      icon: Icon(
                        isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white38,
                      ),
                      onPressed: onToggleVisibility,
                    )
                    : null,
            filled: true,
            fillColor: const Color(0xFF1E293B),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 137, 182, 217),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
