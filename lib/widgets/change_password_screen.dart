// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/auth_service.dart';
// import 'package:matchifiy/services/token_storage.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({super.key});

//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final _currentPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscureCurrent = true;
//   bool _obscureNew = true;
//   bool _obscureConfirm = true;

//   Future<void> _submitChange() async {
//     if (_newPasswordController.text != _confirmPasswordController.text) {
//       _showSnackBar("كلمات المرور الجديدة غير متطابقة", Colors.red);
//       return;
//     }

//     setState(() => _isLoading = true);

//     final result = await AuthService.changePassword(
//       currentPassword: _currentPasswordController.text,
//       newPassword: _newPasswordController.text,
//       confirmPassword: _confirmPasswordController.text,
//     );

//     setState(() => _isLoading = false);

//     if (result['success']) {
//       _showSnackBar(result['message'], Colors.green);

//       // بناءً على رسالة الباك آند، يجب تسجيل الخروج
//       Future.delayed(const Duration(seconds: 2), () async {
//         await TokenStorage.deleteToken();
//         if (mounted) {
//           Navigator.of(
//             context,
//           ).pushNamedAndRemoveUntil('/login', (route) => false);
//         }
//       });
//     } else {
//       _showSnackBar(result['message'], Colors.red);
//     }
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       appBar: AppBar(
//         title: const Text(
//           "تغيير كلمة المرور",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "قم بتحديث كلمة المرور الخاصة بك لتأمين حسابك",
//               style: TextStyle(color: Colors.white70, fontSize: 16),
//             ),
//             const SizedBox(height: 32),
//             _buildPasswordField(
//               controller: _currentPasswordController,
//               label: "كلمة المرور الحالية",
//               obscure: _obscureCurrent,
//               onToggle:
//                   () => setState(() => _obscureCurrent = !_obscureCurrent),
//             ),
//             const SizedBox(height: 20),
//             _buildPasswordField(
//               controller: _newPasswordController,
//               label: "كلمة المرور الجديدة",
//               obscure: _obscureNew,
//               onToggle: () => setState(() => _obscureNew = !_obscureNew),
//             ),
//             const SizedBox(height: 20),
//             _buildPasswordField(
//               controller: _confirmPasswordController,
//               label: "تأكيد كلمة المرور الجديدة",
//               obscure: _obscureConfirm,
//               onToggle:
//                   () => setState(() => _obscureConfirm = !_obscureConfirm),
//             ),
//             const SizedBox(height: 40),
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _submitChange,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 child:
//                     _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                           "تحديث كلمة المرور",
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required bool obscure,
//     required VoidCallback onToggle,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscure,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white54),
//         filled: true,
//         fillColor: const Color(0xFF1E293B),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide.none,
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(
//             obscure ? Icons.visibility_off : Icons.visibility,
//             color: Colors.white24,
//           ),
//           onPressed: onToggle,
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:matchifiy/services/app_localizations.dart';
// import 'package:matchifiy/services/auth_service.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   final String? token; // التوكن القادم من رابط الإيميل
//   const ChangePasswordScreen({super.key, this.token});

//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscureText = true;

//   String _translate(BuildContext context, String key) {
//     final localization = AppLocalizations.of(context);
//     final bool isAr = localization.locale.languageCode == 'ar';

//     switch (key) {
//       case 'title':
//         return isAr ? 'تغيير كلمة المرور' : 'Change Password';
//       case 'subtitle':
//         return isAr
//             ? 'أدخل كلمة المرور الجديدة والمؤكدة'
//             : 'Enter your new password and confirm it';
//       case 'new_password':
//         return isAr ? 'كلمة المرور الجديدة' : 'New Password';
//       case 'confirm_password':
//         return localization.confirmPassword;
//       case 'update_btn':
//         return isAr ? 'تحديث كلمة المرور' : 'Update Password';
//       case 'success_msg':
//         return isAr
//             ? 'تم تغيير كلمة المرور بنجاح!'
//             : 'Password changed successfully!';
//       default:
//         return key;
//     }
//   }

//   Future<void> _handleUpdate() async {
//     final localization = AppLocalizations.of(context);

//     if (_passwordController.text != _confirmController.text) {
//       _showSnackBar(localization.passwordsNotMatch, Colors.redAccent);
//       return;
//     }

//     if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
//       _showSnackBar(localization.pleaseFillFields, Colors.orange);
//       return;
//     }

//     setState(() => _isLoading = true);

//     final result = await AuthService.resetPassword(
//       email: _emailController.text.trim(),
//       token:
//           widget.token ?? "no-token", // في الحالة الحقيقية يتم جلبه من الرابط
//       password: _passwordController.text,
//       confirmPassword: _confirmController.text,
//     );

//     setState(() => _isLoading = false);

//     if (result['success']) {
//       _showSuccessDialog(
//         result['message'] ?? _translate(context, 'success_msg'),
//       );
//     } else {
//       _showSnackBar(result['message'] ?? localization.error, Colors.redAccent);
//     }
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, textAlign: TextAlign.center),
//         backgroundColor: color,
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
//             title: const Icon(
//               Icons.verified_user,
//               color: Colors.green,
//               size: 50,
//             ),
//             content: Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.white),
//             ),
//             actions: [
//               TextButton(
//                 onPressed:
//                     () => Navigator.pushReplacementNamed(context, '/login'),
//                 child: const Text(
//                   "OK",
//                   style: TextStyle(color: Colors.blueAccent),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localization = AppLocalizations.of(context);
//     final isAr = localization.locale.languageCode == 'ar';

//     return Scaffold(
//       backgroundColor: const Color(0xFF0F172A),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Directionality(
//         textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               const Icon(
//                 Icons.vpn_key_rounded,
//                 size: 80,
//                 color: Color(0xFF8A2BE2),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 _translate(context, 'title'),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 _translate(context, 'subtitle'),
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.white54, fontSize: 14),
//               ),
//               const SizedBox(height: 30),
//               _buildTextField(
//                 controller: _emailController,
//                 label: localization.email,
//                 icon: Icons.email_outlined,
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: _passwordController,
//                 label: _translate(context, 'new_password'),
//                 icon: Icons.lock_outline,
//                 isPassword: true,
//               ),
//               const SizedBox(height: 20),
//               _buildTextField(
//                 controller: _confirmController,
//                 label: localization.confirmPassword,
//                 icon: Icons.lock_reset_rounded,
//                 isPassword: true,
//               ),
//               const SizedBox(height: 40),
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _handleUpdate,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF8A2BE2),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   child:
//                       _isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : Text(
//                             _translate(context, 'update_btn'),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool isPassword = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword ? _obscureText : false,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white38),
//         prefixIcon: Icon(icon, color: const Color(0xFF8A2BE2)),
//         suffixIcon:
//             isPassword
//                 ? IconButton(
//                   icon: Icon(
//                     _obscureText ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.white38,
//                   ),
//                   onPressed: () => setState(() => _obscureText = !_obscureText),
//                 )
//                 : null,
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
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // دالة الترجمة الخاصة بك مع إضافة مفاتيح كلمة المرور الحالية
  String _translate(BuildContext context, String key) {
    final localization = AppLocalizations.of(context);
    final bool isAr = localization.locale.languageCode == 'ar';

    switch (key) {
      case 'title':
        return isAr ? 'تغيير كلمة المرور' : 'Change Password';
      case 'subtitle':
        return isAr
            ? 'يرجى إدخال كلمة المرور الحالية والجديدة'
            : 'Please enter your current and new password';
      case 'current_password':
        return isAr ? 'كلمة المرور الحالية' : 'Current Password';
      case 'new_password':
        return isAr ? 'كلمة المرور الجديدة' : 'New Password';
      case 'confirm_password':
        return localization.confirmPassword; // استخدام الترجمة الجاهزة من الملف
      case 'update_btn':
        return isAr ? 'تحديث كلمة المرور' : 'Update Password';
      case 'success_msg':
        return isAr
            ? 'تم تحديث كلمة المرور بنجاح!'
            : 'Password updated successfully!';
      default:
        return key;
    }
  }

  Future<void> _handleUpdate() async {
    final localization = AppLocalizations.of(context);

    // التحقق من الحقول
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackBar(localization.pleaseFillFields, Colors.orange);
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackBar(localization.passwordsNotMatch, Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);

    // استدعاء الخدمة (يجب أن تستقبل الباك آند الباسورد القديم والجديد)
    final dynamic result = await AuthService.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    setState(() => _isLoading = false);

    // معالجة الأخطاء التي ظهرت لك سابقاً (Null Safety)
    final bool isSuccess = result != null && result['success'] == true;

    if (isSuccess) {
      _showSuccessDialog(
        result['message']?.toString() ?? _translate(context, 'success_msg'),
      );
      Future.delayed(const Duration(seconds: 2), () async {
        await TokenStorage.deleteToken();
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      });
    } else {
      String errorMsg =
          result != null && result['message'] != null
              ? result['message'].toString()
              : localization.error;
      _showSnackBar(errorMsg, Colors.redAccent);
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
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 50,
            ),
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "OK",
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
        title: Text(
          _translate(context, 'title'),
          style: const TextStyle(color: Colors.white),
        ),
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
                Icons.shield_outlined,
                size: 80,
                // color: Color(0xFF8A2BE2),
                color: Color.fromARGB(255, 114, 116, 228),
                // Color.fromARGB(255, 146, 163, 208),
              ),
              const SizedBox(height: 20),
              Text(
                _translate(context, 'subtitle'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // حقل كلمة المرور الحالية
              _buildTextField(
                controller: _currentPasswordController,
                label: _translate(context, 'current_password'),
                icon: Icons.lock_open_rounded,
                isPassword: true,
                obscure: _obscureCurrent,
                onToggle:
                    () => setState(() => _obscureCurrent = !_obscureCurrent),
              ),
              const SizedBox(height: 20),

              // حقل كلمة المرور الجديدة
              _buildTextField(
                controller: _newPasswordController,
                label: _translate(context, 'new_password'),
                icon: Icons.lock_outline,
                isPassword: true,
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 20),

              // حقل تأكيد الجديدة
              _buildTextField(
                controller: _confirmPasswordController,
                label: _translate(context, 'confirm_password'),
                icon: Icons.lock_reset_rounded,
                isPassword: true,
                obscure: _obscureConfirm,
                onToggle:
                    () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 114, 116, 228),
                    // Color.fromARGB(255, 146, 163, 208),

                    // backgroundColor: const Color(0xFF8A2BE2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            _translate(context, 'update_btn'),
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
    required bool isPassword,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 114, 116, 228)),
        // prefixIcon: Icon(icon, color: const Color(0xFF8A2BE2)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white38,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF8A2BE2), width: 1),
        ),
      ),
    );
  }
}
