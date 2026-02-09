import 'package:flutter/material.dart';
import 'package:logitrack_app/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logitrack_app/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage( {super.key} );

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

bool isLoading = false;

void handleLogin() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoading = true; // 1. Mulai Loading
    });
    
    // Panggil service otentikasi (pastikan sudah ada)
    User? user = await _authService.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    
    if (!mounted) return; // Cek jika widget masih ada
    
    if (user == null) {
      // Tampilkan error jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login gagal. Periksa kembali kredensial Anda.')),
      );
      
      setState(() {
        isLoading = false; // 2. Hentikan Loading
      });
    }
    // Navigasi akan ditangani secara otomatis oleh AuthGate
  }
}

final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  // ... di dalam build method LoginPage
  bool _isPasswordVisible = false;
  // Buat controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      // ... AppBar tetap sama
      appBar: AppBar(
        title: const Text('LogiTrack - Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(24.0), // Memberi jarak di sekeliling
        child: Form(
          key: _formKey,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan secara vertikal
          children: [
            // I. Tambahkan Ikon atau Logo
            const Icon(
              Icons.local_shipping,
              size: 80,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 48), // Memberi jarak vertikal
            
            // 2. Tambahkan TextFormField untuk Email
            TextFormField(
              controller: _emailController, // Hubungkan controller email
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  // Validasi format email sederhana
                  if (!value.contains('@')) {
                    return 'Masukkan format email yang valid';
                  }
                  return null; // Return null jika valid
                },
            ),
            const SizedBox(height: 16), // Memberi jarak vertikal

            // 3. Tambahkan TextFormField untuk Password
            TextFormField(
              controller: _passwordController, // Hubungkan controller password
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal harus 6 karakter';
                  }
                  return null; // Return null jika valid
                },
            ),
            const SizedBox(height: 32), // Memberi jarak vertikal
            
            // 4. Tambahkan Tombol Login
            // Bungkus dengan SizedBox agar bisa mengatur lebar tombol
            AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Durasi animasi
              width: isLoading ? 50 : double.infinity, // Lebar berubah
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Sesuaikan shape agar menjadi lingkaran saat loading
                  shape: isLoading
                      ? const CircleBorder()
                      : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                // Nonaktifkan tombol saat loading
                onPressed: isLoading ? null : handleLogin, 
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white, 
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(height: 16), // Memberi jarak vertikal
            
            // 5. Tambahkan Tombol Register
            // Bungkus dengan SizedBox agar bisa mengatur lebar tombol
            SizedBox(
              width: double.infinity, // Lebar tombol penuh
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('Register'),
              ),
            ),
          ],  
        ),
      ),  
      ),
    ),
    );
  }
}