import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_repository.dart'; // 导入刚才创建的仓库

class Lab5App extends StatelessWidget {
  const Lab5App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 5',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- 第一页：登录页 ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserRepository _repo = UserRepository();
  String imageSource = "images/question-mark.png";

  void _handleLogin() async {
    String password = _passwordController.text;
    if (password == "8188") {
      setState(() => imageSource = "images/idea.png");

      // 存储当前的登录名到仓库
      _repo.loginName = _loginController.text;

      // 评分标准：跳转前加载仓库数据
      await _repo.loadData();

      if (!mounted) return;
      // 跳转到第二页
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else {
      setState(() => imageSource = "images/stop.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Lab")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _loginController, decoration: const InputDecoration(labelText: 'Login name',border: OutlineInputBorder(),)),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password',border: OutlineInputBorder(),)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _handleLogin, child: const Text("Login")),
            const SizedBox(height: 20),
            Image.asset(imageSource, width: 200, height: 200),
          ],
        ),
      ),
    );
  }
}

//
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository _repo = UserRepository();


  late TextEditingController _fNameCtrl, _lNameCtrl, _phoneCtrl, _emailCtrl;

  @override
  void initState() {
    super.initState();


    _fNameCtrl = TextEditingController(text: _repo.firstName);
    _lNameCtrl = TextEditingController(text: _repo.lastName);
    _phoneCtrl = TextEditingController(text: _repo.phoneNumber);
    _emailCtrl = TextEditingController(text: _repo.emailAddress);

    // 2. 定义同步和保存逻辑
    void syncAndSave() {
      // 只有在内容真的变化时才保存，减少 IO 压力
      if (_repo.firstName != _fNameCtrl.text ||
          _repo.lastName != _lNameCtrl.text ||
          _repo.phoneNumber != _phoneCtrl.text ||
          _repo.emailAddress != _emailCtrl.text) {

        _repo.firstName = _fNameCtrl.text;
        _repo.lastName = _lNameCtrl.text;
        _repo.phoneNumber = _phoneCtrl.text;
        _repo.emailAddress = _emailCtrl.text;

        // 执行异步保存
        _repo.saveData();
      }
    }

    // 3. 绑定监听器
    _fNameCtrl.addListener(syncAndSave);
    _lNameCtrl.addListener(syncAndSave);
    _phoneCtrl.addListener(syncAndSave);
    _emailCtrl.addListener(syncAndSave);

    // Welcome Back SnackBar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome Back ${_repo.loginName}")),
      );
    });
  }

  // 别忘了在 dispose 中释放控制器，防止内存泄漏
  @override
  void dispose() {
    _fNameCtrl.dispose();
    _lNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  // 评分标准：URL Launcher 逻辑与不支持时的弹窗
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("The URL $urlString is not supported on this device."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile: ${_repo.loginName}")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text("Welcome Back ${_repo.loginName}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(controller: _fNameCtrl, decoration: const InputDecoration(hintText: "First Name",border: OutlineInputBorder(),)),
          const SizedBox(height: 15),
          TextField(controller: _lNameCtrl, decoration: const InputDecoration(hintText: "Last Name",border: OutlineInputBorder(),)),

          // 电话行：包含 TextField 和 两个按钮
          const SizedBox(height: 15),
          Row(
            children: [
              Flexible( // 评分标准：必须加 Flexible
                child: TextField(controller: _phoneCtrl, decoration: const InputDecoration(hintText: "Phone Number",border: OutlineInputBorder(),)),
              ),
              IconButton(onPressed: () => _launchURL("tel:${_phoneCtrl.text}"), icon: const Icon(Icons.phone)),
              IconButton(onPressed: () => _launchURL("sms:${_phoneCtrl.text}"), icon: const Icon(Icons.message)),
            ],
          ),
          const SizedBox(height: 15),
          // 邮件行：包含 TextField 和 一个按钮
          Row(
            children: [
              Flexible( // 评分标准：必须加 Flexible
                child: TextField(controller: _emailCtrl, decoration: const InputDecoration(hintText: "Email address",border: OutlineInputBorder(),)),
              ),
              IconButton(onPressed: () => _launchURL("mailto:${_emailCtrl.text}"), icon: const Icon(Icons.mail)),
            ],
          ),
        ],
      ),
    );
  }
}