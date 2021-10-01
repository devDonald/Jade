import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medcare/src/screens/users_home.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../Widget/bezierContainer.dart';
import '../Widget/flat_secondary_button.dart';
import '../helpers/auth_service.dart';
import 'forgot_password.dart';

class LoginDoctor extends StatefulWidget {
  LoginDoctor({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginDoctorState createState() => _LoginDoctorState();
}

class _LoginDoctorState extends State<LoginDoctor> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();
  ProgressDialog _pr;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'J',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ADE',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Care',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () async {
        var state = AuthService();
        if (_email.text != '' && _password.text != '') {
          _pr.show();
          await state.signIn(_email.text, _password.text).then((status) async {
            _pr.hide();
            await doctorRef.doc(status.uid).get().then((value) async {
              if (value.exists) {
                Fluttertoast.showToast(
                    msg: "Doctor Login Successful",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home2', (r) => false);
              } else {
                await state.signOutUser().then((value) {
                  Fluttertoast.showToast(
                      msg: "Sorry you are not a doctor",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.of(context).pop();
                });
              }
            });
          });
        } else {
          Fluttertoast.showToast(
              msg: "Provide valid email and password",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Doctor Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AuthTextFeildLabel(
                label: 'Email Address',
              ),
              AuthTextField1(
                width: double.infinity,
                formField: TextFormField(
                  controller: _email,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val.trim().isEmpty
                      ? 'Enter Email Address'
                      : !val.trim().contains('@') || !val.trim().contains('.')
                          ? 'enter a valid email address'
                          : null,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FlatSecondaryButton(
            title: 'Forgot Password?',
            color: Colors.red,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ForgotPassword(),
                ),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AuthTextFeildLabel(
                label: 'Password',
              ),
              AuthTextField1(
                width: double.infinity,
                formField: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (val) => val.length < 8
                      ? 'Enter Password 8 or more characters'
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => _password.text = val);
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _pr = new ProgressDialog(context);
    _pr.style(message: 'Please wait, Authenticating Doctor');
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
