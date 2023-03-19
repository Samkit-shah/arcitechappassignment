import 'dart:io';
import 'package:arcitechappassignment/functions/Tododatabox.dart';
import 'package:arcitechappassignment/hive/Todo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({super.key, this.data});
  final Todo? data;
  @override
  State<EditTodo> createState() => _EditTodo();
}

class _EditTodo extends State<EditTodo> {
  File _image = File('');
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  var taskController = TextEditingController(text: "Enter Task");

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
  void initState() {
    super.initState();
    taskController.text = widget.data!.task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: PhotoView(
              imageProvider: Image.file(File(widget.data!.img)).image,
              backgroundDecoration: const BoxDecoration(
                color: Colors.white,
              ),
              maxScale: PhotoViewComputedScale.covered * 0.2,
            ),
          ),
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
                      Tododatabox dataBox = Tododatabox();
                      // check if file is not empty
                      if (_image.path.isEmpty) {
                        Todo newData = Todo(
                          task: taskController.text,
                          img: widget.data!.img,
                          date: widget.data!.date,
                        );
                        dataBox.updateData(widget.data!.key, newData);
                        Get.snackbar('Success', 'Task updated Successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white);

                        Navigator.of(context).pop();
                      } else {
                        getApplicationDocumentsDirectory().then(
                          (directory) {
                            final path = directory.path;

                            File(widget.data!.img).delete(); // delete old img
                            final imgRandomName =
                                '${DateTime.now().millisecondsSinceEpoch}.png';
                            _image.copy('$path/$imgRandomName').then((newPath) {
                              Todo newData = Todo(
                                task: taskController.text,
                                img: newPath.path,
                                date: DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now())
                                    .toString(),
                              );
                              dataBox.updateData(widget.data!.key, newData);
                              Get.snackbar(
                                  'Success', 'Task upddated Successfully',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white);

                              Navigator.of(context).pop();
                            });
                          },
                        );
                      }
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
