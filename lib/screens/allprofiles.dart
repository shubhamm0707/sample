import 'dart:convert';

import 'package:axplore/components/input-field.dart';
import 'package:axplore/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../myfile/components/basic.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllProfiles extends StatefulWidget {

  final String url;


  AllProfiles({required this.url});

  @override
  _AllProfilesState createState() => _AllProfilesState();
}

class _AllProfilesState extends State<AllProfiles> {

  TextEditingController controller=TextEditingController();

  String token="";
  List listgroup=[];
  Future getToken() async
  {
    SharedPreferences preferences= await SharedPreferences.getInstance();
    token=preferences.getString("token")!;

  }

  Future getGroupMembers() async {
    await getToken();
    print(token);
    var url = widget.url;
    var response = await http.post(Uri.parse(url), headers: {
      'Authorization': "Bearer ${token}",
      'token-type': 'Bearer',
    },body: {}
    );

    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
     print("success;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
     print(jsonData['data']);
     List data=jsonData['data'];
     setState(() {
       listgroup=data;
     });
    } else {
      print('error code response ${response.body}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupMembers();
  }



  @override
  Widget build(BuildContext context) {
    List list=WidthAndHeight(context);
    var width=list[0];
    var height=list[1];
    print(listgroup);
    print("---------------------------------------------");

    return Scaffold(
      backgroundColor: Color(0xffF0EEEE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              padding: EdgeInsets.only(left: width*23,right: width*23,bottom: height*25,top: height*25),
              child: Row(
                children: [
                  Container(
                    width: width*34,
                    height: height*34,
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle
                    ),
                  ),
                  Width(width*15),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(fontSize: 14,color: primary_color,fontWeight: FontWeight.w500),
                            isDense: true,
                            prefixIcon: Icon(Icons.search,color: primary_color,),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none
                            )),
                      ),
                    )
                  ),
                  Width(width*15),
                  InkWell(
                      onTap: (){
                        showAlert(context, "Take subscription to use filter",mgs: "Subscription");
                      },
                      child: Image.asset("assets/icons/filter.png",width: width*30,))
                ],
              ),
            ),
            for(int i=0;i<listgroup.length;i++)
              Card(
                margin: EdgeInsets.only(top: height*15),
                child: Container(
                  width: width*383,
                  height: height*159,
                  child: Column(
                    children: [
                      Height(height*14),
                      Row(
                        children: [
                          SizedBox(width: width*15,),
                          Container(
                            width: width*75,
                            height: height*75,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle
                            ),
                          ),
                          SizedBox(width: width*16,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MText(text: listgroup[i]["full_name"],size: 14,color: Colors.black,fontWeight: FontWeight.w600),
                              Height(height*4),
                              MText(text: "Cloud & DevOps",size: 12,color: Colors.black,fontWeight: FontWeight.w400),
                              Height(height*2),
                              MText(text: "Banglore",size: 12,color: Colors.black,fontWeight: FontWeight.w400),
                              Height(height*2),
                              MText(text: "Experience : 03 yrs",size: 12,color: Colors.black,fontWeight: FontWeight.w400),
                            ],
                          )
                        ],
                      ),
                      Height(height*20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width*17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Container(width: width*166,height: height*32,decoration: BoxDecoration(
                            border: Border.all(color: primary_color,width: 1),
                            borderRadius: BorderRadius.circular(5)
                          ),
                            child: Center(child: MText(text: "View Profile",size: 16,fontWeight: FontWeight.w600,color: primary_color)),
                          ),
                            Container(width: width*166,height: height*32,decoration: BoxDecoration(
                                border: Border.all(color: primary_color,width: 1),
                                borderRadius: BorderRadius.circular(5)
                            ),
                              child: Center(child: MText(text: "Connect",size: 16,fontWeight: FontWeight.w600,color: primary_color)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )

          ],
        ),
      ),
    );
  }
}
