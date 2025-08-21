import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/screen/login.dart';

import '../database/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getNotes();
  }

  List notesData = [];
  getNotes() async {
    notesData = await Database_Helper.instance.getNotes();
    setState(() {});
  }

  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NOTES"), centerTitle: true),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 50.0),
          child: ListTile(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool("isLoggedIn", false);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            title: Text("Log Out "),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notesData.length,
        itemBuilder: (context, index) {
          final singleNote = notesData[index];
          return ListTile(
            leading: Text("${index + 1}"),
            title: Text(singleNote['title']),
            subtitle: Text(singleNote['description']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (builder) {
                        return updateNote(
                          singleNote['id'],
                          singleNote['title'],
                          singleNote['description'],
                        );
                      },
                    );
                  },
                  // () => updateNote(
                  //   singleNote['id'],
                  //   singleNote['title'],
                  //   singleNote['description'],
                  // ),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    await Database_Helper.instance.deleteNote(singleNote['id']);
                    getNotes();
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (builder) {
            return AlertDialog(
              title: Center(child: Text("add", textAlign: TextAlign.center)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title,
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                  TextField(
                    controller: description,
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      final user_id =
                          await Database_Helper.instance.getUserId();
                      log("button click !!");
                      final data = await Database_Helper.instance.insertNote(
                        user_id,
                        title.text,
                        description.text,
                      );
                      if (data > 0) {
                        getNotes();
                        title.clear();
                        description.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Text("submit"),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }

  Widget updateNote(singleNoteId, singleNoteTitle, singleNoteDescription) {
    final title = TextEditingController(text: singleNoteTitle);
    final description = TextEditingController(text: singleNoteDescription);

    return AlertDialog(
      title: Center(child: Text("update Note")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: title, decoration: InputDecoration()),
          SizedBox(height: 10),
          TextField(controller: description, decoration: InputDecoration()),
          SizedBox(height: 10),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () async {
            await Database_Helper.instance.updateNote(
              singleNoteId,
              title.text,
              description.text,
            );
            getNotes();
            Navigator.pop(context);
          },
          child: Text("update"),
        ),
      ],
    );
  }
}
