// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class AddBucketListScreen extends StatefulWidget {
  int newIndex;
  AddBucketListScreen({
    super.key,
    required this.newIndex,
  });

  @override
  State<AddBucketListScreen> createState() => _AddBucketListScreenState();
}

class _AddBucketListScreenState extends State<AddBucketListScreen> {
  var addForm = GlobalKey<FormState>();
  TextEditingController itemText = TextEditingController();
  TextEditingController costText = TextEditingController();
  TextEditingController imageURLText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();

  Future<void> addData() async {
    Map<String, dynamic> data = {
      "item": itemText.text,
      "cost": costText.text,
      "completed": false,
      "image": imageURLText.text,
      "description": descriptionText.text
    };

    try {
      Response response = await Dio().patch(
          "https://flutterapitest-562c0-default-rtdb.asia-southeast1.firebasedatabase.app//bucketlist/${widget.newIndex}.json",
          data: data);

      Navigator.pop(context, "refresh");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Bucket List"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: addForm,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This must not be empty";
                    }
                    return null;
                  },
                  controller: itemText,
                  decoration: const InputDecoration(labelText: "Item"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This must not be empty";
                    }
                    return null;
                  },
                  controller: costText,
                  decoration:
                      const InputDecoration(labelText: "Estimated Cost"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (!isURL(value)) {
                      return 'Please enter a valid URL';
                    }

                    return null;
                  },
                  controller: imageURLText,
                  decoration: const InputDecoration(labelText: "Image URL"),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This must not be empty";
                    }

                    return null;
                  },
                  controller: descriptionText,
                  decoration:
                      const InputDecoration(labelText: "Some description"),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (addForm.currentState!.validate()) {
                                addData();
                              }
                            },
                            child: const Text("Add Data"))),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
