import 'package:flutter/material.dart';
import 'package:logitrack_app/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logitrack_app/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage( {super.key} );

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  // ... di dalam build method RegisterPage
  bool _isPasswordVisible = false;
  // Buat controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      // ... AppBar tetap sama
      appBar: AppBar(
        title: const Text('LogiTrack - Register'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
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
            
            // 4. Tambahkan Tombol Register
            // Bungkus dengan SizedBox agar bisa mengatur lebar tombol
            SizedBox(
              width: double.infinity, // Lebar tombol penuh
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    User? user = await _authService.registerWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (user != null) {

                    } else {
                      // Tampilkan pesan kesalahan jika Register gagal
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Register gagal. Periksa email dan password Anda.')),
                      );
                    }
                  }
                },
                child: const Text('Register'),
              ),
            ),
            const SizedBox(height: 16), // Memberi jarak vertikal
            
            // 5. Tambahkan Tombol Login
            // Bungkus dengan SizedBox agar bisa mengatur lebar tombol
            SizedBox(
              width: double.infinity, // Lebar tombol penuh
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Login'),
              ),
            ),
          ],  
        ),
      ),  
      ),
    );
  }
}