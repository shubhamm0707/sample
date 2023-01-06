import 'dart:convert';

import 'package:axplore/screens/login.dart';
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

class CreateNewPassword extends StatefulWidget {

  final String email;


  CreateNewPassword({required this.email});

  @override
  _CreateNewPasswordState createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {

  TextEditingController pass1=TextEditingController();
  TextEditingController pass2=TextEditingController();
  bool validPass1=false;
  bool validPass2=false;

  Future changePassword() async {

    if(pass1.text.length>=6 && pass2.text.length>=6)
    {
      setState(() {
        validPass1=false;
        validPass2=false;
      });

      if(pass1.text.toString()!=pass2.text.toString())
        {
          showAlert(context, "Confirm password does't matched",mgs: "Retry!");
        }else
          {
            showAlertDialog(context, "  Please wait");

            var response= await http.post(Uri.parse("https://app.axploretech.in/api/change-password"),body: (

                {
                  "new_password":pass1.text.toString(),
                  "confirm_password":pass2.text.toString(),
                  "email":widget.email

                }
            ));

            print(widget.email);

            var jsonData= jsonDecode(response.body);


            if(response.statusCode==200 && jsonData['status']==200)
            {
              print("done");
              PushReplacement(context: context, screen: LoginScreen(isFromRegistration: true,mgs: "Password has been chnaged",));


            }else
            {
              Navigator.pop(context);
              MSnackbar(context: context, text: "Retry, something went wrong",color: Colors.red);

              print('error');
            }
          }

    }else
      {
        if(pass1.text.isEmpty)
          {
            setState(() {
              validPass1=true;
            });
          } else if(pass1.text.isEmpty)
        {
          setState(() {
            validPass1=false;
            validPass2=true;
          });
        }
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
                      CircularCard(width: width, height: height,string: "assets/images/newpassword.png"),
                      Height(height*15),
                      MText(text: "Create New Password",fontWeight: FontWeight.w500,size: 20,color: primary_color),
                      Height(height*30),
                      InputField(width: width, height: height, controller: pass1, labelText: "Enter Password min len:6",
                          text: 'Enter New Password',error: "Enter new password",validityVariable: validPass1,),
                      Height(height*15),
                      InputField(width: width, height: height, controller: pass2,
                          labelText: "********", text: 'Confirm Password',error: "Enter password again",validityVariable: validPass2,),
                      Height(height*15),
                      Height(height*48),
                      CustomButton(
                        width: width*230,
                        height: height*55,
                        label: "Submit",
                        click: (){
                          changePassword();
                        },
                      ),
                      Height(height*24),
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}

