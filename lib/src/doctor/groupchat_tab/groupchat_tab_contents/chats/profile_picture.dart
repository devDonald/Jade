import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key key,
    this.image,
    this.width,
    this.height,
    this.border,
  }) : super(key: key);
  final ImageProvider image;
  final double width;
  final double height;
  final Border border;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
        shape: BoxShape.circle,
        border: border,
      ),
    );
  }
}
