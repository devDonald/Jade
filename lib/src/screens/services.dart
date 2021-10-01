import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medcare/src/helpers/utils.dart';

class Services extends StatelessWidget {
  const Services({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.orange,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Services',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )),
        ),
        titleSpacing: -5.0,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10.5,
          bottom: 10.0,
        ),
        padding: EdgeInsets.only(
          left: 10.5,
          right: 23.5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: Colors.black26, offset: Offset(0.0, 2.5)),
          ],
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Text(
              "Our Services",
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            Divider(
              color: Colors.orange,
              thickness: 2,
            ),
            SizedBox(
              height: 2.5,
            ),
            Container(
              width: double.infinity,
              child: Text(
                services,
                style: TextStyle(color: Colors.grey, fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 10.5,
            ),
            Text(
              "24 Hours Support",
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            Divider(
              color: Colors.orange,
              thickness: 2,
            ),
            SizedBox(
              height: 10.5,
            ),
            Container(
              width: double.infinity,
              child: Text(
                support,
                style: TextStyle(color: Colors.grey, fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 10.5,
            ),
          ],
        ),
      ),
    );
  }
}
