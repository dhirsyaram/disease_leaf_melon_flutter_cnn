// import 'package:flutter/material.dart';
// import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

// class BottomNavBar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onTap;

//   const BottomNavBar({
//     super.key,
//     required this.selectedIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return StylishBottomBar(
//       option: BubbleBarOptions(
//         iconSize: 28,
//         bubbleFillStyle: BubbleFillStyle.fill,
//         opacity: 0.4,
//         barStyle: BubbleBarStyle.horizontal,
//       ),
//       items: [
//         BottomBarItem(
//           icon: Icon(Icons.home_rounded),
//           selectedIcon: Icon(Icons.home_rounded),
//           title: Text("Beranda", style: TextStyle(fontSize: 16.0)),
//           backgroundColor: Color.fromRGBO(0, 90, 50, 1.0),
//           selectedColor: Color.fromRGBO(35, 139, 69, 1.0),
//         ),
//         BottomBarItem(
//           icon: Icon(Icons.history_rounded),
//           selectedIcon: Icon(Icons.history_rounded),
//           title: Text("Riwayat", style: TextStyle(fontSize: 16.0)),
//           backgroundColor: Color.fromRGBO(0, 90, 50, 1.0),
//           selectedColor: Color.fromRGBO(35, 139, 69, 1.0),
//         ),
//       ],
//       currentIndex: selectedIndex,
//       onTap: onTap,
//     );
//   }
// }
