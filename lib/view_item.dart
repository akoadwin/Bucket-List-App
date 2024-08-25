import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewItemScreen extends StatefulWidget {
  ViewItemScreen(
      {super.key,
      required this.index,
      required this.title,
      required this.image});
  String title;
  String image;
  int index;

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  Future<void> deleteData() async {
    Navigator.pop(context);

    try {
      Response response = await Dio().delete(
          "https://flutterapitest-562c0-default-rtdb.asia-southeast1.firebasedatabase.app//bucketlist/${widget.index}.json");

      Navigator.pop(context);
    } catch (e) {
      print("Error");
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
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(widget.image))),
          ),
        ],
      ),
    );
  }
}
