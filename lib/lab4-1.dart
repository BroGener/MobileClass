import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class Lab4App extends StatelessWidget {
  const Lab4App({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  final FlutterSecureStorage secureStorage =
  const FlutterSecureStorage();

  String imageSource = "images/question-mark.png";

  static const String KEY_USER = "username";
  static const String KEY_PASS = "password";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedCredentials();
    });
  }



  Future<void> _loadSavedCredentials() async {
    String? savedUser = await secureStorage.read(key: KEY_USER);
    String? savedPass = await secureStorage.read(key: KEY_PASS);

    if (savedUser != null &&
        savedPass != null &&
        savedUser.isNotEmpty &&
        savedPass.isNotEmpty) {
      _loginController.text = savedUser;
      _passwordController.text = savedPass;

      if (!mounted) return;

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Previous login loaded"),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }



  Future<void> _saveCredentials(String user, String pass) async {
    await secureStorage.write(key: KEY_USER, value: user);
    await secureStorage.write(key: KEY_PASS, value: pass);
  }



  Future<void> _clearCredentials() async {
    await secureStorage.deleteAll();
  }


  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Save Login?"),
        content: const Text(
          "Would you like to save your username and password?",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _saveCredentials(
                _loginController.text,
                _passwordController.text,
              );
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () async {
              await _clearCredentials();
              if (mounted) Navigator.pop(context);
            },
            child: const Text("No"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Login Lab"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGIN FIELD
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
                labelText: 'Login name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                String password = _passwordController.text;

                setState(() {
                  if (password == "8188") {
                    imageSource = "images/idea.png";
                  } else {
                    imageSource = "images/stop.png";
                  }
                });

                _showSaveDialog();
              },
              child: const Text("Login"),
            ),

            const SizedBox(height: 20),

            Semantics(
              label: imageSource.contains("light_bulb")
                  ? "Light bulb"
                  : imageSource.contains("stop")
                  ? "Stop sign"
                  : "Question mark",
              child: Image.asset(
                imageSource,
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}