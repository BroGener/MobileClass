import 'package:flutter/material.dart';
import 'package:encrypt_shared_preferences/enc_shared_preferences.dart';

class Lab4 extends StatefulWidget {
  const Lab4({super.key});

  @override
  State<Lab4> createState() => _Lab4State();
}

class _Lab4State extends State<Lab4> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final EncSharedPref _encryptedData = EncSharedPref();

  String imageSource = "images/question-mark.png";

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  // 加载数据逻辑
  Future<void> _loadCredentials() async {
    String? savedUser = await _encryptedData.get('username');
    String? savedPass = await _encryptedData.get('password');

    if (savedUser != null && savedPass != null && savedUser.isNotEmpty && savedPass.isNotEmpty) {
      if (mounted) { // 检查组件是否还在树中
        setState(() {
          loginController.text = savedUser;
          passwordController.text = savedPass;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Previous login name and passwords have been loaded.'),
            ),
          );
        });
      }
    }
  }

  // 弹窗逻辑
  void _handleLogin() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Credentials?"),
          content: const Text("Would you like to save your username and password?"),
          actions: [
            TextButton(
              onPressed: () async {
                await _encryptedData.clear();
                if (mounted) Navigator.of(context).pop();
                _updateResultImage();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await _encryptedData.set('username', loginController.text);
                await _encryptedData.set('password', passwordController.text);
                if (mounted) Navigator.of(context).pop();
                _updateResultImage();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _updateResultImage() {
    String password = passwordController.text.trim();
    setState(() {
      if (password == 'ASDF') {
        imageSource = "images/idea.png";
      } else {
        imageSource = "images/stop.png";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Week 4 Lab"), // 这里直接写死标题即可
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: loginController,
                decoration: const InputDecoration(labelText: 'Login'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              Image.asset(
                imageSource,
                width: 300,
                height: 300,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, size: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}