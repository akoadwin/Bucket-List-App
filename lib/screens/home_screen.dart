// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:bucket_list/screens/add_screen.dart';
import 'package:bucket_list/screens/view_item_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketListData = [];
  bool isLoading = false;
  bool isError = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          "https://flutterapitest-562c0-default-rtdb.asia-southeast1.firebasedatabase.app//bucketlist.json");

      isError = false;
      isLoading = false;

      if (response.data is List) {
        bucketListData = response.data;
      } else {
        bucketListData = [];
      }

      setState(() {});
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});
    }
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/mark.png",
            height: 50,
          ),
          Text("An error has occured\n   while getting data."),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                getData();
              },
              child: Text("Try Again"))
        ],
      ),
    );
  }

  Widget listDataWidget() {
    List<dynamic> filteredList = bucketListData
        .where((element) => !(element?["completed"] ?? false))
        .toList();

    return filteredList.isEmpty
        ? Center(child: Text("No Data was found"))
        : ListView.builder(
            itemCount: bucketListData.length,
            itemBuilder: (BuildContext context, int index) {
              return (bucketListData[index] is Map &&
                      (!(bucketListData[index]?["completed"] ?? false)))
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewItemScreen(
                              index: index,
                              description:
                                  bucketListData[index]?["description"] ?? "",
                              image: bucketListData[index]?["image"] ?? "",
                              title: bucketListData[index]?["item"] ?? "",
                            );
                          })).then((value) {
                            if (value == "refresh") {
                              getData();
                            }
                          });
                        },
                        trailing: Text(
                          bucketListData[index]?["cost"].toString() ?? "",
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              bucketListData[index]?['image'] ?? ""),
                        ),
                        title: Text(bucketListData[index]?["item"] ?? ""),
                      ),
                    )
                  : SizedBox();
            });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddBucketListScreen(
                newIndex: bucketListData.length,
              );
            })).then((value) {
              if (value == "refresh") {
                getData();
              }
            });
          },
          shape: CircleBorder(),
          backgroundColor: (Colors.blueGrey.shade900),
          child: Icon(Icons.add)),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: getData,
              child: Icon(
                Icons.refresh_sharp,
                color: Colors.blueGrey.shade900,
              ),
            ),
          )
        ],
        title: const Text("Bucket List"),
      ),
      body: RefreshIndicator(
          color: Colors.blueGrey.shade500,
          onRefresh: () async {
            getData();
          },
          child: isLoading
              ? LinearProgressIndicator(
                  color: Colors.lightBlue,
                  backgroundColor: Colors.blueGrey.shade900,
                )
              : isError
                  ? errorWidget()
                  : listDataWidget()),
    );
  }
}
