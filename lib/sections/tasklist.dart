import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../edit.dart';
import '../functions/Tododatabox.dart';
import '../hive/Todo.dart';
import '../view.dart';

getTaskList(bool isCompleted) {
  Tododatabox dataBox = Tododatabox();
  Box<Todo> box = Hive.box('tododata');
  return ValueListenableBuilder(
    valueListenable: dataBox.box.listenable(),
    builder: (context, Box<Todo> tododata, widget) {
      List<Todo> todoDataFromBox = tododata.values.toList();
      List<Todo> todoDataList = todoDataFromBox
          .where((element) => element.isDone == isCompleted)
          .toList();

      if (todoDataList.isNotEmpty) {
        return ListView.builder(
          padding: const EdgeInsets.all(4.0),
          itemCount: todoDataList.length,
          itemBuilder: (context, index) {
            var data = todoDataList[index];
            DateFormat dateFormat = DateFormat("dd/MM/yyyy");
            DateTime dateTime = dateFormat.parse(data.date);

            print(data.date);
            print(dateTime);
            String dateToString = dateFormat.format(dateTime);
            print(dateToString);
            return Container(
                margin: const EdgeInsets.only(bottom: 20.00),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    data.task,
                  ),
                  subtitle: Text(dateToString),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Get.to(() => EditTodo(
                                data: data,
                              ));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                          Get.to(() => ViewTodo(
                                data: data,
                              ));
                        },
                      ),
                      IconButton(
                        icon: Icon(isCompleted ? Icons.undo : Icons.done,
                            color: Colors.green),
                        onPressed: () {
                          if (isCompleted) {
                            dataBox.updateStatus(data.key, false);
                            DefaultTabController.of(context).animateTo(0);
                          } else {
                            dataBox.updateStatus(data.key, true);
                            DefaultTabController.of(context).animateTo(1);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          var res = dataBox.deletetData(data.key);
                          if (res) {
                            Get.snackbar('Success', 'Data Deleted Successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white);
                          } else {
                            Get.snackbar(
                                'Error', 'Data Not Deleted Successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          }
                        },
                      ),
                    ],
                  ),
                ));
          },
        );
      } else {
        return const Center(child: Text('No Task Found'));
      }
    },
  );
}
