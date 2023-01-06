import 'dart:async';
import 'dart:convert';
import 'dart:io' as file;

import 'package:axplore/screens/home.dart';
import 'package:axplore/screens/password/forgot-password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/circular-card.dart';
import '../components/custom-button.dart';
import '../components/input-field.dart';
import '../constants.dart';
import '../myfile/components/basic.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_alert/cool_alert.dart';

class CreateProfile extends StatefulWidget {
  final String token;

  CreateProfile({required this.token});

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  bool isCompany = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController linkedInController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyProfileController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController educationalController = TextEditingController();

  bool validLinkedin=false;
  bool validCompanyProfile=false;
  bool validEducation=false;

  Future getUserData() async {
    print(widget.token);
    var url = "https://app.axploretech.in/api/edit-profile";
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': "Bearer ${widget.token}",
      'token-type': 'Bearer',
      'content-type': 'application/json'
    });

    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print(jsonData['data'][0]);
      nameController.text = jsonData['data'][0]['full_name'];
      emailController.text = jsonData['data'][0]['email'];
      phoneController.text = jsonData['data'][0]['phone_number'];
      nameController.text = jsonData['data'][0]['full_name'];
    } else {
      print('error code response ${response.body}');
    }
  }

  file.File? file1;
  file.File? file2;
  String name1 = "";
  String name2 = "";
  bool isCreated =false;

  Future isProfileCreated () async {

    SharedPreferences preferences= await SharedPreferences.getInstance();

    preferences.setBool('isCreated', isCreated);
    print("done");

  }

  Future CreateProfileFunction() async {
    if (nameController.text.isNotEmpty &&
        linkedInController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        companyProfileController.text.isNotEmpty &&
        educationalController.text.isNotEmpty) {

      setState(() {
        validLinkedin=false;
        validCompanyProfile=false;
        validEducation=false;
      });

      showAlertDialog(context, "Please wait...");

      var response = await http.post(
          Uri.parse("https://app.axploretech.in/api/create-profile"),
          headers: {
            'Authorization': "Bearer ${widget.token}",
            'token-type': 'Bearer',
          },
          body: ({
            'email': emailController.text,
            'full_name': nameController.text,
            "linkdin_profile_url": linkedInController.text,
            'phone_number': phoneController.text,
            "business_type": isCompany?"Company" : "Proprietor",
            "company_profile": companyProfileController.text,
            "education": educationalController.text,
          }));
      print(response.statusCode);
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData['status'] == 200) {
        setState(() {
          isCreated=true;
        });
       await isProfileCreated();
        PushReplacement(context: context, screen: HomePage(token: widget.token));
        print("success===================");
      } else {
        Navigator.pop(context);
        print(jsonData);
      }
    } else {
      if(linkedInController.text.isEmpty)
        {
          setState(() {
            validLinkedin=true;
          });
        }else if(companyProfileController.text.isEmpty)
          {
            setState(() {
              validLinkedin=false;
              validCompanyProfile=true;
            });
          }else if(educationalController.text.isEmpty)
            {
              setState(() {
                validLinkedin=false;
                validCompanyProfile=false;
                validEducation=true;
              });
            }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
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
                          text: "Create Profile",
                          fontWeight: FontWeight.w500,
                          size: 20,
                          color: primary_color),
                      Height(height * 27),
                      InputField(
                          width: width,
                          height: height,
                          enabled: false,
                          controller: nameController,
                          labelText: "Enter Full Name",
                          text: 'Full Name'),
                      Height(height * 19),
                      InputField(
                          width: width,
                          height: height,
                          controller: linkedInController,
                          labelText: "Enter Link",
                          validityVariable: validLinkedin,
                          error: "Enter LinkedIn profile",
                          text: 'LinkedIn Profile'),
                      Height(height * 19),
                      InputField(
                          width: width,
                          height: height,
                          enabled: false,
                          controller: phoneController,
                          labelText: "Enter Phone Number",
                          text: 'Phone Number'),
                      Height(height * 19),
                      InputField(
                          width: width,
                          height: height,
                          enabled: false,
                          controller: emailController,
                          labelText: "Enter Email",
                          text: 'Email ID'),
                      Height(height * 19),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MText(
                              text: "Business Type",
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
                            isCompany = true;
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
                                  MText(text: "Company"),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: width * 15,
                                    height: height * 15,
                                    decoration: BoxDecoration(
                                        color: isCompany
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
                            isCompany = false;
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
                                  MText(text: "Proprietor"),
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
                                        color: !isCompany
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
                      Height(height * 19),
                      InputField(
                          width: width,
                          height: height,
                          controller: companyProfileController,
                          labelText: "Enter  Company Profile",
                          validityVariable: validCompanyProfile,
                          error: "Enter Company profile",
                          text: 'Company Profile'),
                      Height(height * 19),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MText(
                              text: "Company Logo",
                              color: primary_color,
                              fontWeight: FontWeight.w600,
                              size: 14),
                          SizedBox(
                            height: height * 7,
                          ),
                        ],
                      ),
                      Height(height * 9),
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'pdf', 'doc'],
                              );

                              if (result != null) {
                                final path = result.files.single.path!;

                                setState(() {
                                  file1 = file.File(path);
                                  List arr = path.split("/");
                                  name1 = arr[arr.length - 1];
                                  print("done");
                                  print(
                                      '------------------------------------------${file1}');
                                });
                              }
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: height * 91,
                              ),
                              width: width * 132,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/add.png",
                                    width: width * 40,
                                    height: height * 40,
                                  ),
                                  Height(height * 15),
                                  MText(
                                      text: name1 == "" ? "Uplaod File" : name1,
                                      color: Colors.grey,
                                      size: 12)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Height(height * 19),
                      InputField(
                          width: width,
                          height: height,
                          controller: productController,
                          labelText: "Service 1",
                          text: 'Product/Services'),
                      Height(height * 19),
                      InputField(
                          width: width,
                          height: height,
                          controller: educationalController,
                          labelText: "Enter Degree",
                          validityVariable: validEducation,
                          error: "Enter Educational Qualification",
                          text: 'Educational Qualification'),
                      Height(height * 19),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MText(
                              text: "Attach Proof Of Skills",
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
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'pdf', 'doc'],
                          );

                          if (result != null) {
                            final path = result.files.single.path!;

                            setState(() {
                              file2 = file.File(path);
                              List arr = path.split("/");
                              name2 = arr[arr.length - 1];
                              print(
                                  '------------------------------------------${file2}');
                            });
                          }
                        },
                        child: Container(
                          constraints: BoxConstraints(minHeight: height * 116),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/add.png",
                                width: width * 40,
                                height: height * 40,
                              ),
                              Height(height * 15),
                              MText(
                                  text: name2 == "" ? "Uplaod File" : name2,
                                  color: Colors.grey,
                                  size: 12)
                            ],
                          ),
                        ),
                      ),
                      Height(height * 27),
                      CustomButton(
                        width: width * 230,
                        height: height * 55,
                        label: "Save Details",
                        click: () {
                          CreateProfileFunction();
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
