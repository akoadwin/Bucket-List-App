// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewCompeletedItemScreen extends StatefulWidget {
  ViewCompeletedItemScreen(
      {super.key,
      required this.index,
      required this.title,
      required this.description,
      required this.image});
  String title;
  String image;
  int index;
  String description;

  @override
  State<ViewCompeletedItemScreen> createState() =>
      _ViewCompeletedItemScreenState();
}

class _ViewCompeletedItemScreenState extends State<ViewCompeletedItemScreen> {
  Future<void> deleteData() async {
    Navigator.pop(context);

    try {
      Response response = await Dio().delete(
          "https://flutterapitest-562c0-default-rtdb.asia-southeast1.firebasedatabase.app//bucketlist/${widget.index}.json");
      setState(() {});

      Navigator.pop(context, "refresh");
      print(response);
    } catch (e) {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
