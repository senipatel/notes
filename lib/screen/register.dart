import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db_helper.dart';
// import '../model/user.dart';
import './login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController first_name = TextEditingController();
  final TextEditingController last_name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController mobile_number = TextEditingController();
  final TextEditingController email_id = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirm_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("REGISTER"),
                    TextField(
                      controller: first_name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "First Name",
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: last_name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Last Name",
                      ),
                    ),
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
                      controller: mobile_number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Mobile Number",
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: email_id,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email ID",
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
                    TextField(
                      controller: confirm_password,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Confirm Password",
                      ),
                    ),
                    SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () async {
                        log("button presses");
                        if (password.text != confirm_password.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Passwords do not match")),
                          );
                          return;
                        }
                        final response = await Database_Helper.instance
                            .insertUser(
                              first_name.text,
                              last_name.text,
                              username.text,
                              mobile_number.text,
                              email_id.text,
                              password.text,
                            );
                        log(response.toString());
                        if (response > 0) {
                          showDialog(
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                title: Text("Success"),
                                content: Text(
                                  "User Registered Successfully",
                                  style: TextStyle(color: Colors.green),
                                ),
                              );
                            },
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                title: Text("Failed"),
                                content: Text(
                                  "User Registered Not Successfully",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          );
                        }
                        log("button presses 5");
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("Already have an account?"),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text(
                            "login",
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
      ),
    );
  }
}
