
import 'dart:convert';


import 'package:flutter/material.dart';
import 'AcercaDe.dart';
import 'custom_drawer/drawer_user_controller.dart';
import 'custom_drawer/home_drawer.dart';
import '../Stores.dart';


class NavigationHomeScreen extends StatefulWidget {

  const NavigationHomeScreen({Key? key}) : super(key: key,);
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;


  @override
  void initState() {
    drawerIndex = DrawerIndex.REINA;
    screenView = Stores();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.REINA) {
        setState(() {
          screenView = Stores();
        });

      }else if (drawerIndex == DrawerIndex.SETTINGS) {
        setState(() {

        });
      } else if (drawerIndex == DrawerIndex.Acerca) {
        setState(() {
          screenView = AcercaDe();
        });
      } else {
        print('Salir');
        //do in your way......
      }
    }
  }
}
