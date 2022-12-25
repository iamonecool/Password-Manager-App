import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/model/password_preferences.dart';
import 'package:password_manager/route.dart' as route;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  FirstScreenState createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen> {
  final enteredPasswordController = TextEditingController();
  final reEnteredPasswordController = TextEditingController();
  String warningMessage = '';
  bool _passwordVisible = false;

  Future<bool> onWillPop() async {
    _clearTextControllers();
    SystemNavigator.pop();
    return false;
  }

  void _clearTextControllers() {
    enteredPasswordController.clear();
    reEnteredPasswordController.clear();
  }

  void _submitButtonHandler() async {
    if (enteredPasswordController.text.isEmpty) {
      return;
    }
    if(enteredPasswordController.text.contains(' ') || enteredPasswordController.text.contains("\"") ||
      reEnteredPasswordController.text.contains(' ') || reEnteredPasswordController.text.contains("\"")) {
      setState(() {
        warningMessage = "You cannot have space or \" in your password";
      }); 
    }
    else if (enteredPasswordController.text == reEnteredPasswordController.text) {
      String passwordhash = sha256.convert(utf8.encode(enteredPasswordController.text)).toString();
      await PasswordSharedPreferences.setRootPassword(
          passwordhash);
      await PasswordSharedPreferences.setHasRegistered(true);
      Navigator.pushNamed(context, route.loginScreen);
    } else {
      setState(() {
        warningMessage = "Yours passwords didn't match";
      });
    }
    _clearTextControllers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: firstScreenScaffold(), onWillPop: onWillPop);
  }

  Scaffold firstScreenScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Password Manager',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 60.0),
              Text(
                'Own your passwords',
                style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              SizedBox(
                height: 30.0,
              ),
              Icon(
                Icons.lock_open,
                color: Colors.grey.shade900,
                size: 85.0,
              ),
              SizedBox(
                height: 100.0,
              ),
              Text(
                'Configure your root password here',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 35.0, right: 35.0, top: 5.0),
                child: TextField(
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      hintText: 'Enter a password'),
                  controller: enteredPasswordController,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 35.0, right: 35.0, top: 5.0),
                child: TextField(
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22.0)),
                    hintText: 'Re-enter password',
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
                  controller: reEnteredPasswordController,
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                  onPressed: _submitButtonHandler, child: Text('Submit')),
              SizedBox(height: 6.0),
              Text(warningMessage, style: TextStyle(fontSize: 14.0, color: Colors.red))
            ],
          ),
        ),
      ),
    );
  }
}
