import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/favorite/favorite_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/search/search_screen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  final pages = [
    const HomeScreen(),
    FavoriteScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.home,
              color: kPrimaryColor,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
              color: inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.favorite,
              color: kPrimaryColor,
            ),
            label: "Fav",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_outlined,
              color: inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: inActiveIconColor,
            ),
            activeIcon: Icon(
              Icons.person,
              color: kPrimaryColor,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
