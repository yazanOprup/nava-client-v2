import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/layouts/auth/login/Login.dart';

class Visitor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: InkWell(
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Lottie.asset("assets/anim/visitor02.json",width: 200),
              ),
              Text("قم بتسجيل الدخول للمتابعة",style: TextStyle(fontSize: 14,color: MyColors.grey),),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("تسجيل الدخول",style: TextStyle(fontSize: 20,color: MyColors.offPrimary,fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
