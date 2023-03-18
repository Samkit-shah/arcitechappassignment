import 'package:hive/hive.dart';

import '../hive/Todo.dart';

class Tododatabox {
  Box<Todo> box = Hive.box('tododata');

  insertUserData(Todo data) {
    try {
      box.add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  updateUserData(dynamic key, Todo data) {
    try {
      box.put(key, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  deletetUserData(int key) {
    try {
      box.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }
}
