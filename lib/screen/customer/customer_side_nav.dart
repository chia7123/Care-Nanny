import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fyp2/screen/aboutUs.dart';
import 'package:fyp2/screen/customer/cancel_order_status.dart';
import 'package:fyp2/screen/customer/customer_profile.dart';
import 'package:fyp2/screen/customer/order_tab.dart';

import '../../models/menu.dart';
import 'customer_home.dart';
import 'customer_menu.dart';

class CustomerSideNav extends StatefulWidget {
  const CustomerSideNav({
    Key key,
  }) : super(key: key);
  @override
  State<CustomerSideNav> createState() => _CustomerSideNavState();
}

class _CustomerSideNavState extends State<CustomerSideNav> {
  MenuItems currentItem = CustomerMenuItems.home;

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
        return CustomerMenu(
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
      case CustomerMenuItems.home:
        return CustomerHome();
      case CustomerMenuItems.profile:
        return CustomerProfile();
      case CustomerMenuItems.orders:
        return OrderTabScreen(
        );
      case CustomerMenuItems.aboutus:
        return const AboutUs();
        case CustomerMenuItems.refund:
        return CancelOrderStatusPage();
      default:
        return CustomerHome();
        break;
    }
  }
}
