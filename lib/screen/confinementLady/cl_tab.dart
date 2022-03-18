// import 'package:flutter/material.dart';

// import 'cl_home.dart';
// import 'cl_profile.dart';

// class CLTab extends StatefulWidget {

//   const CLTab({Key key}) : super(key: key);

//   @override
//   _CLTabState createState() => _CLTabState();
// }

// class _CLTabState extends State<CLTab> {
//   List<Map<String, Object>> _pages;

//   @override
//   void initState() {
//     _pages = [
//       {
//         'page': CLHome(),
//       },
//       {
//         'page': CLProfile(),
//       },
//     ];

//     super.initState();
//   }

//   int _selectedPageIndex = 0;

//   void _selectPage(int index) {
//     setState(() {
//       _selectedPageIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       body: _pages[_selectedPageIndex]['page'],
//       bottomNavigationBar: BottomNavigationBar(
//           onTap: _selectPage,
//           backgroundColor: Theme.of(context).primaryColor,
//           unselectedItemColor: Colors.white,
//           selectedItemColor: Colors.white,
//           currentIndex: _selectedPageIndex,
//           type: BottomNavigationBarType.shifting,
//           items: [
//             BottomNavigationBarItem(
//               backgroundColor: Theme.of(context).primaryColor,
//               icon: const Icon(Icons.home),
//               label:'Home',
//             ),
//             BottomNavigationBarItem(
//               backgroundColor: Theme.of(context).primaryColor,
//               icon: const Icon(Icons.account_circle),
//               label: 'Profile',
//             ),
//           ]),
//     );
//   }
// }
