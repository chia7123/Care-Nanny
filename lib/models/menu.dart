import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;

  const MenuItem(this.title, this.icon);
}

class CustomerMenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const profile = MenuItem('Profile', Icons.person);
  static const orders = MenuItem('Orders', Icons.pending_actions);
  static const aboutus = MenuItem('About Us', Icons.info);

  static const all = <MenuItem>[
    home,
    profile,
    orders,
    aboutus,
  ];
}

class CLMenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const profile = MenuItem('Profile', Icons.person);
  static const orders = MenuItem('Orders', Icons.pending_actions);
  static const aboutus = MenuItem('About Us', Icons.info);

  static const all = <MenuItem>[
    home,
    profile,
    orders,
    aboutus,
  ];
}
