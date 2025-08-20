import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/screen/home_page.dart';
import 'package:notes/screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("LOGIN"),
                  SizedBox(height: 10),
                  TextField(
                    controller: username,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "username",
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "password",
                    ),
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      final usernameValue = username.text;
                      final passwordValue = password.text;
                      final response = await Database_Helper.instance
                          .chackLogin(usernameValue, passwordValue);
                      if (response != null) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool("isLoggedIn", true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                              title: Text("failed"),
                              content: Text(
                                "invalid input",
                                style: TextStyle(color: Colors.green),
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Text("Login", style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Don't have an account?"),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.purple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
