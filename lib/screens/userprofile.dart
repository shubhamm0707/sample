import 'dart:convert';

import 'package:axplore/components/custom-button.dart';
import 'package:axplore/screens/allprofiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../myfile/components/basic.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {


  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

   String name="",email="",phone="";

   String token="";
   bool isProfileCreated=false;
    Future getToken() async
   {
     SharedPreferences preferences= await SharedPreferences.getInstance();
     token=preferences.getString("token")!;
     isProfileCreated=preferences.getBool("isCreated")!;
   }

  Future getUserData() async {
    await getToken();
    print(token);
    var url = "https://app.axploretech.in/api/edit-profile";
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': "Bearer ${token}",
      'token-type': 'Bearer',
      'content-type': 'application/json'
    }
    );

    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(jsonData['data'][0]);
      setState(() {
        name = jsonData['data'][0]['full_name'];
        email = jsonData['data'][0]['email'];
        phone = jsonData['data'][0]['phone_number'];
      });
    } else {
      print('error code response ${response.body}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    print("called");
  }


  @override
  Widget build(BuildContext context) {
    List list = WidthAndHeight(context);
    var width = list[0];
    var height = list[1];
    return SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: height*245,
                decoration: BoxDecoration(
                  color: primary_color
                ),
                child: Column(
                  children: [
                    Height(height*19),
                    Container(
                      width: width*125,
                      height: height*125,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle
                      ),
                    ),
                    Height(height*10),
                    MText(text: name,size: 20,fontWeight: FontWeight.w700,color: Colors.white),
                    Height(height*10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: MText(text:"Edit profile",size: 16,fontWeight: FontWeight.w500,color: primary_color)
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*35),
                width: double.infinity,
                height: height*75,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black26
                    )
                  )
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/linkedin.png",width: width*24,),
                    Width(width*12),
                    Expanded(child: Container(
                      child: Text("https://*********************************"),))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*35),
                width: double.infinity,
                height: height*75,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.black26
                        )
                    )
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/call.png",width: width*24,),
                    Width(width*12),
                    Expanded(child: Container(
                      child: Text("${phone}"),))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*35),
                width: double.infinity,
                height: height*75,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.black26
                        )
                    )
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/gmail.png",width: width*24,),
                    Width(width*12),
                    Expanded(child: Container(
                      child: Text("${email}"),))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*35),
                width: double.infinity,
                height: height*75,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.black26
                        )
                    )
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/address.png",width: width*24,),
                    Width(width*12),
                    Expanded(child: Container(
                      child: Text("************************"),))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*35),
                width: double.infinity,
                height: height*75,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.black26
                        )
                    )
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/briefcase.png",width: width*24,),
                    Width(width*12),
                    Expanded(child: Container(
                      child: Text("*********************************"),))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width*35),
                width: double.infinity,
                height: height*75,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.black26
                        )
                    )
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/hat.png",width: width*24,),
                    Width(width*12),
                    Expanded(child: Container(
                      child: Text("*****************************"),))
                  ],
                ),
              ),
              Height(height*20),
              CustomButton(width: width*195, height: height*43, label: "Group Members", click: (){

                Push(context: context, screen: AllProfiles(url: "https://app.axploretech.in/api/get-group-members",));
              })
            ],
          ),
        ),
    );
  }
}
