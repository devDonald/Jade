import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Contact extends StatelessWidget {
  const Contact({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.orange,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Contact Developer',
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
              "Developer's Name: ",
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            Text(
              "Mrs JONGPLAPSON LYDIA ADAEZE",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.orange,
              thickness: 2,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Developer's Email: ",
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            Text(
              "medcarebotservices@gmail.com",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.orange,
              thickness: 2,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Personal Website:",
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            Text(
              "https://www.jademedcare.com.ng",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.orange,
              thickness: 2,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Contact Number",
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            Text(
              "+2347035320847",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.orange,
              thickness: 2,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Location",
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            Text(
              "Internet",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.orange,
              thickness: 2,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Address",
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            Text(
              "Internet",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.orange,
              thickness: 2,
            ),
            SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }
}
