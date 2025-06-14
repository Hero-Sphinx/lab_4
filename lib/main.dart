import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'user_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      onGenerateRoute: (settings) {
        if (settings.name == '/secondPage') {
          final loginName = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ProfilePage(loginName: loginName),
          );
        }
        // Default route
        return MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String imageSource = 'images/question-mark.png';
  final EncryptedSharedPreferences data = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    UserRepository.loadData();
    _loadCredentials();
  }

  void _loadCredentials() async {
    String savedUsername = await data.getString('username') ?? '';
    String savedPassword = await data.getString('password') ?? '';

    setState(() {
      loginController.text = savedUsername;
      passwordController.text = savedPassword;
    });

    if (savedUsername.isNotEmpty || savedPassword.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loaded saved credentials!')),
        );
      });
    }
  }

  Future<void> _saveCredentials() async {
    await data.setString('username', loginController.text);
    await data.setString('password', passwordController.text);
  }

  Future<void> _clearCredentials() async {
    await data.remove('username');
    await data.remove('password');
  }

  void onPressed() {
    final password = passwordController.text;

    setState(() {
      imageSource = (password == 'QWERTY123')
          ? 'images/idea.png'
          : 'images/stop.png';
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Credentials?'),
        content: const Text('Would you like to save your login information?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _saveCredentials();
              _navigateToProfile();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearCredentials();
              _navigateToProfile();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToProfile();
            },
            child: const Text('Later'),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.pushNamed(
      context,
      '/secondPage',
      arguments: loginController.text,
    );
    // Do NOT show the SnackBar here; show it in ProfilePage instead!
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: loginController,
              decoration: const InputDecoration(
                hintText: "Login",
                border: OutlineInputBorder(),
                labelText: "Login",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Login'),
            ),
            const SizedBox(height: 24),
            Semantics(
              child: Image.asset(imageSource, width: 300, height: 300),
              label: "Login status image",
            ),
          ],
        ),
      ),
    );
  }
}