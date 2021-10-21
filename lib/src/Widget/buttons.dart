import 'package:flutter/material.dart';

class ButtonWithIcon1 extends StatelessWidget {
  const ButtonWithIcon1({
    Key key,
    this.onTap,
  }) : super(key: key);
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 149.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(
            5.0,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 7.5,
              offset: Offset(
                0.0,
                2.5,
              ),
              color: Colors.black54,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              color: Colors.white,
              size: 15.0,
            ),
            SizedBox(width: 9.2),
            Text(
              'Chat with Jade',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonWithIcon2 extends StatelessWidget {
  const ButtonWithIcon2({
    Key key,
    this.onTap,
  }) : super(key: key);
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 149.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(
            5.0,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 7.5,
              offset: Offset(
                0.0,
                2.5,
              ),
              color: Colors.black54,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat,
              color: Colors.white,
              size: 15.0,
            ),
            SizedBox(width: 9.2),
            Text(
              'Appointment Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
