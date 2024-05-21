import 'package:flutter/material.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/sign_up/sign_up_screen.dart';
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
              return Center(child: Text('No User  found'));
            } else {
              String email = snapshot.data!.email;
              return Column(
                children: [
                  SizedBox(height: 35),
                  ProfilePic(user: snapshot.data!),
                  const SizedBox(height: 20),
                  ProfileMenu(
                    text: "$email ",
                    icon: "assets/icons/User Icon.svg",
                    press: () => {},
                  ),
                  ProfileMenu(
                    text: "Notifications",
                    icon: "assets/icons/Bell.svg",
                    press: () {},
                  ),
                  ProfileMenu(
                    text: "Settings",
                    icon: "assets/icons/Settings.svg",
                    press: () {},
                  ),
                  ProfileMenu(
                      text: "Logout",
                      icon: "assets/icons/Log out.svg",
                      press: () async {
                        await authServices.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      })
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
