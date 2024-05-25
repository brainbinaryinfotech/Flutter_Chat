import 'package:chatdemo/SignUpScreen.dart';
import 'package:chatdemo/signIn/signInController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
   SignInScreen({Key? key}) : super(key: key);

   SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Sign in"),
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
                  await controller.signIn(controller.emailCon.text, controller.pwdCon.text);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 80,
                  color: Colors.blue,
                  child: Text("Sign In"),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Get.to(SignUpScreen());
                },
                child: Text("Sign-up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
