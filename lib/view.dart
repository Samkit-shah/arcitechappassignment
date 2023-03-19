import 'dart:io';

import 'package:arcitechappassignment/hive/Todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:photo_view/photo_view.dart';

class ViewTodo extends StatefulWidget {
  const ViewTodo({super.key, this.data});
  final Todo? data;

  @override
  State<ViewTodo> createState() => _ViewTodoState();
}

class _ViewTodoState extends State<ViewTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Todo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const SizedBox(
            height: 20,
          ),
          Text(
            widget.data!.task,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(widget.data!.date),
        ],
      ),
    );
  }
}
