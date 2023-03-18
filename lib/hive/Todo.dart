import 'package:hive/hive.dart';

part 'Todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  late String task;
  @HiveField(1)
  late String img;
  @HiveField(2)
  late String date;
  @HiveField(3)
  late bool isDone;

  Todo({
    required this.task,
    required this.img,
    required this.date,
    this.isDone = false,
  });
}
