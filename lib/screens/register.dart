import 'dart:convert';
import 'package:axplore/components/input-field.dart';
import 'package:axplore/constants.dart';
import 'package:axplore/myfile/components/basic.dart';
import 'package:axplore/screens/create-profile.dart';
import 'package:axplore/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../components/circular-card.dart';
import '../components/custom-button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool validName = false;
  bool validemail = false;
  bool validPassword = false;
  bool validPhoneNumber = false;
  bool validAddress = false;

  bool? checked = true;
  bool isKayastha = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future signup() async {
    if (!checked!) {
      MSnackbar(context: context, text: "Check the box");
    } else {
      if (nameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          addressController.text.isNotEmpty) {
        setState(() {
          validName = false;
          validemail = false;
          validPassword = false;
          validPhoneNumber = false;
          validAddress = false;
        });
        showAlertDialog(context, "Please wait");
        print("called");
        String Kayastha = isKayastha ? "1" : "0";

        var response = await http.post(
            Uri.parse("https://app.axploretech.in/api/register"),
            body: ({
              'email': emailController.text,
              'full_name': nameController.text,
              'phone_number': phoneController.text,
              'password': passwordController.text,
              'address': addressController.text,
              "is_kayastha": Kayastha,
            }));
        print(response.statusCode);
        var jsonData = jsonDecode(response.body);
        if (response.statusCode == 200 && jsonData['status'] == 200) {
          PushReplacement(
              context: context,
              screen: LoginScreen(
                isFromRegistration: true,
              ));
        } else {
          Navigator.pop(context);
          MSnackbar(
              context: context,
              text: jsonData['data']['email'][0],
              color: Colors.red);
          print(jsonData['data']['email'][0]);
        }
      } else {
        if (nameController.text.isEmpty) {
          setState(() {
            validName = true;
          });
        } else if (emailController.text.isEmpty) {
          setState(() {
            validName = false;
            validemail = true;
          });
        } else if (passwordController.text.isEmpty || passwordController.text.length<6) {
          setState(() {
            validName = false;
            validemail = false;
            validPassword = true;
          });
        } else if (phoneController.text.isEmpty || phoneController.text.length!=10) {
          setState(() {
            validName = false;
            validemail = false;
            validPassword = false;
            validPhoneNumber = true;
          });
        } else if (addressController.text.isEmpty) {
          setState(() {
            validName = false;
            validemail = false;
            validPassword = false;
            validPhoneNumber = false;
            validAddress = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List list = WidthAndHeight(context);
    var width = list[0];
    var height = list[1];

    return Scaffold(
        body: MContainer(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                          string: "assets/images/registerlogo.png"),
                      SizedBox(
                        height: height * 20,
                      ),
                      MText(
                          text: "Enter Your Details",
                          fontWeight: FontWeight.w500,
                          size: 20,
                          color: primary_color),
                      Height(height * 27),
                      InputField(
                          width: width,
                          height: height,
                          controller: nameController,
                          labelText: "Enter Full Name",
                          error: "Enter the name",
                          validityVariable: validName,
                          text: 'Full Name'),
                      Height(height * 19),
                      InputField(
                          width: width,
                          height: height,
                          controller: emailController,
                          labelText: "Enter Email",
                          error: "Enter the email",
                          validityVariable: validemail,
                          text: 'Email'),
                      Height(height * 19),
                      InputField(
                          width: width,
                          height: height,
                          controller: passwordController,
                          labelText: "Enter Password",
                          error: "minimum password length: 6",
                          validityVariable: validPassword,
                          text: 'Password'),
                      Height(height * 14),
                      InputField(
                          width: width,
                          height: height,
                          controller: phoneController,
                          error: "Enter the valid phone number",
                          validityVariable: validPhoneNumber,
                          labelText: "Enter Phone Number",
                          number: true,
                          text: 'Phone Number'),
                      Height(height * 19),
                      InputField(
                          width: width,
                          height: height,
                          controller: addressController,
                          labelText: "Enter Your Address",
                          error: "Enter the address",
                          validityVariable: validAddress,
                          text: 'Address'),
                      Height(height * 19),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MText(
                              text: "Are You Kayastha?",
                              color: primary_color,
                              fontWeight: FontWeight.w600,
                              size: 14),
                          SizedBox(
                            height: height * 7,
                          ),
                        ],
                      ),
                      Height(height * 9),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isKayastha = true;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: height * 83 / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Width(width * 14),
                                  MText(text: "Yes"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: width * 15,
                                    height: height * 15,
                                    decoration: BoxDecoration(
                                        color: isKayastha
                                            ? primary_color
                                            : Colors.white,
                                        border: Border.all(
                                            color: primary_color, width: 2),
                                        shape: BoxShape.circle),
                                  ),
                                  Width(width * 21),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isKayastha = false;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: height * 83 / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Width(width * 14),
                                  MText(text: "No"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: width * 15,
                                    height: height * 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: primary_color, width: 2),
                                        color: !isKayastha
                                            ? primary_color
                                            : Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                  Width(width * 21),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Height(height * 21),
                      CheckboxListTile(
                          value: checked,
                          title: MText(
                              text: "I agree to Terms and Conditions",
                              size: 12,
                              color: Colors.black),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (val) {
                            setState(() {
                              checked = val;
                            });
                          }),
                      Height(height * 27),
                      CustomButton(
                        width: width * 230,
                        height: height * 55,
                        label: "Register Now",
                        click: () {
                          signup();
                        },
                      ),
                      Height(height * 27)
                    ],
                  ),
                ),
              ),
            )));
  }
}
