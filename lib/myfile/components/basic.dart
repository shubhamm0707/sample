import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;


WidthAndHeight(BuildContext context)
{
var height = (MediaQuery.of(context).size.height)/926;
var width = (MediaQuery.of(context).size.width)/428;

return [width,height];
}

Widget MText(
    {String text = 'Simple Text',
    double size = 16,
    Color color = Colors.black,
    fontWeight = FontWeight.normal,
    align = TextAlign.left,
    underline = false,
    click = null}) {
  return click != null
      ? InkWell(
          onTap: click,
          child: Text(
            text,
            textAlign: align,
            style: TextStyle(
                color: color,
                fontSize: size,
                fontWeight: fontWeight,
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none),
          ),
        )
      : Text(
          text,
          textAlign: align,
          style: TextStyle(
              color: color,
              fontSize: size,
              fontWeight: fontWeight,
              decoration:
                  underline ? TextDecoration.underline : TextDecoration.none),
        );
}

showAlertDialog(BuildContext context, String data)
{


  var alertDialog=new AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.white,
    content:Row(
      children: [
        CircularProgressIndicator(),
        SizedBox(width: 20,),
        Text(data)
      ],
    ),
  );

  showDialog(
      barrierDismissible: false,
      context: context, builder: (context)=>alertDialog);

}

Widget MContainer(
    {width,
    height,
    color = Colors.white,
    borderRadius = 0.0,
    click = null,
    center = false,
    image,
    child}) {
  return center?Center(
    child: click != null
        ? InkWell(
      onTap: click,
      child: Container(
        width: width * 1.0,
        height: height * 1.0,
        decoration: BoxDecoration(
            color: color,
            borderRadius: (borderRadius).runtimeType == int ||
                (borderRadius).runtimeType == double
                ? BorderRadius.circular(borderRadius * 1.0)
                : borderRadius),
        child: child,
      ),
    )
        : Container(
      width: width * 1.0,
      height: height * 1.0,
      decoration: BoxDecoration(
          color: color,
          image: image,
          borderRadius: (borderRadius).runtimeType == int ||
              (borderRadius).runtimeType == double
              ? BorderRadius.circular(borderRadius * 1.0)
              : borderRadius),
      child: child,
    ),
  ):click != null
      ? InkWell(
    onTap: click,
    child: Container(
      width: width * 1.0,
      height: height * 1.0,
      decoration: BoxDecoration(
          color: color,
          borderRadius: (borderRadius).runtimeType == int ||
              (borderRadius).runtimeType == double
              ? BorderRadius.circular(borderRadius * 1.0)
              : borderRadius),
      child: child,
    ),
  )
      : Container(
    width: width * 1.0,
    height: height * 1.0,
    decoration: BoxDecoration(
        color: color,
        borderRadius: (borderRadius).runtimeType == int ||
            (borderRadius).runtimeType == double
            ? BorderRadius.circular(borderRadius * 1.0)
            : borderRadius),
    child: child,
  );
}

void Push({required BuildContext context, @required screen}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
}

void PushReplacement({required BuildContext context, screen}) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => screen));
}

showAlert(BuildContext context,String data,{String mgs="Invalid email or invite code.",bool onlytitle=false})
{

  var alertDialog=new AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.white,
    title:Text(mgs),
    content: onlytitle ? null: Text(data),
  );

  showDialog(context: context, builder: (context)=>alertDialog);

}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> MSnackbar(
    {required BuildContext context,
    required text,
    String label = "",
    Color color=Colors.grey,
    click = null}) {
  SnackBar snackBar = SnackBar(
    content: Text(text),
    duration: Duration(milliseconds: 1500),
    backgroundColor: color,
    action: SnackBarAction(
      label: label,
      onPressed: click == null ? () {} : click,
    ),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

CopyText({required textToCopy, then}) {
  Clipboard.setData(ClipboardData(text: textToCopy)).then((value) {
    then;
  });
}

RandomColor({opacity = 1}) {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
      .withOpacity(opacity * 1.0);
}

Widget Height(height)
{
  return SizedBox(height: height,);
}

Widget Width(width)
{
  return SizedBox(width: width,);
}

// NotificationListener<ScrollNotification>(
//   onNotification:(notification){

//     if(notification is ScrollStartNotification)
//       {
//         setState(() {
//           isScrolling=true;
//         });
//       }else if(notification is ScrollEndNotification)
//         {
//           setState(() {
//             isScrolling=false;
//           });
//         }

//     return true;
//   } ,
//   child: ListView.builder(
//       itemCount: 30,
//       itemBuilder: (context,index) {
//         return TweenAnimationBuilder(
//           tween: Tween(begin: isScrolling?0.0:-0.2,end: isScrolling?-0.2:0.0),
//           duration: Duration(milliseconds: 200),
//           builder: (_,double rotation,child){
//             return Transform(
//               transform:Matrix4.identity()..setEntry(3, 2, 0.01)..rotateX(rotation),
//               alignment: Alignment.center,
//               child: Container(
//                 margin: EdgeInsets.all(20),
//                 width: 100,
//                 height: 100,
//                 color: Colors.red,
//               ),
//             );
//           },
//         );

//       }),
// )
