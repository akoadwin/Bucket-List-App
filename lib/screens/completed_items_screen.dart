import 'package:bucket_list/screens/view_completed_item_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CompletedItems extends StatefulWidget {
  const CompletedItems({super.key});

  @override
  State<CompletedItems> createState() => _CompletedItemsState();
}

class _CompletedItemsState extends State<CompletedItems> {
  List<dynamic> bucketListData = [];
  bool isLoading = false;
  bool isError = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          "https://flutterapitest-562c0-default-rtdb.asia-southeast1.firebasedatabase.app/bucketlist.json");

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
          const Text("An error has occured\n   while getting data."),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                getData();
              },
              child: const Text("Try Again"))
        ],
      ),
    );
  }

  Widget listDataWidget() {
    List<dynamic> completedList = bucketListData
        .where((element) => element?["completed"] ?? false)
        .toList();

    return (completedList.isEmpty)
        ? const Center(child: Text("No completed items yet."))
        : ListView.builder(
            itemCount: completedList.length,
            itemBuilder: (BuildContext context, int index) {
              return (completedList[index] is Map)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewCompeletedItemScreen(
                              index: index,
                              description:
                                  completedList[index]?["description"] ?? "",
                              image: completedList[index]?["image"] ?? "",
                              title: completedList[index]?["item"] ?? "",
                            );
                          })).then((value) {
                            if (value == "refresh") {
                              getData();
                            }
                          });
                        },
                        trailing: Text(
                          completedList[index]?["cost"].toString() ?? "",
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              completedList[index]?['image'] ?? ""),
                        ),
                        title: Text(completedList[index]?["item"] ?? ""),
                      ),
                    )
                  : const SizedBox();
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
        title: const Text("Completed List"),
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
