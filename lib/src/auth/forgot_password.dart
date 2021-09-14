import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medcare/src/auth/password_reset.dart';
import 'package:medcare/src/helpers/auth_service.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ForgotPassword extends StatefulWidget {
  static const String id = 'ForgotPassword';
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String error = '';
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait, Resetting Password');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Reset Password",
        ),
        centerTitle: false,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 39.8,
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        AbasuText(
                          fontSize: 35.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 82.5,
                  ),
                  AuthTextFeildLabel(
                    label: 'Email',
                  ),
                  SizedBox(
                    height: 4.6,
                  ),
                  AuthTextField1(
                    formField: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 10,
                          bottom: 5,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Enter Email Address' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  PrimaryButton(
                      color: Colors.orange,
                      buttonTitle: 'Reset Password',
                      blurRadius: 7.0,
                      roundedEdge: 2.5,
                      height: 50,
                      onTap: () {
                        setState(() async {
                          if (_formKey.currentState.validate()) {
                            setState(() => pr.show());
                            try {
                              await _authService.resetPassword(email);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ResetPassword(email: email),
                                  ));
                            } catch (e) {
                              error = e.toString();
                            }
                          }
                        });
                      }),
                  SizedBox(
                    height: 23.5,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AbasuText extends StatelessWidget {
  const AbasuText({
    Key key,
    this.fontSize,
  }) : super(key: key);
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'M',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10),
            ),
            children: [
              TextSpan(
                text: 'ed',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 'Care',
                style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
              ),
            ]),
      ),
    );
  }
}

class ScreenTitleIndicator extends StatelessWidget {
  const ScreenTitleIndicator({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 8.4),
        Container(
          margin: EdgeInsets.only(
            left: 98.0,
            right: 98.2,
          ),
          height: 2.0,
          // width: 164,
          color: Colors.green,
        ),
        // Divider(
        //   height: 4.0,
        //   color: kButtonsOrange,
        // ),
      ],
    );
  }
}

class AuthTextFeildLabel extends StatelessWidget {
  const AuthTextFeildLabel({
    Key key,
    this.label,
    this.controller,
    this.onChanged,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      child: RichText(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '*',
              style: TextStyle(
                color: Colors.green,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthTextField1 extends StatelessWidget {
  const AuthTextField1({
    this.width,
    this.formField,
    Key key,
  }) : super(key: key);
  final double width;
  final TextFormField formField;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.5),
        boxShadow: [
          BoxShadow(
            blurRadius: 7.5,
            offset: Offset(0.0, 2.5),
            color: Colors.black12,
          )
        ],
      ),
      width: width,
      // width: double.infinity,
      height: 65.0,
      child: formField,
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final Color color;
  final String buttonTitle;
  final double blurRadius;
  final double roundedEdge;
  final double width;
  final double height;
  final void Function() onTap;
  final bool busy;
  final bool enabled;

  const PrimaryButton({
    Key key,
    this.buttonTitle,
    this.blurRadius,
    this.roundedEdge,
    this.color,
    this.onTap,
    this.busy = false,
    this.enabled = false,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: InkWell(
        child: Container(
          width: widget.width,
          height: widget.height,
          // height: widget.busy ? 40 : 45.0,
          // width: widget.busy ? 40 : double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.30),
                blurRadius: widget.blurRadius,
              ),
            ],
            borderRadius: BorderRadius.circular(widget.roundedEdge),
            color: widget.color,
          ),
          child: Center(
            child: !widget.busy
                ? Text(
                    widget.buttonTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ),
        ),
      ),
    );
  }
}
