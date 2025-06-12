import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/logoPage.dart';
import 'pages/loginPage.dart';
import 'pages/homePage.dart';
import 'pages/formBarang.dart';
import 'pages/daftarBarang.dart';
import 'helpers/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database; // Tidak perlu panggil initDB()
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOST STOCK',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink.shade100,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LogoPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/form': (context) => FormBarangPage(),
        '/daftar': (context) => DaftarBarangPage(),
      },
    );
  }
}
