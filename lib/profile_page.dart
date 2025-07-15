import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_repository.dart';

class ProfilePage extends StatefulWidget {
  final String loginName;
  const ProfilePage({super.key, required this.loginName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome Back ${widget.loginName}')),
      );
    });
    _firstNameController = TextEditingController(text: UserRepository.firstName);
    _lastNameController = TextEditingController(text: UserRepository.lastName);
    _phoneController = TextEditingController(text: UserRepository.phone);
    _emailController = TextEditingController(text: UserRepository.email);

    // Auto-save when text changes
    _firstNameController.addListener(() {
      UserRepository.firstName = _firstNameController.text;
      UserRepository.saveData();
    });

    _lastNameController.addListener(() {
      UserRepository.lastName = _lastNameController.text;
      UserRepository.saveData();
    });

    _phoneController.addListener(() {
      UserRepository.phone = _phoneController.text;
      UserRepository.saveData();
    });

    _emailController.addListener(() {
      UserRepository.email = _emailController.text;
      UserRepository.saveData();
    });
  }

  void _launchAction(String url, String featureName) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Not Supported'),
          content: Text('$featureName is not supported on this device'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('First Name', _firstNameController),
            _buildTextField('Last Name', _lastNameController),
            Row(
              children: [
                Flexible(child: _buildTextField('Phone Number', _phoneController)),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () => _launchAction('tel:${_phoneController.text}', 'Phone calls'),
                ),
                IconButton(
                  icon: const Icon(Icons.sms),
                  onPressed: () => _launchAction('sms:${_phoneController.text}', 'SMS'),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(child: _buildTextField('Email Address', _emailController)),
                IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () => _launchAction('mailto:${_emailController.text}', 'Email'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}