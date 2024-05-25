import 'package:chatdemo/SignUpController.dart';
import 'package:chatdemo/home/homeScreen.dart';
import 'package:chatdemo/signIn/signInScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

   SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              TextField(
                controller: controller.emailCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: controller.pwdCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: () async{
                  await controller.signUp(controller.emailCon.text, controller.pwdCon.text);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 80,
                  color: Colors.blue,
                  child: Text("Sign Up"),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Get.to(SignInScreen());
                },
                child: Text("Sign-in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
