import 'package:arcitechappassignment/hive/Todo.dart';
import 'package:arcitechappassignment/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import 'add.dart';
import 'functions/Tododatabox.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Tododatabox dataBox = Tododatabox();
  Box<Todo> box = Hive.box('tododata');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arcitech App Assignment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(const AddNote());
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: dataBox.box.listenable(),
              builder: (context, Box<Todo> usersdata, widget) {
                List<Todo> usersDataFromBox = usersdata.values.toList();

                List<Todo> usersDataList = usersDataFromBox.reversed.toList();

                if (usersDataList.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(4.0),
                    itemCount: usersDataList.length,
                    itemBuilder: (context, index) {
                      var data = usersDataList[index];
                      DateFormat dateFormat = DateFormat("dd-MM-yyyy ");
                      DateTime dateTime = dateFormat.parse(data.date);
                      String dateToString = dateFormat.format(dateTime);
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
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    Get.to(ViewTodo(
                                      data: data,
                                    ));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    var res = dataBox.deletetUserData(data.key);
                                    if (res) {
                                      Get.snackbar('Success',
                                          'Data Deleted Successfully',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white);
                                    } else {
                                      Get.snackbar('Error',
                                          'Data Not Deleted Successfully',
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
                  return const Center(child: Text('No Data'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  doNothing() {}
}
