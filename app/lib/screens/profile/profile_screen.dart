import 'package:flutter/material.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/screens/profile/profile_orders_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/services/auth_servies.dart';
import 'package:shop_app/services/user_servies.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  AuthServices authServices = AuthServices();
  UserServices userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: FutureBuilder(
          future: userServices.getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No User found'));
            } else {
              String email = snapshot.data!.email;
              return Column(
                children: [
                  SizedBox(height: 35),
                  ProfilePic(user: snapshot.data!),
                  const SizedBox(height: 20),
                  ProfileMenu(
                    text: "$email",
                    icon: Icons.person,
                    press: () => {},
                  ),
                  ProfileMenu(
                    text: "Orders",
                    icon: Icons.receipt_long,
                    press: () {
                      Navigator.pushNamed(
                          context, ProfileOrdersScreen.routeName);
                    },
                  ),
                  ProfileMenu(
                    text: "Settings",
                    icon: Icons.settings,
                    press: () {},
                  ),
                  ProfileMenu(
                    text: "Logout",
                    icon: Icons.logout,
                    press: () async {
                      await authServices.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
