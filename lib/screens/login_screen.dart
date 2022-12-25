import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/model/password_preferences.dart';
import 'package:password_manager/route.dart' as route;
import 'package:password_manager/model/encrypt_decrypt_data.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final enteredPasswordController = TextEditingController();
  String encryptionKey = '';
  String messageToDisplay = '';
  final String wrongMessage = "Incorrect Password";
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  String hashString(String value) {
    String passwordhash = sha256.convert(utf8.encode(value)).toString();
    return passwordhash;
  }

  void _comparePassword() {
    String? rootPassword = PasswordSharedPreferences.getRootPassword();
    String passwordhash = hashString(enteredPasswordController.text);
    if (rootPassword != null && rootPassword == passwordhash) {
      encryptionKey = enteredPasswordController.text;
      Navigator.pushNamed(context, route.mainScreen, arguments: encryptionKey);
    }
    else {
      setState(() {
        messageToDisplay = wrongMessage;
      });
    }
    enteredPasswordController.clear();
  }

  Future<bool> onWillPop() async {
    enteredPasswordController.clear();
    SystemNavigator.pop();
    return false;
  }

  void _onTextFieldChange() {
    setState(() {
      messageToDisplay = '';
    });
    String? rootPassword = PasswordSharedPreferences.getRootPassword();
    String passwordhash = hashString(enteredPasswordController.text);
    if (rootPassword != null && rootPassword == passwordhash) {
      encryptionKey = enteredPasswordController.text;
      Navigator.pushNamed(context, route.mainScreen, arguments: encryptionKey);
    }
      
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: loginScreenScaffold(), onWillPop: onWillPop);
  }

  Scaffold loginScreenScaffold() {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Password Manager"),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 60.0),
                Text("Your Passwords?",
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text("Got you covered!!",
                    style:
                        TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 40.0),
                Icon(
                  Icons.lock_open,
                  color: Colors.grey.shade900,
                  size: 85.0,
                ),
                SizedBox(height: 80.0),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 60.0, right: 60.0, top: 10.0),
                  child: TextField(
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        hintText: 'Root password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      controller: enteredPasswordController,
                      onChanged: (value) => _onTextFieldChange()),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                    onPressed: _comparePassword, child: Text('Submit')),
                Text(messageToDisplay),
              ],
            ),
          ),
        ));
  }
}
