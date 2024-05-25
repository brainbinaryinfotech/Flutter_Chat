import 'package:chatdemo/chatScreen.dart';
import 'package:chatdemo/services/pref_services.dart';
import 'package:chatdemo/utils/pref_key.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  String? userUid;
  String? roomId;
  DateTime lastMsg = DateTime.now();

  TextEditingController msController = TextEditingController();
  final ScrollController listScrollController = ScrollController();


  @override
  Future<void> onInit() async {

    getUid();
    update(["message"]);
    super.onInit();
  }

  getUid() async {
    userUid = PrefService.getString(PrefKeys.uid).toString();
    update(["message"]);
  }

  String getChatId(String uid1, String uid2) {
    if (uid1.hashCode > uid2.hashCode) {
      return '${uid1}_$uid2';
    } else {
      return '${uid2}_$uid1';
    }
  }

  getRoomId(String otherUid) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection("chats")
        .doc(getChatId(userUid.toString(), otherUid));

    await doc
        .collection(getChatId(userUid.toString(), otherUid))
        .get()
        .then((value) async {

      DocumentSnapshot<Object?> i = await doc.get();
      if (i.exists == false) {
        await doc.set({
          "uidList": [userUid, otherUid],
        });
      }
      if (value.docs.isNotEmpty) {
        roomId = getChatId(userUid.toString(), otherUid);
      } else {
        await FirebaseFirestore.instance
            .collection("chats")
            .doc(getChatId(userUid.toString(), otherUid))
            .collection(getChatId(userUid.toString(), otherUid))
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            roomId = getChatId(userUid.toString(), otherUid);
          } else {
            roomId = getChatId(userUid.toString(), otherUid);
          }
        });
      }
    });
  }

  void gotoChatScreen(BuildContext context, String otherUid, email) async {

    await getRoomId(otherUid);

    Get.to(() => ChatScreen(
      roomId: roomId,
      email: email,
      otherUserUid: otherUid,
      userUid: userUid,
    ));
  }

  void sendMessage(String roomId, otherUid) async {

    String msg = msController.text;

    if (isToday(lastMsg) == false) {
      await sendAlertMsg();
    }

    await setMessage(roomId, msg, userUid);
    setLastMsgInDoc(msg);

    update(['message']);
  }

  Future<void> setLastMsgInDoc(String msg) async {
    await FirebaseFirestore.instance.collection("chats").doc(roomId).update({
      "lastMessage": msg,
      "lastMessageSender": userUid,
      "lastMessageTime": DateTime.now(),
      "lastMessageRead": false,
    });
  }

  Future<void> sendAlertMsg() async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(roomId)
        .collection(roomId!)
        .doc()
        .set({
      "content": "new Day",
      "senderUid": userUid,
      "type": "alert",
      "time": DateTime.now()
    });
  }

  Future<void> setMessage(String roomId, msg, userUid) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(roomId)
        .collection(roomId)
        .doc()
        .set({
      "content": msg,
      "type": "text",
      "senderUid": userUid,
      "time": DateTime.now(),
      "read": false,
    });
    msController.clear();
    update(['message']);
  }

  Future<void> setReadTrue(String docId) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(roomId)
        .collection(roomId!)
        .doc(docId)
        .update({"read": true});
    await setReadInChatDoc(true);
  }

  Future<void> setReadInChatDoc(bool status) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(roomId)
        .update({"lastMessageRead": status});
  }

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  bool isToday(DateTime time) {
    DateTime now = DateTime.now();

    if (now.year == time.year && now.month == time.month && now.day == time.day) {
      return true;
    }
    return false;
  }

}
