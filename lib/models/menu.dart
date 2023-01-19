import 'package:flutter/material.dart';

class MenuItems {
  final String title;
  final IconData icon;

  const MenuItems(this.title, this.icon);
}

class CustomerMenuItems {
  static const home = MenuItems('Home', Icons.home);
  static const profile = MenuItems('Profile', Icons.person);
  static const orders = MenuItems('Orders', Icons.pending_actions);
  static const refund = MenuItems('Refund', Icons.refresh_rounded);
  static const aboutus = MenuItems('About Us', Icons.info);

  static const all = <MenuItems>[
    home,
    profile,
    refund,
    orders,
    aboutus,
  ];
}

class CLMenuItems {
  static const home = MenuItems('Home', Icons.home);
  static const profile = MenuItems('Profile', Icons.person);
  static const orders = MenuItems('Orders', Icons.pending_actions);
  static const aboutus = MenuItems('About Us', Icons.info);

  static const all = <MenuItems>[
    home,
    profile,
    orders,
    aboutus,
  ];
}
