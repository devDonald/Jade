import 'package:flutter/material.dart';

class FlatSecondaryButton extends StatelessWidget {
  const FlatSecondaryButton({
    Key key,
    this.title,
    this.color,
    this.onTap,
  }) : super(key: key);
  final String title;
  final Color color;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        (title != null) ? title : '',
        style: TextStyle(
          color: (color != null) ? color : Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }
}
