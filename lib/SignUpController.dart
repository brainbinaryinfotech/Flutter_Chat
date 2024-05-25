import 'package:chatdemo/home/homeScreen.dart';
import 'package:chatdemo/services/pref_services.dart';
import 'package:chatdemo/utils/pref_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpController extends GetxController {
  TextEditingController emailCon = TextEditingController();
  TextEditingController pwdCon = TextEditingController();

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  signUp(email, pwd) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pwd,
      );

      Map<String, dynamic> map2 = {
        "uid": credential.user?.uid.toString(),
        "Email": email,
      };

      await PrefService.setValue(PrefKeys.email, email);
      await PrefService.setValue(PrefKeys.uid, credential.user?.uid.toString());

      addDataInFirebase(userUid: credential.user?.uid ?? "", map: map2);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  addDataInFirebase(
      {required String userUid, required Map<String, dynamic> map}) async {
    await fireStore.collection("Auth").doc(userUid).set(map);

    Get.to(HomeScreen());
  }
}
