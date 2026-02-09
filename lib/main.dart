import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logitrack_app/firebase_options.dart';
import 'package:logitrack_app/auth_gate.dart';
import 'package:logitrack_app/delivery_task_provider.dart';
// Import file login_page.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    // Daftarkan Provider di sini
    ChangeNotifierProvider(
      create: (context) => DeliveryTaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
Widget build(BuildContext context) {
  // Tentukan warna dasar (seed color) untuk aplikasi Anda
  final Color seedColor = Colors.deepPurple; // Ganti sesuai tema logistik Anda
  
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'LogiTrack App',
    // Terapkan ThemeData global
    theme: ThemeData(
      // Gunakan Material 3
      useMaterial3: true,
      
      // 1. Tentukan Skema Warna
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      
      // 2. Terapkan Tipografi (Font)
      textTheme: GoogleFonts.poppinsTextTheme( // Ganti 'poppins' dengan font pilihan
        Theme.of(context).textTheme,
      ),
      
      // 3. Atur Tema default untuk AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: seedColor,
        foregroundColor: Colors.white, // Warna teks dan ikon
        centerTitle: true,
        elevation: 2,
      ),
      
      // 4. Atur Tema default untuk ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    home: const AuthGate(), // Halaman gerbang otentikasi
  );
}
}