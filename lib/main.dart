import 'package:flutter/material.dart';
import 'ecrans/splashecran.dart'; // تأكدي أن المسار يطابق مكان ملفاتك

void main() {
  runApp(const TravviteApp());
}

class TravviteApp extends StatelessWidget {
  const TravviteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travvite',
      debugShowCheckedModeBanner: false,

      // إعدادات الثيم العام للتطبيق ليتناسب مع "المود الاحترافي"
      theme: ThemeData(
        primaryColor: const Color(0xFF2B4C7E),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Cairo', // إذا أضفتِ الخط العربي لاحقاً
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B4C7E),
          primary: const Color(0xFF2B4C7E),
        ),
        useMaterial3: true,
      ),

      // الشاشة التي سيبدأ منها التطبيق
      home: const Splash(),
    );
  }
}
