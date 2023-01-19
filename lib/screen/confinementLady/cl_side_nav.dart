import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fyp2/screen/confinementLady/cl_home.dart';
import 'package:fyp2/screen/confinementLady/cl_menu.dart';
import 'package:fyp2/screen/confinementLady/cl_profile.dart';

import '../../models/menu.dart';
import '../aboutUs.dart';
import 'order_tab.dart';

class CLSideNav extends StatefulWidget {
  const CLSideNav({Key key}) : super(key: key);

  @override
  State<CLSideNav> createState() => _CLSideNavState();
}

class _CLSideNavState extends State<CLSideNav> {
  MenuItems currentItem = CLMenuItems.home;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.Style1,
      showShadow: true,
      swipeOffset: 5,
      mainScreenTapClose: true,
      shadowLayer2Color: Colors.blue[100],
      borderRadius: 40.0,
      menuScreen: Builder(builder: (context) {
        return CLMenu(
          currentItem: currentItem,
          onSelectedItem: (item) {
            setState(() {
              currentItem = item;
              ZoomDrawer.of(context).close();
            });
          },
        );
      }),
      mainScreen: getScreen(),
    );
  }

  Widget getScreen() {
    switch (currentItem) {
      case CLMenuItems.home:
        return CLHome();
      case CLMenuItems.profile:
        return CLProfile();
      case CLMenuItems.orders:
        return OrderTabScreen(
        );
     
      case CLMenuItems.aboutus:
        return const AboutUs();
      default:
        return CLHome();
        break;
    }
  }
}
