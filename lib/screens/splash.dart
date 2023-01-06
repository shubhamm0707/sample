import 'dart:async';

import 'package:axplore/constants.dart';
import 'package:axplore/myfile/components/basic.dart';
import 'package:axplore/screens/check-create-profile.dart';
import 'package:axplore/screens/home.dart';
import 'package:axplore/screens/login.dart';
import 'package:axplore/screens/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen>  with SingleTickerProviderStateMixin {

 late AnimationController _animationController;
 late Animation<double> _animation;

  String token="";
  bool isProfileCreated=false;
  getToken() async
  {
    SharedPreferences preferences= await SharedPreferences.getInstance();
    token=preferences.getString("token")!;
    isProfileCreated=preferences.getBool("isCreated")!;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(_animationController);

    getToken();
    _animationController.forward();
    Timer(
      Duration(seconds: 2),()=>{
          PushReplacement(context: context, screen: token==""? LoginScreen() : isProfileCreated? HomePage(token: token):LoginScreen())
    }
   );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List list = WidthAndHeight(context);
    var width = list[0];
    var height = list[1];
    return Scaffold(
      backgroundColor: primary_color,
      body: Center(
        child: Container(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                  scale: _animation.value,
                  child: Image.asset("assets/images/logo.png",width: width*355,)
              );
            },
          ),
        ),
      )
    );
  }
}
