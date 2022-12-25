import 'package:flutter/material.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/screens/first_screen.dart';
import 'package:password_manager/screens/main_screen.dart';
import 'package:password_manager/screens/add_detail_screen.dart';
import 'package:password_manager/screens/view_detail_screen.dart';

const String firstScreen = 'first_screen';
const String mainScreen = 'main_screen';
const String loginScreen = 'login_screen';
const String addDetailScreen = 'add_detail_screen';
const String viewDetailScreen = 'view_detail_screen';

Route<dynamic> controller(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case firstScreen:
      return MaterialPageRoute(builder: (context) => FirstScreen());
    case loginScreen:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case mainScreen:
      return MaterialPageRoute(builder: (context) => MainScreen(args.toString()));
    case addDetailScreen:
      return MaterialPageRoute(builder: (context) => AddDetailScreen(args.toString()));
    case viewDetailScreen:
      return MaterialPageRoute(
          builder: (context) => ViewDetailScreen(args));
    default:
      throw ('No such route exists');
  }
}
