import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/User.dart';

class ProfilePic extends StatelessWidget {
  final User user;

  ProfilePic({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a default placeholder if user.image is null or empty
    final String? imageUrl = user.image;
    final ImageProvider backgroundImage =
        (imageUrl != null && imageUrl.isNotEmpty)
            ? NetworkImage(imageUrl)
            : AssetImage('assets/images/avatar.png') as ImageProvider;

    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: backgroundImage,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
