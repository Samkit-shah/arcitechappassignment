import 'package:arcitechappassignment/hive/Todo.dart';
import 'package:arcitechappassignment/view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import 'add.dart';
import 'functions/Tododatabox.dart';
import 'sections/tasklist.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Tododatabox dataBox = Tododatabox();
  late TabController _tabController;
  Box<Todo> box = Hive.box('tododata');
  List<Widget> myTabs = [
    const Tab(
      text: 'Pending',
    ),
    const Tab(
      text: 'Completed',
    ),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(color: Colors.black),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: const IconThemeData(color: Colors.black),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
          selectedColor: Colors.black,
          selectedTileColor: Colors.black,
          textColor: Colors.black,
        ),
      ),
      title: 'Arcitech App Assignment',
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Arcitech App Assignment'),
            actions: [
              IconButton(
                icon: Get.isDarkMode
                    ? const Icon(Icons.light_mode)
                    : const Icon(Icons.dark_mode),
                onPressed: () {
                  changeTheme();

                  setState(() {});
                },
              ),
            ],
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            children: <Widget>[
              Container(
                child: getTaskList(false),
              ),
              Container(
                child: getTaskList(true),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => const AddTask());
            },
            tooltip: 'Add Task',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  changeTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}
