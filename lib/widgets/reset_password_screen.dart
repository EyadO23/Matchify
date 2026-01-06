// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/auth_service.dart';
// // افترضنا أن هذا هو مسار خدمة الـ Auth لديك
// // import '../services/auth_service.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});

//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   // إضافة متحكم للإيميل ليتم إدخاله يدوياً
//   final _emailController = TextEditingController();
//   final _tokenController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmController = TextEditingController();

//   bool _isLoading = false;
//   bool _isObscure = true;
//   bool _isConfirmObscure = true;

//   void _handleReset() async {
//     if (_emailController.text.isEmpty ||
//         _tokenController.text.isEmpty ||
//         _passwordController.text.isEmpty ||
//         _confirmController.text.isEmpty) {
//       _showSnackBar("Please fill all fields", isError: true);
//       return;
//     }

//     setState(() => _isLoading = true);

//     // استدعاء الخدمة (تأكد أن النوع المرجع هو Map)
//     final dynamic result = await AuthService.resetPassword(
//       email: _emailController.text.trim(),
//       token: _tokenController.text.trim(),
//       password: _passwordController.text,
//       confirmPassword: _confirmController.text,
//     );

//     setState(() => _isLoading = false);

//     // حل المشكلة الأولى: تحويل القيمة صراحةً إلى bool
//     // واستخدام ?? false للضمان في حال كانت القيمة null
//     final bool isSuccess = result['success'] == true;

//     if (isSuccess) {
//       _showSnackBar("Password changed successfully!", isError: false);
//       Future.delayed(const Duration(seconds: 2), () {
//         if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
//       });
//     } else {
//       // حل المشكلة الثانية: استخدام التحقق الآمن ?. والتحويل الصريح
//       // للتأكد من الوصول للمسار result['data']['message'] بدون خطأ null
//       String errorMessage = "An error occurred";

//       if (result != null && result['data'] != null) {
//         errorMessage = result['data']['message']?.toString() ?? "Error";
//       }

//       _showSnackBar(errorMessage, isError: true);
//     }
//   }

//   // void _handleReset() async {
//   //   // التحقق من أن جميع الحقول ممتلئة
//   //   if (_emailController.text.isEmpty ||
//   //       _tokenController.text.isEmpty ||
//   //       _passwordController.text.isEmpty ||
//   //       _confirmController.text.isEmpty) {
//   //     _showSnackBar("Please fill all fields", isError: true);
//   //     return;
//   //   }

//   //   if (_passwordController.text != _confirmController.text) {
//   //     _showSnackBar("Passwords do not match", isError: true);
//   //     return;
//   //   }

//   //   setState(() => _isLoading = true);

//   //   // استدعاء دالة الـ API مع تمرير الإيميل من الـ Controller الجديد
//   //   // final result = await AuthService.resetPassword(
//   //   //   email: _emailController.text.trim(),
//   //   //   token: _tokenController.text.trim(),
//   //   //   password: _passwordController.text,
//   //   //   confirmPassword: _confirmController.text,
//   //   // );

//   //   // محاكاة استجابة السيرفر للفحص (قم بحذفها عند ربط الـ API)
//   //   await Future.delayed(const Duration(seconds: 2));
//   //   final result = {'success': true, 'data': {'message': 'Password updated successfully'}};

//   //   setState(() => _isLoading = false);

//   //   if (result['success']) {
//   //     _showSnackBar("Password changed successfully!", isError: false);
//   //     // العودة لصفحة تسجيل الدخول
//   //     Future.delayed(const Duration(seconds: 2), () {
//   //       if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
//   //     });
//   //   } else {
//   //     _showSnackBar(result['data']['message'] ?? "An error occurred", isError: true);
//   //   }
//   // }

//   void _showSnackBar(String message, {required bool isError}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A), // خلفية داكنة متناسقة
//       appBar: AppBar(
//         title: const Text("New Password"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Reset Your Account",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               "Enter the code sent to your email and set your new password.",
//               style: TextStyle(color: Colors.white60, fontSize: 14),
//             ),
//             const SizedBox(height: 30),

//             // حقل الإيميل (جديد)
//             _buildField(
//               controller: _emailController,
//               label: "Email Address",
//               hint: "yourname@example.com",
//               icon: Icons.email_outlined,
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 18),

//             // حقل التوكن
//             _buildField(
//               controller: _tokenController,
//               label: "Verification Code (Token)",
//               hint: "Enter 6-digit code",
//               icon: Icons.security_outlined,
//             ),
//             const SizedBox(height: 18),

//             // حقل كلمة المرور
//             _buildField(
//               controller: _passwordController,
//               label: "New Password",
//               hint: "••••••••",
//               icon: Icons.lock_outline,
//               isPass: true,
//               isObscured: _isObscure,
//               onToggleVisibility:
//                   () => setState(() => _isObscure = !_isObscure),
//             ),
//             const SizedBox(height: 18),

//             // حقل تأكيد كلمة المرور
//             _buildField(
//               controller: _confirmController,
//               label: "Confirm New Password",
//               hint: "••••••••",
//               icon: Icons.lock_reset_outlined,
//               isPass: true,
//               isObscured: _isConfirmObscure,
//               onToggleVisibility:
//                   () => setState(() => _isConfirmObscure = !_isConfirmObscure),
//             ),
//             const SizedBox(height: 35),

//             // زر التحديث
//             SizedBox(
//               width: double.infinity,
//               height: 58,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF7C3AED), // بنفجي غامق
//                   shape: RoundedRectangleApp(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 5,
//                   shadowColor: Colors.purple.withOpacity(0.3),
//                 ),
//                 onPressed: _isLoading ? null : _handleReset,
//                 child:
//                     _isLoading
//                         ? const SizedBox(
//                           height: 25,
//                           width: 25,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                         : const Text(
//                           "Update Password",
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

//   Widget _buildField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     bool isPass = false,
//     bool isObscured = false,
//     VoidCallback? onToggleVisibility,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 8),
//           child: Text(
//             label,
//             style: const TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//         ),
//         TextField(
//           controller: controller,
//           obscureText: isPass ? isObscured : false,
//           keyboardType: keyboardType,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
//             prefixIcon: Icon(icon, color: const Color(0xFFA78BFA), size: 22),
//             suffixIcon:
//                 isPass
//                     ? IconButton(
//                       icon: Icon(
//                         isObscured
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: Colors.white38,
//                       ),
//                       onPressed: onToggleVisibility,
//                     )
//                     : null,
//             filled: true,
//             fillColor: const Color(0xFF1E293B),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 18,
//               horizontal: 15,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: const BorderSide(color: Colors.white10),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: const BorderSide(
//                 color: Color(0xFF7C3AED),
//                 width: 1.5,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // تعديل بسيط لمنع خطأ الـ Shape في Flutter
// class RoundedRectangleApp extends RoundedRectangleBorder {
//   const RoundedRectangleApp({super.borderRadius});
// }
import 'package:flutter/material.dart';
import 'package:matchifiy/services/auth_service.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class ResetPasswordScreen extends StatefulWidget {
  // استقبال البيانات القادمة من الرابط (Deep Link)
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
    // تعبئة الحقول بالقيم القادمة من الرابط إن وجدت
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
    if (_emailController.text.isEmpty ||
        _tokenController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      _showSnackBar("Please fill all fields", isError: true);
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      _showSnackBar("Passwords do not match", isError: true);
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
        _showSnackBar("Password changed successfully!", isError: false);
        // العودة لصفحة تسجيل الدخول بعد ثانيتين
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
        });
      } else {
        String errorMessage = "An error occurred";
        if (result != null && result['data'] != null) {
          errorMessage =
              result['data']['message']?.toString() ?? "Error from server";
        }
        _showSnackBar(errorMessage, isError: true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Connection error: $e", isError: true);
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
    return CustomBackgroundScaffold(
      // return Scaffold(
      // backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("New Password"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reset Your Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Set your new password below to regain access to your account.",
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 30),

            _buildField(
              controller: _emailController,
              label: "Email Address",
              hint: "yourname@example.com",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              // جعل الحقل للقراءة فقط إذا كان الإيميل قادم من الرابط لزيادة الأمان
              readOnly: widget.initialEmail != null,
            ),
            const SizedBox(height: 18),

            _buildField(
              controller: _tokenController,
              label: "Verification Code (Token)",
              hint: "Enter code from email",
              icon: Icons.security_outlined,
              readOnly: widget.initialToken != null,
            ),
            const SizedBox(height: 18),

            _buildField(
              controller: _passwordController,
              label: "New Password",
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
              label: "Confirm New Password",
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
                  backgroundColor: const Color(0xFF7C3AED),
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
                        : const Text(
                          "Update Password",
                          style: TextStyle(
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
            prefixIcon: Icon(icon, color: const Color(0xFFA78BFA), size: 22),
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
                color: Color(0xFF7C3AED),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
