import 'package:chatdemo/home/homeController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    controller.getUid();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        elevation: 0,
      ),
      body: GetBuilder<HomeController>(
        id: "message",
        builder: (controller) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('Auth').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return const SizedBox();
              }
              return snapshot.data!.docs.isEmpty
                  ? const Text("No Result Found")
                  : ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data!.docs[index].data()['uid'] == controller.userUid) {
                    return const SizedBox();
                  }  else  {
                    return InkWell(
                      onTap: () {
                        controller.gotoChatScreen(
                          context,
                          snapshot.data!.docs[index].data()['uid'],
                          snapshot.data!.docs[index].data()['Email'],
                        );
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        child:   Container(
                          padding: EdgeInsets.only(left: 20),
                          alignment: Alignment.center,
                          height: 60,
                          width: 60,
                          decoration:  BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: snapshot.data!.docs[index]
                              .data()['Email']
                              .toString()
                              .isEmpty
                              ? const SizedBox()
                              : Text(
                            snapshot.data!.docs[index]
                                .data()['Email']
                                .toString(),
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              );
            },
          );
        },
      ),
    );
  }
}
