import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:arcitechappassignment/functions/Tododatabox.dart';
import 'package:arcitechappassignment/hive/Todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'home.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  File _image = File('');
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  var taskController = TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Column(
        children: [
          //  Form
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // label
                TextFormField(
                  controller: taskController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Task',
                  ),
                ),

                ElevatedButton(
                  onPressed: getImage,
                  child: const Text('Upload Image'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // check if file is not empty
                      if (_image.path.isEmpty) {
                        Get.snackbar('Error', 'Please upload image',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                        return;
                      }
                      Tododatabox dataBox = Tododatabox();
                      getApplicationDocumentsDirectory().then(
                        (directory) {
                          final path = directory.path;

                          // final imgRandomName =
                          //     '${DateTime.now().millisecondsSinceEpoch}.png';
                          final imgRandomName =
                              '${DateTime.now().millisecondsSinceEpoch}.png';
                          _image.copy('$path/$imgRandomName').then((newPath) {
                            print(newPath.path);
                            Todo data = Todo(
                              task: taskController.text,
                              img: newPath.path,
                              date: DateTime.now().toString(),
                            );
                            dataBox.insertUserData(data);
                            Get.snackbar('Success', 'Data Added Successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white);

                            Get.offAll(const MyHomePage());
                          });
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
