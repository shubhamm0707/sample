import 'package:axplore/components/custom-button.dart';
import 'package:axplore/screens/allprofiles.dart';
import 'package:axplore/screens/create-profile.dart';
import 'package:axplore/screens/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../myfile/components/basic.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {

  final String token;


  HomePage({required this.token});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  String token="";


    List<Widget> _widgetOptions = <Widget>[
    UserProfile(),
    AllProfiles(url: "")
  ];

  void _onItemTapped(int index) {
    setState(() {
      if(index>1)
        {
          _selectedIndex=1;
        }else
      _selectedIndex = index;

    });
  }

  getToken() async
  {

    SharedPreferences preferences= await SharedPreferences.getInstance();
      token=preferences.getString("token")!;
      print("token");

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }


  @override
  Widget build(BuildContext context) {


    List list=WidthAndHeight(context);
    var width=list[0];
    var height=list[1];

    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
             icon:
                 Image.asset("assets/icons/user.png",width: width*27,),
            label: ""
          ),
          BottomNavigationBarItem(
              icon:
              Image.asset("assets/icons/search.png",width: width*27,),
              label: ""
          ),
          BottomNavigationBarItem(
              icon:
              Image.asset("assets/icons/ins.png",width: width*27,),
              label: ""
          ),
          BottomNavigationBarItem(
              icon:
              Image.asset("assets/icons/menuu.png",width: width*27,),
              label: ""
          ),
          BottomNavigationBarItem(
              icon:
              Image.asset("assets/icons/tick.png",width: width*27,),
              label: ""
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
