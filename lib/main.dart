import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    _loadCredentials();
  }

  void _loadCredentials() async {
    String? savedUsername = await data.getString('username');
    String? savedPassword = await data.getString('password');

    if (savedUsername != null && savedPassword != null) {
      setState(() {
        loginController.text = savedUsername;
        passwordController.text = savedPassword;
      });
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loaded saved credentials!')),
        );
      });
    }
  }

  void _saveCredentials() async {
    await data.setString('username', loginController.text);
    await data.setString('password', passwordController.text);
  }

  void _clearCredentials() async {
    await data.remove('username');
    await data.remove('password');
  }

  // This method is called when the Login button is pressed
  void onPressed() {
    String password = passwordController.text;


    setState(() {
      if (password == 'QWERTY123') {
        imageSource = 'images/idea.png';
      } else {
        imageSource = 'images/stop.png';
      }
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save Credentials?'),
        content: Text('Would you like to save your username and password for next time?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveCredentials();
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearCredentials();
            },
            child: Text('Noo'),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: loginController,
              decoration: InputDecoration(
                hintText: "Login",
                border: OutlineInputBorder(),
                labelText: "Login",
              ),
            ),
            TextField(
              controller: passwordController,obscureText:true,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: Text('Login'),
            ),
            // Always use the dynamic imageSource here
            Semantics(
              child: Image.asset(imageSource,width: 300,height: 300),
              label: "This is a basic image",
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}