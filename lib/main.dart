import 'package:flutter/material.dart';
import 'package:password_manager/screens/first_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'model/password_preferences.dart';
import 'package:password_manager/route.dart' as route;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PasswordSharedPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasRegistered = PasswordSharedPreferences.getHasRegistered() ?? false;
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Lato'),
        restorationScopeId: "root",
        onGenerateRoute: route.controller,
        home: hasRegistered ? LoginScreen() : FirstScreen());
  }
}
