import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'home/homeController.dart';

class ChatScreen extends StatelessWidget {
  final String? email;
  final String? roomId;
  final String? otherUserUid;
  final String? userUid;

   ChatScreen({Key? key,
     this.email,
     this.userUid,
     this.otherUserUid,
     this.roomId}) : super(key: key);

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(email.toString()),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: PaginateFirestore(
                scrollController: controller.listScrollController,
                isLive: true,
                reverse: true,
                itemBuilder: (context, docementSnapshot, index) {
                  Map<String, dynamic>? data = docementSnapshot[index]
                      .data() as Map<String, dynamic>?;
                  if (data == null) {
                    return const SizedBox();
                  }
                  /* if (index == 0) {
                        controller.lastMsg = data['time'].toDate();
                      }*/

                  if (data['read'] != true &&
                      data['senderUid'].toString() != userUid) {
                    controller.setReadTrue(docementSnapshot[index].id);
                  }

                  Widget box = data['type'] == "alert"
                      ? const SizedBox()
                      : Column(
                    children: [
                      SizedBox(
                        width: Get.width,
                        height: 35,
                        child: Center(
                          child: Text(
                            controller.timeAgo(data['time'].toDate()),
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                        data['senderUid'].toString() == userUid
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          // Text(controller.data['time'].toString(),style: sfProTextReguler(fontSize: 12,color:ColorRes.colorF0F0F0 ),),

                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: Get.width / 1.3,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),

                               color: data['senderUid']
                                        .toString() ==
                                        userUid
                                        ? Colors.green
                                        : Colors.lightBlue
                            ),
                            child: Text(
                              data['content'].toString(),
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                  if ((index + 1) == docementSnapshot.length) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        box,
                      ],
                    );
                  }

                  return box;
                },
                query: FirebaseFirestore.instance
                    .collection("chats")
                    .doc(roomId)
                    .collection(roomId!)
                    .orderBy("time", descending: true),
                itemBuilderType: PaginateBuilderType.listView),
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
            ),
            child:  Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 20),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white.withOpacity(0.4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller:
                      controller.msController,
                      style: const TextStyle(
                          color: Colors.black),
                      decoration: InputDecoration(
                          hintText:
                          "Type your message...",
                          hintStyle: TextStyle(
                              fontSize: 17,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  InkWell(
                      onTap: () {

                        if (controller.msController.text.isNotEmpty) {
                          controller.sendMessage(
                              roomId.toString(),
                              otherUserUid,
                              );
                          FocusScope.of(context)
                              .unfocus();
                        }
                      },
                      child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
