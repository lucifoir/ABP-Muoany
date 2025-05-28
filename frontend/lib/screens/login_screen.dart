import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final success = await AuthService.login(email, password);

    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = "Email atau password salah";
      });
    }
  }

  void _goToRegister() {
    // TODO: Ganti dengan navigasi ke RegisterScreen jika sudah dibuat
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigasi ke halaman register')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.purple.shade700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Money Tracker",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _goToRegister,
              child: Text(
                'Belum punya akun? Daftar',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
