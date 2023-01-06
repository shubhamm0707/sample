import 'package:flutter/material.dart';
import '../constants.dart';
import '../myfile/components/basic.dart';

class InputField extends StatelessWidget {

  double width;
  double height;
  TextEditingController controller;
  String labelText;
  String text;
  bool enabled;
  String error;
  bool validityVariable;
  bool number;


  InputField(
  {required this.width,required this.height,required this.controller,
    required this.labelText,required this.text,this.enabled=true,this.error="",this.validityVariable=false,this.number=false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MText(text: text,color: primary_color,fontWeight: FontWeight.w600,size: 14),
        SizedBox(height: height*7,),
        TextField(
          enabled: enabled,
            controller: controller,
            keyboardType: number?TextInputType.number:TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: labelText,
                 labelStyle: TextStyle(fontWeight: FontWeight.normal),
                enabled: true,
                suffixIcon: validityVariable?Icon(Icons.error,color: Colors.red,):null,
                errorText: validityVariable?error:null,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(7.0),
                )
            )
        ),
      ],
    );
  }
}
