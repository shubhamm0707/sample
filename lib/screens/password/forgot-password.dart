import 'dart:convert';

import 'package:axplore/screens/login.dart';
import 'package:axplore/screens/password/create-new-password.dart';
import 'package:axplore/screens/password/verification-password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/circular-card.dart';
import '../../components/custom-button.dart';
import '../../components/input-field.dart';
import '../../constants.dart';
import '../../myfile/components/basic.dart';
import '../register.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController emailController=new TextEditingController();

  bool validEmail=false;


  Future getOTP () async{

        if (emailController.text.isNotEmpty) {
          setState(() {
            validEmail=false;
          });
          showAlertDialog(context, "Please wait");
          print("called");

          var response = await http.post(
              Uri.parse("https://app.axploretech.in/api/forgot-password"), body: (
              {
                'email': emailController.text,
              }
          ));
          print(response.statusCode);
          var jsonData = jsonDecode(response.body);
          if (response.statusCode == 200 && jsonData['status'] == 200) {

            PushReplacement(context: context, screen: VerificationPassword(email: emailController.text,));
          }
          else {
            Navigator.pop(context);
            MSnackbar(context: context,
                text: jsonData['data']['email'][0],
                color: Colors.red);
            print(jsonData['data']['email'][0]);
          }
        }
        else {
          setState(() {
            validEmail=true;
          });
        }
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
                      CircularCard(width: width, height: height,string: "assets/images/forgotpassword.png"),
                      Height(height*15),
                      MText(text: "Forgot Password",fontWeight: FontWeight.w500,size: 20,color: primary_color),
                      Height(height*30),
                      InputField(width: width, height: height, controller: emailController,
                          labelText: "Enter Email", text: 'Email',validityVariable: validEmail,error: "Enter the email",),
                      Height(height*15),
                      Height(height*48),
                      CustomButton(
                        width: width*230,
                        height: height*55,
                        label: "Send",
                        click: (){
                          getOTP();
                        },
                      ),
                      Height(height*24),
                      MText(text: "Back to Login",fontWeight: FontWeight.w500,size: 16,
                          color: Color(0xff1D9BF0),
                          click: (){
                            Push(context: context, screen: LoginScreen());
                          }

                      ),
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}
