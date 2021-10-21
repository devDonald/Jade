import 'package:flutter/material.dart';

class ScreenLoading extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  const ScreenLoading(
      {Key key, this.mainAxisAlignment, this.crossAxisAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: (mainAxisAlignment != null)
          ? mainAxisAlignment
          : MainAxisAlignment.end,
      crossAxisAlignment: (crossAxisAlignment != null)
          ? crossAxisAlignment
          : CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          strokeWidth: 5,
          backgroundColor: Colors.orange,
        ),
        SizedBox(height: 10),
        Text(
          'Loading Please Wait',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
