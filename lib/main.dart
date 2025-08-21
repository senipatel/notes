import 'package:flutter/material.dart';
import 'package:notes/screen/home_page.dart';
import 'package:notes/screen/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn;

  if (prefs.getBool('isLoggedIn') == true) {
    isLoggedIn = true;
  } else {
    isLoggedIn = false;
  }

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLoggedIn ? HomePage() : Login(),
      // home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
