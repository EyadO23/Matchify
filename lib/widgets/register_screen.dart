// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:matchifiy/models/user.dart';
// import 'package:matchifiy/services/auth_service.dart';

// class AppColors {
//   static const Color primaryDark = Color(0xFF1E1E2E);
//   static const Color inputFieldBg = Color(0xFF28283D);
//   static const Color gradientStart = Color(0xFF8A2BE2);
//   static const Color gradientEnd = Color(0xFFE0B0FF);
// }

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   // ********** المتغيرات Controllers **********
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController(); // تم التعديل هنا

//   bool _isSigningUp = false;
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false; // تم التعديل هنا

//   // ********** دالة معالجة عملية التسجيل **********
//   // void _handleSignUp() {
//   //   if (_usernameController.text.isEmpty ||
//   //       _emailController.text.isEmpty ||
//   //       _passwordController.text.isEmpty ||
//   //       _confirmPasswordController.text.isEmpty) {
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
//   //     return;
//   //   }

//   //   // **التحقق من تطابق كلمات المرور**
//   //   if (_passwordController.text != _confirmPasswordController.text) {
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
//   //     return;
//   //   }

//   //   // هنا يتم استدعاء API Laravel للتسجيل
//   //   setState(() {
//   //     _isSigningUp = true;
//   //   });

//   //   // محاكاة تأخير زمني لعملية التسجيل
//   //   Future.delayed(const Duration(seconds: 2), () {
//   //     if (mounted) {
//   //       setState(() {
//   //         _isSigningUp = false;
//   //       });

//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(
//   //           content: Text('Account registered successfully!'),
//   //           backgroundColor: AppColors.gradientStart,
//   //         ),
//   //       );
//   //       // يمكنك توجيه المستخدم لشاشة تسجيل الدخول
//   //       Navigator.pop(context);
//   //     }
//   //   });
//   // }
//   void _handleSignUp() async {
//     // التحقق من تعبئة جميع الحقول
//     if (_usernameController.text.isEmpty ||
//         _emailController.text.isEmpty ||
//         _passwordController.text.isEmpty ||
//         _confirmPasswordController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
//       return;
//     }

//     // التحقق من تطابق كلمات المرور
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
//       return;
//     }

//     setState(() {
//       _isSigningUp = true;
//     });

//     try {
//       // إنشاء كائن User
//       final user = User(
//         id: 0, // لا حاجة فعلية هنا، سيعود من السيرفر
//         username: _usernameController.text.trim(),
//         email: _emailController.text.trim(),
//         profilePictureUrl: null,
//         apiToken: '', // سيعود من السيرفر بعد التسجيل
//       );

//       // استدعاء خدمة التسجيل وتمرير كلمة المرور
//       final success = await AuthService.register(
//         user,
//         _passwordController.text.trim(),
//       );

//       if (!mounted) return;

//       setState(() {
//         _isSigningUp = false;
//       });

//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Account registered successfully!'),
//             backgroundColor: AppColors.gradientStart,
//           ),
//         );
//         Navigator.pop(context); // العودة لشاشة تسجيل الدخول
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Registration failed. Please try again.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isSigningUp = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }

//   // ********** بناء واجهة المستخدم **********
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 30.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const SizedBox(height: 20),
//             const Text(
//               'Create Account',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Enter your email address and password to use the application',
//               style: TextStyle(color: Colors.white70, fontSize: 14),
//             ),
//             const SizedBox(height: 40),

//             _buildInputField('Username', _usernameController, 'EyadoKh'),
//             const SizedBox(height: 20),
//             _buildInputField(
//               'Email',
//               _emailController,
//               'matchify@gmail.com',
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 20),
//             // حقل كلمة المرور
//             _buildPasswordInputField(
//               'Password',
//               _passwordController,
//               isConfirmField: false,
//             ),
//             const SizedBox(height: 20),
//             // حقل تأكيد كلمة المرور
//             _buildPasswordInputField(
//               'Confirm Password',
//               _confirmPasswordController,
//               isConfirmField: true,
//             ),

//             const SizedBox(height: 60),
//             _buildSignUpButton(),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   // ********** دالة مساعدة لحقول الإدخال العادية (لا تغيير عليها) **********
//   Widget _buildInputField(
//     String label,
//     TextEditingController controller,
//     String placeholder, {
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     // ... (الكود يبقى كما هو) ...
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//         const SizedBox(height: 5),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: placeholder,
//             hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
//             filled: true,
//             fillColor: AppColors.inputFieldBg,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 15.0,
//               horizontal: 15.0,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ********** دالة مساعدة لحقول كلمة المرور (تم التعديل عليها) **********
//   Widget _buildPasswordInputField(
//     String label,
//     TextEditingController controller, {
//     required bool isConfirmField,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//         const SizedBox(height: 5),
//         TextFormField(
//           controller: controller,
//           obscureText:
//               isConfirmField
//                   ? !_isConfirmPasswordVisible
//                   : !_isPasswordVisible, // تحديث لاسم المتغير
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: '*********',
//             hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
//             filled: true,
//             fillColor: AppColors.inputFieldBg,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.0),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 15.0,
//               horizontal: 15.0,
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 isConfirmField
//                     ? (_isConfirmPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off) // تحديث لاسم المتغير
//                     : (_isPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off),
//                 color: Colors.white70,
//               ),
//               onPressed: () {
//                 setState(() {
//                   if (isConfirmField) {
//                     _isConfirmPasswordVisible =
//                         !_isConfirmPasswordVisible; // تحديث لاسم المتغير
//                   } else {
//                     _isPasswordVisible = !_isPasswordVisible;
//                   }
//                 });
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ... (بقية كود زر التسجيل يبقى كما هو) ...
//   Widget _buildSignUpButton() {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [AppColors.gradientStart, AppColors.gradientEnd],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: ElevatedButton(
//         onPressed: _isSigningUp ? null : _handleSignUp,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//         child:
//             _isSigningUp
//                 ? const Center(
//                   child: SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 3,
//                     ),
//                   ),
//                 )
//                 : const Text(
//                   'SIGN UP',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//       ),
//     );
//   }
// }
// // class AppColors {
// //   static const Color primaryDark = Color(0xFF1E1E2E);
// //   static const Color inputFieldBg = Color(0xFF28283D);
// //   static const Color gradientStart = Color(0xFF8A2BE2); // بنفسجي غامق
// //   static const Color gradientEnd = Color(0xFFE0B0FF); // بنفسجي فاتح
// // }

// // class RegisterScreen extends StatefulWidget {
// //   const RegisterScreen({super.key});

// //   @override
// //   State<RegisterScreen> createState() => _RegisterScreenState();
// // }

// // class _RegisterScreenState extends State<RegisterScreen> {
// //   // ********** المتغيرات Controllers **********
// //   final TextEditingController _usernameController = TextEditingController();
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   final TextEditingController _resetPasswordController =
// //       TextEditingController();

// //   bool _isSigningUp = false;
// //   bool _isPasswordVisible = false;
// //   bool _isResetPasswordVisible = false;

// //   // ********** دالة محاكاة عملية التسجيل **********
// //   void _handleSignUp() {
// //     if (_usernameController.text.isEmpty ||
// //         _emailController.text.isEmpty ||
// //         _passwordController.text.isEmpty) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
// //       return;
// //     }
// //     if (_passwordController.text != _resetPasswordController.text) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
// //       return;
// //     }

// //     // هنا يتم استدعاء API Laravel للتسجيل
// //     setState(() {
// //       _isSigningUp = true;
// //     });

// //     // محاكاة تأخير زمني لعملية التسجيل
// //     Future.delayed(const Duration(seconds: 2), () {
// //       if (mounted) {
// //         setState(() {
// //           _isSigningUp = false;
// //         });

// //         // بعد النجاح، يمكن الانتقال إلى شاشة التحليل أو تسجيل الدخول
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text('Account registered successfully!'),
// //             backgroundColor: AppColors.gradientStart,
// //           ),
// //         );
// //         // مثال: Navigator.pushReplacementNamed(context, '/analysis');
// //       }
// //     });
// //   }

// //   // ********** بناء واجهة المستخدم **********
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.primaryDark,
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         iconTheme: const IconThemeData(color: Colors.white),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.symmetric(horizontal: 30.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: <Widget>[
// //             const SizedBox(height: 20),
// //             const Text(
// //               'Create Account',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 30,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             const Text(
// //               'Enter your email address and password to use the application',
// //               style: TextStyle(color: Colors.white70, fontSize: 14),
// //             ),
// //             const SizedBox(height: 40),

// //             _buildInputField('Username', _usernameController, 'EyadoKh'),
// //             const SizedBox(height: 20),
// //             _buildInputField(
// //               'Email',
// //               _emailController,
// //               'matchify@gmail.com',
// //               keyboardType: TextInputType.emailAddress,
// //             ),
// //             const SizedBox(height: 20),
// //             _buildPasswordInputField('Password', _passwordController, false),
// //             const SizedBox(height: 20),
// //             _buildPasswordInputField(
// //               'Reset Password',
// //               _resetPasswordController,
// //               true,
// //             ),

// //             const SizedBox(height: 60),
// //             _buildSignUpButton(),
// //             const SizedBox(height: 30),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ********** دالة مساعدة لحقول الإدخال العادية **********
// //   Widget _buildInputField(
// //     String label,
// //     TextEditingController controller,
// //     String placeholder, {
// //     TextInputType keyboardType = TextInputType.text,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           label,
// //           style: const TextStyle(color: Colors.white70, fontSize: 14),
// //         ),
// //         const SizedBox(height: 5),
// //         TextFormField(
// //           controller: controller,
// //           keyboardType: keyboardType,
// //           style: const TextStyle(color: Colors.white),
// //           decoration: InputDecoration(
// //             hintText: placeholder,
// //             hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
// //             filled: true,
// //             fillColor: AppColors.inputFieldBg,
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10.0),
// //               borderSide: BorderSide.none,
// //             ),
// //             contentPadding: const EdgeInsets.symmetric(
// //               vertical: 15.0,
// //               horizontal: 15.0,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // ********** دالة مساعدة لحقول كلمة المرور **********
// //   Widget _buildPasswordInputField(
// //     String label,
// //     TextEditingController controller,
// //     bool isConfirmation,
// //   ) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           label,
// //           style: const TextStyle(color: Colors.white70, fontSize: 14),
// //         ),
// //         const SizedBox(height: 5),
// //         TextFormField(
// //           controller: controller,
// //           obscureText:
// //               isConfirmation ? !_isResetPasswordVisible : !_isPasswordVisible,
// //           style: const TextStyle(color: Colors.white),
// //           decoration: InputDecoration(
// //             hintText: '*********',
// //             hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
// //             filled: true,
// //             fillColor: AppColors.inputFieldBg,
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(10.0),
// //               borderSide: BorderSide.none,
// //             ),
// //             contentPadding: const EdgeInsets.symmetric(
// //               vertical: 15.0,
// //               horizontal: 15.0,
// //             ),
// //             suffixIcon: IconButton(
// //               icon: Icon(
// //                 isConfirmation
// //                     ? (_isResetPasswordVisible
// //                         ? Icons.visibility
// //                         : Icons.visibility_off)
// //                     : (_isPasswordVisible
// //                         ? Icons.visibility
// //                         : Icons.visibility_off),
// //                 color: Colors.white70,
// //               ),
// //               onPressed: () {
// //                 setState(() {
// //                   if (isConfirmation) {
// //                     _isResetPasswordVisible = !_isResetPasswordVisible;
// //                   } else {
// //                     _isPasswordVisible = !_isPasswordVisible;
// //                   }
// //                 });
// //               },
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // ********** زر التسجيل **********
// //   Widget _buildSignUpButton() {
// //     return Container(
// //       height: 50,
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [AppColors.gradientStart, AppColors.gradientEnd],
// //           begin: Alignment.centerLeft,
// //           end: Alignment.centerRight,
// //         ),
// //         borderRadius: BorderRadius.circular(10.0),
// //       ),
// //       child: ElevatedButton(
// //         onPressed: _isSigningUp ? null : _handleSignUp,
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: Colors.transparent,
// //           shadowColor: Colors.transparent,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(10.0),
// //           ),
// //         ),
// //         child:
// //             _isSigningUp
// //                 ? const Center(
// //                   child: SizedBox(
// //                     width: 24,
// //                     height: 24,
// //                     child: CircularProgressIndicator(
// //                       color: Colors.white,
// //                       strokeWidth: 3,
// //                     ),
// //                   ),
// //                 )
// //                 : const Text(
// //                   'SIGN UP',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:matchifiy/models/user.dart';
import 'dart:developer';
// يجب تحديث المسارات وفقاً لمكان تواجد ملفاتك
// import 'package:matchifiy/models/user_model.dart';
import 'package:matchifiy/services/auth_service.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF1E1E2E);
  static const Color inputFieldBg = Color(0xFF28283D);
  static const Color gradientStart = Color(0xFF8A2BE2);
  static const Color gradientEnd = Color(0xFFE0B0FF);
}

// افترض أن AuthService و TokenStorage موجودان في ملفات أخرى
// يجب أن تقوم بتحديث كود AuthService لاستقبال password و confirmPassword

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ********** المتغيرات Controllers **********
  final TextEditingController _nameController =
      TextEditingController(); // <--- تم إضافة متحكم الاسم الكامل
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isSigningUp = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // ********** دالة معالجة عملية التسجيل المصححة **********
  void _handleSignUp() async {
    // التحقق من تعبئة جميع الحقول، بما فيها الاسم الجديد
    if (_nameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    // التحقق من تطابق كلمات المرور (كما تم طلب التعديل عليه)
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    setState(() {
      _isSigningUp = true;
    });

    try {
      // إنشاء كائن User بقيمة الاسم الكامل
      final user = User(
        id: 0,
        name: _nameController.text.trim(), // <--- إرسال الاسم الكامل
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        profilePictureUrl: null,
        apiToken: '',
      );

      // استدعاء خدمة التسجيل مع تمرير كلتا كلمتي المرور
      final success = await AuthService.register(
        user,
        _passwordController.text.trim(),
        _confirmPasswordController.text.trim(), // تمرير كلمة التأكيد
      );

      if (!mounted) return;

      setState(() {
        _isSigningUp = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account registered successfully!'),
            backgroundColor: AppColors.gradientStart,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registration failed. Check your data or try again later.',
            ),
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
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // ********** بناء واجهة المستخدم **********
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
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
            const Text(
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your details to create an account',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // <--- التعديل الرئيسي: حقل الاسم الكامل الجديد --->
            _buildInputField('Full Name', _nameController, 'Ahmad Eyad'),
            const SizedBox(height: 20),

            _buildInputField('Username', _usernameController, 'EyadoKh'),
            const SizedBox(height: 20),

            _buildInputField(
              'Email',
              _emailController,
              'matchify@gmail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // حقل كلمة المرور
            _buildPasswordInputField(
              'Password',
              _passwordController,
              isConfirmField: false,
            ),
            const SizedBox(height: 20),

            // حقل تأكيد كلمة المرور
            _buildPasswordInputField(
              'Confirm Password',
              _confirmPasswordController,
              isConfirmField: true,
            ),

            const SizedBox(height: 60),
            _buildSignUpButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ********** دالة مساعدة لحقول الإدخال العادية (كما كانت) **********
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

  // ********** دالة مساعدة لحقول كلمة المرور (كما كانت) **********
  Widget _buildPasswordInputField(
    String label,
    TextEditingController controller, {
    required bool isConfirmField,
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
          obscureText:
              isConfirmField ? !_isConfirmPasswordVisible : !_isPasswordVisible,
          style: const TextStyle(color: Colors.white),
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

  // ********** زر التسجيل (كما كان) **********
  Widget _buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
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
                : const Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}
