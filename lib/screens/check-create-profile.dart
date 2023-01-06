import 'package:axplore/screens/create-profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/custom-button.dart';
import '../myfile/components/basic.dart';

class CheckCreateProfile extends StatelessWidget {
  final String token;


  CheckCreateProfile({required this.token});

  @override
  Widget build(BuildContext context) {

    List list=WidthAndHeight(context);
    var width=list[0];
    var height=list[1];

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/useravatar.png",width: width*151,),
            Height(height*46),
            CustomButton(width: width*230, height: height*55, label: "Create Profile", click: (){
              Push(context: context, screen:  CreateProfile(token:token,));
            })
          ],
        ),
      ),
    );
  }
}
