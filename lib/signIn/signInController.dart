import 'package:chatdemo/home/homeScreen.dart';
import 'package:chatdemo/services/pref_services.dart';
import 'package:chatdemo/utils/pref_key.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController{
  TextEditingController emailCon = TextEditingController();
  TextEditingController pwdCon = TextEditingController();


  signIn(email, pwd) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd
      );
      await PrefService.setValue(PrefKeys.email, email);
      await PrefService.setValue(PrefKeys.uid, credential.user?.uid.toString());

      Get.to(HomeScreen());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }




  }



}