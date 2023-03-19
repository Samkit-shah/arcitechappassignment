import 'dart:io';

import 'package:hive/hive.dart';

import '../hive/Todo.dart';

class Tododatabox {
  Box<Todo> box = Hive.box('tododata');

  insertData(Todo data) {
    try {
      box.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  updateData(dynamic key, Todo data) {
    try {
      box.put(key, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  deletetData(int key) {
    try {
      File(box.get(key)!.img).delete();
      box.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  updateStatus(int key, bool isCompleted) {
    try {
      box.put(
          key,
          Todo(
            task: box.get(key)!.task,
            date: box.get(key)!.date,
            img: box.get(key)!.img,
            isDone: isCompleted,
          ));
      return true;
    } catch (e) {
      return false;
    }
  }
}
