import 'package:flutter/material.dart';
import 'package:flutter_application_1/Quest_page.dart';
import 'package:flutter_application_1/register_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'input_panen_page.dart';
import 'riwayat_page.dart';
import 'grafik_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  List<Map<String, dynamic>> _extractPanenData(Object? args) {
    if (args == null) return <Map<String, dynamic>>[];
    if (args is List<Map<String, dynamic>>) return args;

    if (args is List) {
      try {
        return List<Map<String, dynamic>>.from(args);
      } catch (e) {
        return <Map<String, dynamic>>[];
      }
    }

    return <Map<String, dynamic>>[];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
  "/": (context) => const LoginPage(),
  "/home": (context) => const HomePage(),
  "/input": (context) => const InputPanenPage(),
  "/register": (context) => RegisterPage(),
  '/quest': (context) => const QuestPage(),



  "/riwayat": (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final panen = _extractPanenData(args);
    return RiwayatPage(panenData: panen);
  },

  "/grafik": (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final panen = _extractPanenData(args);
    return GrafikPage(panenData: panen);
  },
}

    );
  }
}


