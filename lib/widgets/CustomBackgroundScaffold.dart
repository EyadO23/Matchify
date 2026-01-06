// import 'package:flutter/material.dart';

// /// ويدجت مخصصة لتوحيد الخلفية في جميع شاشات التطبيق.
// /// تتيح لك وضع صورة خلفية ثابتة مع طبقة تعتيم لضمان وضوح المحتوى.
// class CustomBackgroundScaffold extends StatelessWidget {
//   final Widget body;
//   final PreferredSizeWidget? appBar;
//   final Widget? floatingActionButton;

//   const CustomBackgroundScaffold({
//     super.key,
//     required this.body,
//     this.appBar,
//     this.floatingActionButton,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true, // لجعل الخلفية تمتد خلف شريط التطبيق
//       appBar: appBar,
//       body: Stack(
//         children: [
//           // 1. صورة الخلفية
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(
//                   "assets/images/background.png",
//                 ), // استبدل المسار بمسار صورتك
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // 2. طبقة تعتيم (Overlay) اختيارية لتحسين قراءة النصوص
//           Container(color: const Color(0xFF1E1E2E).withOpacity(0.85)),
//           // 3. المحتوى الأساسي
//           SafeArea(child: body),
//         ],
//       ),
//       floatingActionButton: floatingActionButton,
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomBackgroundScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? drawer; // إضافة متغير القائمة الجانبية
  final double opacity;

  const CustomBackgroundScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.drawer, // تمرير الـ drawer في المشيد
    this.opacity = 0.85,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      drawer: drawer, // تمرير القائمة الجانبية للـ Scaffold الأصلي
      // drawer: drawer, // تمرير القائمة الجانبية للـ Scaffold الأصلي
      body: Stack(
        children: [
          // صورة الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // image: AssetImage("assets/images/back.png"),
                image: AssetImage("assets/images/final.jpg"),
                // image: AssetImage("assets/images/backgroundAi.jpg"),
                // image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // طبقة التعتيم
          // Container(color: const Color(0xFF1E1E2E).withOpacity(opacity)),
          // المحتوى
          SafeArea(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
