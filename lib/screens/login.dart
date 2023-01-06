import 'dart:convert';

import 'package:axplore/components/input-field.dart';
import 'package:axplore/constants.dart';
import 'package:axplore/myfile/components/basic.dart';
import 'package:axplore/screens/check-create-profile.dart';
import 'package:axplore/screens/home.dart';
import 'package:axplore/screens/password/forgot-password.dart';
import 'package:axplore/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../components/circular-card.dart';
import '../components/custom-button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {

  final bool isFromRegistration;
  final String mgs;


  LoginScreen({this.isFromRegistration=false,this.mgs=""});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}


class _LoginScreenState extends State<LoginScreen> {

  bool isProfileCreated=false;
  bool validEmail=false;
  bool validPassword=false;

  profile() async
  {
    SharedPreferences preferences= await SharedPreferences.getInstance();
    isProfileCreated=preferences.getBool("isCreated")!;
  }


  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();

  Future storeData(String token) async{

    SharedPreferences preferences= await SharedPreferences.getInstance();

    preferences.setString('token',token );
    print("done");

  }


  Future signIn() async {

    if(emailController.text.isNotEmpty && passController.text.isNotEmpty)
    {
      setState(() {

            validEmail=false;
            validPassword=false;
      });

      showAlertDialog(context, "  Please wait");

      var response= await http.post(Uri.parse("https://app.axploretech.in/api/login"),body: (

          {
            'email':emailController.text.trim(),
            'password':passController.text.trim()
          }
      ));

      var jsonData= jsonDecode(response.body);


      if(response.statusCode==200 && jsonData['status']==200)
      {

         String token=jsonData['data']['token'];
         await storeData(token);
         PushReplacement(context: context, screen: isProfileCreated? HomePage(token: token,): CheckCreateProfile(token: token));
         print("sucess");


      }else
      {
        Navigator.pop(context);
        MSnackbar(context: context, text: "Check email and password",color: Colors.red);

        print('error');
      }
    }else
    {

    }if(emailController.text.isEmpty)
      {

        setState(() {
          validEmail=true;
        });

      }else if(passController.text.isEmpty)
        {
          setState(() {
            validEmail=false;
            validPassword=true;
          });
        }
  }

  late FocusNode firstNode;
  late FocusNode secondNode;
  late FocusNode thirdNode;
  late FocusNode forthNode;
  bool hide=true;
  bool loginOtp=false;

  show()
  {
    if(widget.isFromRegistration)
      MSnackbar(context: context, text: widget.mgs.length==0?"Account has been created":widget.mgs,color: Colors.green);
  }

  TextEditingController one=TextEditingController();
  TextEditingController two=TextEditingController();
  TextEditingController three=TextEditingController();
  TextEditingController four=TextEditingController();

  Future verify() async {

    if(emailController.text.isNotEmpty && one.text.isNotEmpty && two.text.isNotEmpty && three.text.isNotEmpty && four.text.isNotEmpty)
    {

      setState(() {
        validEmail=true;
        validPassword=true;
      });

      showAlertDialog(context, "  Please wait");

      String otp = one.text+two.text+three.text+four.text;
      print(otp);

      var response= await http.post(Uri.parse("https://app.axploretech.in/api/validate-otp"),body: (

          {
            'email':emailController.text,
            'otp':otp
          }
      ));

      var jsonData= jsonDecode(response.body);

      print(jsonData);

      if(response.statusCode==200 && jsonData['status']==200)
      {

        String token=jsonData['data']['token'];
        await storeData(token);
        print(token);
        PushReplacement(context: context, screen: isProfileCreated? HomePage(token: token,): CheckCreateProfile(token: token));
        print("sucess");

      }else
      {
        Navigator.pop(context);
        MSnackbar(context: context, text: "Check email and password",color: Colors.red);

        print('error');
      }
    }else
      {
        if(emailController.text.isEmpty)
          {
            setState(() {
              validEmail=true;
            });
          }else if(passController.text.isEmpty)
            {
              setState(() {
                validEmail=false;
                validPassword=true;
              });
            }
      }
  }

  loginWithOtp() async
  {
    if(emailController.text.isNotEmpty)
      {
        setState(() {
          validEmail=false;
        });
        print("called");

        showAlertDialog(context, "  Please wait");

        var response= await http.post(Uri.parse("https://app.axploretech.in/api/login-with-otp"),body: (

            {
              'email':emailController.text.trim(),
            }
        ));

        print("called2");

        var jsonData= jsonDecode(response.body);

         print(jsonData);
        if(response.statusCode==200 && jsonData['status']==200)
        {

           Navigator.pop(context);
           MSnackbar(context: context, text: "Otp has been sent",color: Colors.green);
           setState(() {
             loginOtp=true;
           });
           firstNode.requestFocus();



        }else
        {
          Navigator.pop(context);
          MSnackbar(context: context, text: "Check the email",color: Colors.red);

          print('error');
        }



      }else
        {
          setState(() {
            validEmail=true;
          });
        }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile();
    Future(show);
    firstNode=FocusNode();
    secondNode=FocusNode();
    thirdNode=FocusNode();
    forthNode=FocusNode();
  }

 

  @override
  Widget build(BuildContext context) {


     List list=WidthAndHeight(context);
     var width=list[0];
     var height=list[1];


    return Scaffold(
      body: MContainer(
        width: double.infinity,
        height: double.infinity,
          color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width*51),
              child: Column(
                children: [
                  SizedBox(height: height*57,),
                  CircularCard(width: width, height: height,string: "assets/images/loginlogo.png"),
                  Height(height*30),
                  InputField(width: width, height: height, controller: emailController,
                      labelText: "Enter Email", text: 'Email',validityVariable: validEmail,error: "Enter the email",),
                  Height(height*15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MText(text: "Password",color: primary_color,fontWeight: FontWeight.w600,size: 14),
                    SizedBox(height: height*7,),
                    TextField(
                        controller: passController,
                        keyboardType: TextInputType.text,
                        obscureText: hide,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(onTap: (){
                              setState(() {
                                hide=!hide;
                              });
                            },
                            child: Icon(hide?Icons.visibility:Icons.visibility_off),),
                            hintText: "Enter Password",
                            labelStyle: TextStyle(fontWeight: FontWeight.normal),
                            enabled: true,
                            errorText: validPassword?"Enter password":null,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(7.0),
                            )
                        )
                    ),
                  ],
                ),
                  Height(height*6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          Push(context: context, screen: ForgotPassword());
                        },

                          child: MText(text: "forgot password",fontWeight: FontWeight.bold,size: 16,color: Color(0xff7B7B7B))),
                    ],
                  ),

                  Height(height*14),
                  MText(text: "or",fontWeight: FontWeight.bold,size: 16,color: Color(0xff7B7B7B)),
                  Height(height*14),
                  MText(text: "Login with OTP",fontWeight: FontWeight.w500,size: 16,
                      color: primary_color,click: (){
                    loginWithOtp();
                      }),
                  Height(height*14),
                  Row(
                    children: [
                      MText(text: "OTP",fontWeight: FontWeight.w500,size: 14,color: primary_color),
                    ],
                  ),
                  Height(height*3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                        width: width*68,
                        height: height*102,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextField(
                          controller: one,
                          keyboardType: TextInputType.number,
                          focusNode: firstNode,
                            onChanged: (val){
                              if(val.length>0)
                              secondNode.requestFocus();
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "*",
                              border: InputBorder.none
                            ),
                            inputFormatters:[
                              LengthLimitingTextInputFormatter(1),
                            ]

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                        width: width*68,
                        height: height*102,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextField(
                          controller: two,
                            keyboardType: TextInputType.number,
                            onChanged: (val){
                              if(val.length>0)
                                thirdNode.requestFocus();
                              else if(val.length==0)
                                {
                                  firstNode.requestFocus();
                                }
                            },
                          focusNode: secondNode,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: "*",
                                border: InputBorder.none
                            ),
                            inputFormatters:[
                              LengthLimitingTextInputFormatter(1),
                            ]

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                        width: width*68,
                        height: height*102,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextField(
                          controller: three,
                            keyboardType: TextInputType.number,
                            onChanged: (val){
                              if(val.length>0)
                                forthNode.requestFocus();
                              else
                                secondNode.requestFocus();
                            },
                            focusNode: thirdNode,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: "*",
                                border: InputBorder.none
                            ),
                            inputFormatters:[
                              LengthLimitingTextInputFormatter(1),
                            ]

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                        width: width*68,
                        height: height*102,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextField(
                          controller: four,
                            keyboardType: TextInputType.number,
                            focusNode: forthNode,
                            onChanged: (val){
                              if(val.length==0)
                                thirdNode.requestFocus();
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: "*",
                                border: InputBorder.none
                            ),
                            inputFormatters:[
                              LengthLimitingTextInputFormatter(1),
                            ]

                        ),
                      ),

                    ],
                  ),
                  Height(height*48),
                  CustomButton(
                    width: width*230,
                    height: height*55,
                    label: "Login",
                    click: (){
                      passController.text.isEmpty?verify():signIn();
                    },
                  ),
                  Height(height*24),
                  MText(text: "Not Registered on Axplore?",fontWeight: FontWeight.w500,size: 16,color: Colors.black),
                  Height(height*10),
                  MText(text: "Register",fontWeight: FontWeight.w500,size: 16,
                      color: Color(0xff1D9BF0),
                      click: (){
                    Push(context: context, screen: RegisterScreen());
                      }

                  ),
                ],
              ),
            ),
          ),
        )
      ),

    );
  }
}
