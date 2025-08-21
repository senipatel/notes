import 'package:flutter/material.dart';
import 'package:notes/screen/login.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Database_Helper {
  Database_Helper._();

  static final Database_Helper instance = Database_Helper._();
  Database? _database;
  late int? user_id;

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databaseDir = await getDatabasesPath();
    final path = join(databaseDir, "Notes.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, version) async {
        await db.execute('''
      CREATE TABLE User(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      first_name TEXT,
      last_name TEXT,
      username TEXT,
      mobile_number TEXT,
      email_id TEXT,
      password TEXT
      )''');
        await db.execute('''
      CREATE TABLE Note(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      user_id INTEGER
      )''');
      },
    );
  }

  Future<int> insertUser(
    first_name,
    last_name,
    username,
    mobile_number,
    email_id,
    password,
  ) async {
    final db = await instance.db;
    return await db.insert("User", {
      "first_name": first_name,
      "last_name": last_name,
      "username": username,
      "mobile_number": mobile_number,
      "email_id": email_id,
      "password": password,
    });
  }

  Future<Map<String, dynamic>?> chackLogin(username, password) async {
    final db = await instance.db;
    final response = await db.query(
      "user",
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );
    if (response.isNotEmpty) {
      user_id = response.first['id'] as int?;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("user_id", user_id!);
      return response.first;
    } else {
      return null;
    }
  }

  Future<Object> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("user_id") == null) {
      return Navigator.push(
        context as BuildContext,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
    return prefs.getInt("user_id")!;
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await instance.db;
    final userId = await getUserId();
    return await db.query("Note", where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> insertNote(user_id, title, description) async {
    final db = await instance.db;
    final response = await db.insert("Note", {
      "user_id": user_id,
      "title": title,
      "description": description,
    });

    return response;
  }

  deleteNote(note_id) async {
    final db = await instance.db;
    await db.delete("Note", where: "id = ?", whereArgs: [note_id]);
  }

  updateNote(note_id, title, description) async {
    final db = await instance.db;
    await db.update(
      "Note",
      {"title": title, "description": description},
      where: "id = ?",
      whereArgs: [note_id],
    );
  }
}
