import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/auth/protected_screen.dart';
import 'package:shop_app/screens/checkout/checkout_screen.dart';
import 'package:shop_app/screens/checkout/order_success_screen.dart';
import 'package:shop_app/screens/products/products_screen.dart';
import 'package:shop_app/screens/profile/profile_orders_screen.dart';
import 'package:shop_app/screens/seller/init_seller_screen.dart';
import 'package:shop_app/screens/seller/seller_add_product_screen.dart';
import 'package:shop_app/screens/seller/seller_update_product_screen.dart';

import 'screens/cart/cart_screen.dart';
import 'screens/complete_profile/complete_profile_screen.dart';
import 'screens/details/details_screen.dart';
import 'screens/forgot_password/forgot_password_screen.dart';
// import 'screens/home/home_screen.dart';
import 'screens/init_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/otp/otp_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  InitScreen.routeName: (context) => const InitScreen(),
  InitSellerScreen.routeName: (context) => InitSellerScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  // HomeScreen.routeName: (context) => const HomeScreen(),
  ProtectedScreen.routeName: (context) => ProtectedScreen(),
  ProductsScreen.routeName: (context) => ProductsScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  CheckoutScreen.routeName: (context) => CheckoutScreen(),
  OrderSuccessScreen.routeName: (context) => OrderSuccessScreen(),
  ProfileOrdersScreen.routeName: (context) => ProfileOrdersScreen(),
  SellerAddProductScreen.routeName: (context) => SellerAddProductScreen(),
  // SellerUpdateProductScreen.routeName: (context) => const SellerUpdateProductScreen(),
};
