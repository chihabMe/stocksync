import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/services/user_servies.dart';

class ProtectedScreen extends StatefulWidget {
  static String routeName = "/protected";

  @override
  _ProtectedScreenState createState() => _ProtectedScreenState();
}

class _ProtectedScreenState extends State<ProtectedScreen> {
  final UserServices _userServices = UserServices();
  bool _isLoading = true;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    try {
      var user = await _userServices.getUser();
      if (!_isNavigating) {
        setState(() {
          _isLoading = false;
        });
        if (user == null) {
          _navigateToSignInScreen();
        } else {
          _navigateToHomeScreen();
        }
      }
    } catch (error) {
      print("Error occurred while fetching user data: $error");
      // Handle error - Navigate to sign-in screen
      _navigateToSignInScreen();
    }
  }

  void _navigateToSignInScreen() {
    _isNavigating = true;
    Navigator.pushReplacementNamed(context, SignInScreen.routeName);
  }

  void _navigateToHomeScreen() {
    _isNavigating = true;
    Navigator.pushReplacementNamed(context, InitScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading ? CircularProgressIndicator() : Container(),
      ),
    );
  }
}
