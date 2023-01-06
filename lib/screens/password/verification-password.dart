import 'dart:async';
import 'dart:convert';

import 'package:axplore/screens/password/create-new-password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../components/circular-card.dart';
import '../../components/custom-button.dart';
import '../../constants.dart';
import '../../myfile/components/basic.dart';
import '../register.dart';
import 'package:http/http.dart' as http;

class VerificationPassword extends StatefulWidget {

  final String email;


  VerificationPassword({required this.email});

  @override
  _VerificationPasswordState createState() => _VerificationPasswordState();
}

class _VerificationPasswordState extends State<VerificationPassword> {
  int timeLeft = 40;
  bool resendCode = false;

  Future getOTP () async{

    codeSend();

    if (widget.email.isNotEmpty) {
      showAlertDialog(context, "Please wait");
      print("called");

      var response = await http.post(
          Uri.parse("https://app.axploretech.in/api/forgot-password"), body: (
          {
            'email': widget.email,
          }
      ));
      print(response.statusCode);
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200 && jsonData['status'] == 200) {

        Navigator.of(context).pop();
        MSnackbar(context: context, text: "Code has been resend",color: Colors.green);

      }
      else {
        Navigator.pop(context);
        MSnackbar(context: context,
            text: jsonData['data']['email'][0],
            color: Colors.red);
        print(jsonData['data']['email'][0]);
      }
    }
  }

  resend() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        setState(() {
          resendCode = true;
          timer.cancel();
        });
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  codeSend() {
    if (timeLeft == 0 && resendCode) {
      setState(() {
        resendCode = false;
        timeLeft = 40;
      });
      resend();
    }
  }

  TextEditingController one=TextEditingController();
  TextEditingController two=TextEditingController();
  TextEditingController three=TextEditingController();
  TextEditingController four=TextEditingController();

  Future verify() async {

    if(one.text.isNotEmpty && two.text.isNotEmpty && three.text.isNotEmpty && four.text.isNotEmpty)
    {

      showAlertDialog(context, "  Please wait");

      String otp = one.text+two.text+three.text+four.text;
      print(otp);

      var response= await http.post(Uri.parse("https://app.axploretech.in/api/validate-otp"),body: (

          {
            'email':widget.email,
            'otp':otp
          }
      ));

      print(widget.email);

      var jsonData= jsonDecode(response.body);


      if(response.statusCode==200 && jsonData['status']==200)
      {
        print("done");
        PushReplacement(context: context, screen: CreateNewPassword(email: widget.email,));


      }else
      {
        Navigator.pop(context);
        MSnackbar(context: context, text: "OTP does't match matched",color: Colors.red);

        print('error');
      }
    }
  }

  late FocusNode firstNode;
  late FocusNode secondNode;
  late FocusNode thirdNode;
  late FocusNode forthNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNode = FocusNode();
    secondNode = FocusNode();
    thirdNode = FocusNode();
    forthNode = FocusNode();
    resend();
  }

  @override
  Widget build(BuildContext context) {
    List list = WidthAndHeight(context);
    var width = list[0];
    var height = list[1];
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
        body: MContainer(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 51),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 57,
                      ),
                      CircularCard(
                          width: width,
                          height: height,
                          string: "assets/images/verificationlogo.png"),
                      Height(height * 15),
                      MText(
                          text: "Verification",
                          fontWeight: FontWeight.w500,
                          size: 20,
                          color: primary_color),
                      Height(height * 37),
                      Row(
                        children: [
                          MText(
                              text: "Enter Verification Code",
                              fontWeight: FontWeight.w500,
                              size: 14,
                              color: primary_color),
                        ],
                      ),
                      Height(height * 6),
                      Row(
                        children: [
                          MText(
                              text:
                                  "Code has been sent to Email name@gmail.com",
                              fontWeight: FontWeight.w500,
                              size: 12,
                              color: Color(0xffb7b7b7)),
                        ],
                      ),
                      Height(height * 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: width * 68,
                            height: height * 102,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black45),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              controller: one,
                                focusNode: firstNode,
                                onChanged: (val){
                                  if(val.length>0)
                                    secondNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "*",
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: width * 68,
                            height: height * 102,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black45),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextField(
                              controller: two,
                                focusNode: secondNode,
                                onChanged: (val){
                                  if(val.length>0)
                                    thirdNode.requestFocus();
                                  else if(val.length==0)
                                  {
                                    firstNode.requestFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    hintText: "*", border: InputBorder.none),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: width * 68,
                            height: height * 102,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black45),
                                borderRadius: BorderRadius.circular(10)),
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
                                    hintText: "*", border: InputBorder.none),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            width: width * 68,
                            height: height * 102,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black45),
                                borderRadius: BorderRadius.circular(10)),
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
                                    hintText: "*", border: InputBorder.none),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                ]),
                          ),
                        ],
                      ),
                      Height(height * 48),
                      CustomButton(
                        width: width * 230,
                        height: height * 55,
                        label: "Verify",
                        click: () {
                         verify();
                        },
                      ),
                      Height(height * 31),
                      MText(
                          text: resendCode
                              ? "Resend Code"
                              : "Resend Code in ${timeLeft} s",
                          fontWeight: FontWeight.w500,
                          size: 16,
                          color: resendCode? Color(0xff1D9BF0):Colors.grey,
                          click: () {
                           resendCode ? getOTP():null ;
                          }),
                    ],
                  ),
                ),
              ),
            )));
  }
}
