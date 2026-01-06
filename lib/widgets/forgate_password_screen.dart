// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/auth_service.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _handleReset() async {
//     if (_usernameController.text.isEmpty || _emailController.text.isEmpty) {
//       _showSnackBar("يرجى ملء جميع الحقول", Colors.orange);
//       return;
//     }

//     setState(() => _isLoading = true);

//     final result = await AuthService.sendResetLink(
//       username: _usernameController.text.trim(),
//       email: _emailController.text.trim(),
//     );

//     setState(() => _isLoading = false);

//     if (result['success']) {
//       _showSuccessDialog(result['message']);
//     } else {
//       _showSnackBar(result['message'], Colors.redAccent);
//     }
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, textAlign: TextAlign.center),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _showSuccessDialog(String message) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (context) => AlertDialog(
//             backgroundColor: const Color(0xFF1E293B),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             title: const Icon(
//               Icons.check_circle_outline,
//               color: Colors.green,
//               size: 60,
//             ),
//             content: Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.white),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context), // العودة لصفحة الدخول
//                 child: const Text(
//                   "حسناً",
//                   style: TextStyle(color: Colors.blueAccent),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             const Icon(
//               Icons.lock_open_rounded,
//               size: 80,
//               color: Color(0xFF8A2BE2),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "نسيت كلمة المرور؟",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "أدخل اسم المستخدم والبريد الإلكتروني المسجل لإرسال رابط استعادة الوصول",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.white54, fontSize: 14),
//             ),
//             const SizedBox(height: 40),
//             _buildTextField(
//               controller: _usernameController,
//               label: "اسم المستخدم",
//               icon: Icons.person_outline,
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(
//               controller: _emailController,
//               label: "البريد الإلكتروني",
//               icon: Icons.email_outlined,
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 40),
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _handleReset,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF8A2BE2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 child:
//                     _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                           "إرسال رابط الاستعادة",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white38),
//         prefixIcon: Icon(icon, color: const Color(0xFF8A2BE2)),
//         filled: true,
//         fillColor: const Color(0xFF1E293B),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/services/auth_service.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';
import 'package:matchifiy/widgets/reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  // دالة المساعدة لجلب النصوص المترجمة
  // إذا لم يكن المفتاح موجوداً في ملفك الأصلي، يفضل إضافته هناك لاحقاً
  String _translate(BuildContext context, String key) {
    final localization = AppLocalizations.of(context);
    // سنحاول جلب النص من الـ Getters الموجودة أو نستخدم نصاً افتراضياً مؤقتاً
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
                // onPressed:
                //     () => Navigator.pushNamed(context, '/reset-password'),
                // onPressed: () => Navigator.pop(context),
                onPressed:
                    () => Navigator.pushNamed(context, '/reset-password'),
                // () => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const ResetPasswordScreen(),
                //   ),
                // ),
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
      // return Scaffold(
      // backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // الأيقونة ستتجه لليمين أو اليسار تلقائياً حسب لغة الجهاز (RTL/LTR)
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Directionality(
        // نضمن أن اتجاه النصوص يتبع لغة التطبيق الحالية
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.lock_reset_rounded,
                size: 80,
                color: Color(0xFF8A2BE2),
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
                    backgroundColor: const Color(0xFF8A2BE2),
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
        // الأيقونة ستنتقل لليمين في العربية واليسار في الإنجليزية تلقائياً
        prefixIcon: Icon(icon, color: const Color(0xFF8A2BE2)),
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

// --- 3. واجهة "تغيير كلمة المرور" (إرسال البيانات النهائية) ---
// class ResetPasswordScreen extends StatefulWidget {
//   final String? email; // مستلم من الواجهة السابقة
//   const ResetPasswordScreen({super.key, this.email});

//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final _tokenController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmController = TextEditingController();
//   bool _isLoading = false;

//   void _handleReset() async {
//     if (_tokenController.text.isEmpty || _passwordController.text.isEmpty)
//       return;

//     setState(() => _isLoading = true);
//     final result = await AuthService.resetPassword(
//       email: widget.email!,
//       token: _tokenController.text.trim(),
//       password: _passwordController.text,
//       confirmPassword: _confirmController.text,
//     );
//     setState(() => _isLoading = false);

//     if (result['success']) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Password changed!")));
//       Navigator.popUntil(context, (route) => route.isFirst); // العودة للوجين
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['data']['message'] ?? "Error")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       appBar: AppBar(title: const Text("Reset Password")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(25),
//         child: Column(
//           children: [
//             Text(
//               "Resetting for: ${widget.email}",
//               style: const TextStyle(color: Colors.white70),
//             ),
//             const SizedBox(height: 20),
//             _buildField(_tokenController, "Token from email", Icons.vpn_key),
//             const SizedBox(height: 15),
//             _buildField(
//               _passwordController,
//               "New Password",
//               Icons.lock,
//               isPass: true,
//             ),
//             const SizedBox(height: 15),
//             _buildField(
//               _confirmController,
//               "Confirm Password",
//               Icons.lock_clock,
//               isPass: true,
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
//                 onPressed: _isLoading ? null : _handleReset,
//                 child:
//                     _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text("Update Password"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildField(
//     TextEditingController controller,
//     String label,
//     IconData icon, {
//     bool isPass = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPass,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: Colors.purpleAccent),
//         filled: true,
//         fillColor: const Color(0xFF1E293B),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }
