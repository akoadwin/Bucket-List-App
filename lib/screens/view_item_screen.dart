// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewItemScreen extends StatefulWidget {
  ViewItemScreen(
      {super.key,
      required this.index,
      required this.description,
      required this.title,
      required this.image});
  String title;
  String image;
  int index;
  String description;

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  Future<void> deleteData() async {
    Navigator.pop(context);

    try {
      Response response = await Dio().delete(
          "https://flutterapitest-562c0-default-rtdb.asia-southeast1.firebasedatabase.app//bucketlist/${widget.index}.json");

      Navigator.pop(context, "refresh");
      print(response);
    } catch (e) {
      print("Error");
    }
  }

  Future<void> markAsComplete() async {
    Map<String, dynamic> data = {"completed": true};

    try {
      Response response = await Dio().patch(
          "https://flutterapitest-562c0-default-rtdb.asia-southeast1.firebasedatabase.app//bucketlist/${widget.index}.json",
          data: data);

      Navigator.pop(context, "refresh");
      print(response);
    } catch (e) {
      print("cannot update");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(onSelected: (value) {
            if (value == 1) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Are you sure to delete?"),
                      actions: [
                        InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        InkWell(
                          onTap: () async {
                            deleteData();
                          },
                          child: const Text(
                            "Confirm",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  });
            }
            if (value == 2) {
              markAsComplete();
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(value: 1, child: Text("Delete")),
              const PopupMenuItem(value: 2, child: Text("Mark as complete")),
            ];
          })
        ],
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            height: 450,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(widget.image))),
          ),
          const SizedBox(
            height: 30,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(5)),
              Text(
                "Description",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(widget.description),
            ),
          )
        ],
      ),
    );
  }
}
