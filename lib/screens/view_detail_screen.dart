import 'package:flutter/material.dart';
import 'package:password_manager/model/password_preferences.dart';
import 'package:clipboard/clipboard.dart';
import 'package:password_manager/model/encrypt_decrypt_data.dart';

class ViewDetailScreen extends StatefulWidget {
  late String serviceName;
  late String encryptionKey;
  var viewDetailScreenMap;
  ViewDetailScreen(this.viewDetailScreenMap) {
    late Map argumentsMap;
    if(viewDetailScreenMap is Map){
      argumentsMap = viewDetailScreenMap as Map;
      encryptionKey = argumentsMap['encryptionKey'];
      serviceName = argumentsMap['serviceName'];
    } 
  }

  @override
  ViewDetailScreenState createState() => ViewDetailScreenState();
}

class ViewDetailScreenState extends State<ViewDetailScreen> {
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isUsernameAvailable = false;
  bool isWebsiteAvailable = false;
  bool _passwordVisible = false;

    @override
  void initState() {
    super.initState();
    _retrieveAllData();
  }

  void _retrieveAllData() async {
    emailController.text =
        PasswordSharedPreferences.getEmail(widget.serviceName) ?? '';
    websiteController.text =
        PasswordSharedPreferences.getWebsite(widget.serviceName) ?? '';
    usernameController.text =
        PasswordSharedPreferences.getUsername(widget.serviceName) ?? '';
    passwordController.text =
        PasswordSharedPreferences.getPassword(widget.serviceName) ?? '';
    EncryptData encryptData =  EncryptData(widget.encryptionKey);
    String decryptedPassword = encryptData.decryptAES(passwordController.text);
    passwordController.text = decryptedPassword;
    if (websiteController.text.isNotEmpty) {
      setState(() {
        isWebsiteAvailable = true;
      });
    }
    if (usernameController.text.isNotEmpty) {
      setState(() {
        isUsernameAvailable = true;
      });
    }
  }

  void _copyToClipboard(String value) {
    FlutterClipboard.copy(value);
  }

  @override
  Widget build(BuildContext context) {
    /*Future.delayed(Duration.zero, () {
      _retrieveAllData();
    });*/
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceName.toUpperCase(),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _emailTextField(),
            _passwordTextField(),
            if (isUsernameAvailable) _usernameTextField(),
            if (isWebsiteAvailable) _websiteTextField()
          ],
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        readOnly: true,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          labelText: 'Email',
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        controller: emailController,
        onTap: (() => _copyToClipboard(emailController.text)),
      ),
    );
  }

  Widget _passwordTextField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        readOnly: true,
        enableInteractiveSelection: true,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        controller: passwordController,
        onTap: (() => _copyToClipboard(passwordController.text)),
      ),
    );
  }

  Widget _usernameTextField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        readOnly: true,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          labelText: 'Username',
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        controller: usernameController,
        onTap: (() => _copyToClipboard(usernameController.text)),
      ),
    );
  }

  Widget _websiteTextField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        readOnly: true,
        enableInteractiveSelection: true,
        decoration: InputDecoration(
          labelText: 'Website',
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        controller: websiteController,
        onTap: (() => _copyToClipboard(websiteController.text)),
      ),
    );
  }
}
