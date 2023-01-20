// ignore_for_file: prefer_const_declarations, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'todots';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('not nuu');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.dp';
        debugPrint('in database path');
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          debugPrint('creat anew one');
          // When creating the db, create the table
          await db.execute(
            'CREATE TABLE $_tableName ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title STRING, note TEXT, date STRING, '
            'startTime STRING, endTime STRING, '
            'remind INTEGER, repeat STRING, '
            'color INTEGER, '
            'isCompleted INTEGER)',
          );
        });
        //print('DATA Base Created');
      } catch (e) {
        print(e);
       // print('Fukeen Eroor');
      }
    }
  }

  static Future<int> insert(Task? task) async {
    //print('insert function called');
    try {
      return await _db!.insert(_tableName, task!.toJson());
    } catch (e) {
      //print('we are Fukken Here');
      return 90000;
    }
  }

  static Future<List<Map<String, dynamic>>> query() async {
    //print('query function is called');
    return await _db!.query(
      _tableName,
    );
  }

  static Future<int> delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id= ?', whereArgs: [task.id]);
  }
  static Future<int> deleteAll() async {
    return await _db!.delete(_tableName);
  }

  static Future<int> update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE todots
    SET isCompleted =?
    WHERE id =?
    
''', [1, id]);
  }
}
