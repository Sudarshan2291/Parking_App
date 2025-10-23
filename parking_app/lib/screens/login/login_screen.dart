import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/login_provider.dart';
import '../admin/admin_dashboard.dart';
import '../manager/manager_dashboard.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        error = null;
                      });

                      final result = await loginProvider.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      setState(() => isLoading = false);

                      if (result != null) {
                        setState(() => error = result);
                      } else {
                        
                        if (loginProvider.user!.email!.trim().toLowerCase() == 'admin@gmail.com') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const AdminDashboard()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const ManagerDashboard()),
                          );
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
