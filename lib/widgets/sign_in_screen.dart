import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:matchifiy/main.dart';
import 'package:matchifiy/services/app_localizations.dart';
import 'package:matchifiy/services/auth_service.dart';
import 'package:matchifiy/services/token_storage.dart';
import 'package:matchifiy/widgets/CustomBackgroundScaffold.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF1E1E2E);
  static const Color inputFieldBg = Color(0xFF28283D);
  static const Color gradientStart = Color(0xFF8A2BE2);
  static const Color gradientEnd = Color(0xFFE0B0FF);
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _toggleLanguage() {
    final currentLocale = Localizations.localeOf(context);
    final newLocale =
        currentLocale.languageCode == 'ar'
            ? const Locale('en', '')
            : const Locale('ar', '');
    MyApp.of(context).setLocale(newLocale);
  }

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
        _emailController.text.trim(),
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

        Navigator.pushReplacementNamed(context, '/analysis');
        // Navigator.pushReplacementNamed(context, '/home');
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: CustomBackgroundScaffold(
        // child: Scaffold(
        // backgroundColor: AppColors.primaryDark,
        appBar: AppBar(
          // backgroundColor: Color.fromARGB(255, 146, 163, 208),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: _toggleLanguage,
              child: Text(
                isArabic ? 'English' : 'العربية',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        // body: SingleChildScrollView(
        //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.stretch,
        //     children: [
        //       const SizedBox(height: 20),
        //       Text(
        //         loc.welcomeTitle,
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 32,
        //           fontWeight: FontWeight.bold,
        //         ),
        //         textAlign: TextAlign.center,
        //       ),
        //       const SizedBox(height: 40),

        //       const SizedBox(height: 30),

        //       _buildTextField(
        //         label: loc.email,
        //         controller: _emailController,
        //         icon: Icons.email_outlined,
        //       ),
        //       const SizedBox(height: 20),

        //       _buildTextField(
        //         label: loc.password,
        //         controller: _passwordController,
        //         icon: Icons.lock_outline,
        //         isPassword: true,
        //       ),
        //       const SizedBox(height: 10),

        //       Align(
        //         alignment:
        //             isArabic ? Alignment.centerLeft : Alignment.centerRight,
        //         child: TextButton(
        //           onPressed: () {
        //             Navigator.pushNamed(context, '/forgot-password');
        //           },
        //           child: Text(
        //             loc.forgotPassword,
        //             style: const TextStyle(color: Colors.white70),
        //           ),
        //         ),
        //       ),

        //       const SizedBox(height: 20),
        //       _buildSignInButton(loc.signIn),
        //       const SizedBox(height: 30),

        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             loc.noAccount + " ",
        //             style: const TextStyle(color: Colors.white70),
        //           ),
        //           GestureDetector(
        //             onTap: () => Navigator.pushNamed(context, '/register'),
        //             child: Text(
        //               loc.registerNow,
        //               style: const TextStyle(
        //                 color: AppColors.gradientEnd,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       const SizedBox(height: 20),
        //     ],
        //   ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 70),

                      Text(
                        loc.welcomeTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 150),

                      _buildTextField(
                        label: loc.username,
                        // label: loc.email,
                        controller: _emailController,
                        icon: Icons.email_outlined,
                      ),

                      const SizedBox(height: 20),

                      _buildTextField(
                        label: loc.password,
                        controller: _passwordController,
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment:
                            isArabic
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: Text(
                            loc.forgotPassword,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),

                      /// 🔹 هذا هو المفتاح
                      const Spacer(),

                      _buildSignInButton(loc.signIn),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            loc.noAccount + " ",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          GestureDetector(
                            onTap:
                                () => Navigator.pushNamed(context, '/register'),
                            child: Text(
                              loc.registerNow,
                              style: const TextStyle(
                                color: Colors.black,
                                // color: AppColors.gradientEnd,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 114, 116, 228)),
        // prefixIcon: Icon(icon, color: AppColors.gradientEnd),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed:
                      () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                )
                : null,
        filled: true,
        fillColor: AppColors.inputFieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignInButton(String text) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 114, 116, 228),
            Color.fromARGB(255, 146, 163, 208),
          ],
          // colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        // onPressed: () {
        //   // Navigator.pushReplacementNamed(context, '/analysis');
        //   Navigator.pushReplacementNamed(context, '/home');
        // },
        onPressed: _isLoading ? null : _handleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            _isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
// import 'dart:developer'; import 'package:flutter/material.dart'; import 'package:matchifiy/main.dart'; import 'package:matchifiy/services/app_localizations.dart'; import 'package:matchifiy/services/auth_service.dart'; import 'package:matchifiy/services/token_storage.dart'; class AppColors { static const Color primaryDark = Color(0xFF1E1E2E); static const Color inputFieldBg = Color(0xFF28283D); static const Color gradientStart = Color(0xFF8A2BE2); static const Color gradientEnd = Color(0xFFE0B0FF); } class SignInScreen extends StatefulWidget { const SignInScreen({super.key}); @override State<SignInScreen> createState() => _SignInScreenState(); } class _SignInScreenState extends State<SignInScreen> { final TextEditingController _emailController = TextEditingController(); final TextEditingController _passwordController = TextEditingController(); bool _isLoading = false; bool _isPasswordVisible = false; void _toggleLanguage() { final currentLocale = Localizations.localeOf(context); final newLocale = currentLocale.languageCode == 'ar' ? const Locale('en', '') : const Locale('ar', ''); MyApp.of(context).setLocale(newLocale); } Future<void> _handleSignIn() async { final loc = AppLocalizations.of(context); if (_emailController.text.isEmpty || _passwordController.text.isEmpty) { ScaffoldMessenger.of( context, ).showSnackBar(SnackBar(content: Text(loc.pleaseFillFields))); return; } setState(() => _isLoading = true); try { final result = await AuthService.login( _emailController.text.trim(), _passwordController.text.trim(), ); log(result.toString()); if (!mounted) return; setState(() => _isLoading = false); if (result != null && result.containsKey('token')) { final name = result['name']; final username = result['username']; final email = result['email']; await TokenStorage.saveToken(result['token']); await TokenStorage.saveUserData( name: name, // أو الاسم القادم من قاعدة بياناتك email: email, username: username, // name: user['full_name'], // أو الاسم القادم من قاعدة بياناتك // email: user['email'], // username: user['username'], ); // Navigator.pushReplacementNamed(context, '/analysis'); Navigator.pushReplacementNamed(context, '/home'); // log(result['name']); // log(result['email']); // log(result['user']['username']); // log('nameis$name'); // log(email); // log(username); // log(result['token']); } else { ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text(loc.loginFailedMessage), backgroundColor: Colors.red, ), ); } } catch (e) { setState(() => _isLoading = false); ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text('${loc.error}: $e'), backgroundColor: Colors.red, ), ); } } @override Widget build(BuildContext context) { final loc = AppLocalizations.of(context); final isArabic = Localizations.localeOf(context).languageCode == 'ar'; return Directionality( textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr, child: Scaffold( backgroundColor: AppColors.primaryDark, appBar: AppBar( backgroundColor: Colors.transparent, elevation: 0, actions: [ TextButton( onPressed: _toggleLanguage, child: Text( isArabic ? 'English' : 'العربية', style: const TextStyle( color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, ), ), ), ], ), body: SingleChildScrollView( padding: const EdgeInsets.symmetric(horizontal: 30.0), child: Column( crossAxisAlignment: CrossAxisAlignment.stretch, children: [ const SizedBox(height: 20), Text( loc.welcomeTitle, style: const TextStyle( color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center, ), const SizedBox(height: 40), const SizedBox(height: 30), _buildTextField( label: loc.email, controller: _emailController, icon: Icons.email_outlined, ), const SizedBox(height: 20), _buildTextField( label: loc.password, controller: _passwordController, icon: Icons.lock_outline, isPassword: true, ), const SizedBox(height: 10), Align( alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight, child: TextButton( onPressed: () { Navigator.pushNamed(context, '/forgot-password'); }, child: Text( loc.forgotPassword, style: const TextStyle(color: Colors.white70), ), ), ), const SizedBox(height: 20), _buildSignInButton(loc.signIn), const SizedBox(height: 30), Row( mainAxisAlignment: MainAxisAlignment.center, children: [ Text( loc.noAccount + " ", style: const TextStyle(color: Colors.white70), ), GestureDetector( onTap: () => Navigator.pushNamed(context, '/register'), child: Text( loc.registerNow, style: const TextStyle( color: AppColors.gradientEnd, fontWeight: FontWeight.bold, ), ), ), ], ), const SizedBox(height: 20), ], ), ), ), ); } Widget _buildTextField({ required String label, required TextEditingController controller, required IconData icon, bool isPassword = false, }) { return TextFormField( controller: controller, obscureText: isPassword && !_isPasswordVisible, style: const TextStyle(color: Colors.white), decoration: InputDecoration( labelText: label, labelStyle: const TextStyle(color: Colors.white70), prefixIcon: Icon(icon, color: AppColors.gradientEnd), suffixIcon: isPassword ? IconButton( icon: Icon( _isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70, ), onPressed: () => setState( () => _isPasswordVisible = !_isPasswordVisible, ), ) : null, filled: true, fillColor: AppColors.inputFieldBg, border: OutlineInputBorder( borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none, ), ), ); } Widget _buildSignInButton(String text) { return Container( height: 55, decoration: BoxDecoration( gradient: const LinearGradient( colors: [AppColors.gradientStart, AppColors.gradientEnd], ), borderRadius: BorderRadius.circular(12), ), child: ElevatedButton( // onPressed: () { // // Navigator.pushReplacementNamed(context, '/analysis'); // Navigator.pushReplacementNamed(context, '/home'); // }, onPressed: _isLoading ? null : _handleSignIn, style: ElevatedButton.styleFrom( backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12), ), ), child: _isLoading ? const SizedBox( width: 24, height: 24, child: CircularProgressIndicator( color: Colors.white, strokeWidth: 2, ), ) : Text( text, style: const TextStyle( color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, ), ), ), ); } }