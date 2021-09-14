import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medcare/src/helpers/auth_service.dart';
import 'package:medcare/src/helpers/user_model.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../Widget/bezierContainer.dart';
import 'user_login.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _confirmPassword = TextEditingController();

  final TextEditingController _fullName = TextEditingController();

  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _occupation = TextEditingController();

  final TextEditingController _address = TextEditingController();

  final TextEditingController _age = TextEditingController();
  final TextEditingController _gender = TextEditingController();
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

  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        if (_email.text != '' ||
            _password.text != '' ||
            _age.text != '' ||
            _address.text != '' ||
            _phoneNumber.text != '' ||
            _occupation.text != '' ||
            _confirmPassword.text != '') {
          _pr.show();
          var state = AuthService();

          UserModel user = UserModel(
            email: _email.text.toLowerCase(),
            name: _fullName.text,
            occupation: _occupation.text,
            age: _age.text,
            address: _address.text,
            gender: _gender.text,
            phone: _phoneNumber.text,
            isDoctor: false,
            photo: '',
          );
          state.createAccount(_email.text, _password.text, user).then((status) {
            _pr.hide();
            if (status != '') {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
            } else {
              //showErrorToast('Agent Registration failed, pls try again');
            }
          });
        } else {
          //showErrorToast('please complete all fields');
          Fluttertoast.showToast(
              msg: "Provide values for all fields",
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
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserLogin()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
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

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20.9,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AuthTextField(
                controller: _fullName,
                label: 'Full Name ',
                width: double.infinity,
                keyBoardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                validate: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AuthTextField(
                controller: _email,
                label: 'Email Address ',
                width: double.infinity,
                keyBoardType: TextInputType.emailAddress,
                validate: (val) => val.trim().isEmpty
                    ? 'Enter Email Address'
                    : !val.trim().contains('@') || !val.trim().contains('.')
                        ? 'enter a valid email address'
                        : null,
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AuthTextField(
                      controller: _password,
                      label: 'Password ',
                      width: MediaQuery.of(context).size.width / 2.3 + 1,
                      obsecureText: true,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'password must be 8 or more characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AuthTextField(
                      controller: _confirmPassword,
                      label: 'Retype Password',
                      width: MediaQuery.of(context).size.width / 2.3 + 1,
                      obsecureText: true,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Please confirm password';
                        } else if (value != _password.text) {
                          return 'password mismatch';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //Phone and Age
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AuthTextField(
                      controller: _phoneNumber,
                      label: 'Phone Number',
                      width: MediaQuery.of(context).size.width / 2.3 + 1,
                      keyBoardType: TextInputType.phone,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Phone No';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AuthTextField(
                      controller: _age,
                      label: 'Age',
                      width: MediaQuery.of(context).size.width / 2.3 + 1,
                      keyBoardType: TextInputType.number,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //occupation and gender
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AuthTextField(
                      controller: _occupation,
                      label: 'Occupation',
                      textCapitalization: TextCapitalization.words,
                      width: MediaQuery.of(context).size.width / 1.8,
                      keyBoardType: TextInputType.text,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Occupation';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AuthTextField(
                      controller: _gender,
                      textCapitalization: TextCapitalization.words,
                      label: 'Gender',
                      width: MediaQuery.of(context).size.width / 3.5,
                      keyBoardType: TextInputType.text,
                      validate: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your Gender';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //Address
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AuthTextField(
                controller: _address,
                label: 'Address',
                width: double.infinity,
                textCapitalization: TextCapitalization.sentences,
                keyBoardType: TextInputType.text,
                validate: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 25.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _pr = new ProgressDialog(context);
    _pr.style(message: 'Please wait, Registering User');
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: 15),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    this.width,
    Key key,
    this.label,
    this.controller,
    this.textCapitalization,
    this.keyBoardType,
    this.obsecureText,
    this.textInputAction,
    this.maxLength,
    this.validate,
  }) : super(key: key);
  final double width;
  final String label;
  final bool obsecureText;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final TextInputType keyBoardType;
  final TextInputAction textInputAction;
  final int maxLength;
  final Function validate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (label != null)
              ? RichText(
                  text: TextSpan(
                    text: (label != null) ? label : '',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: (label != null) ? '*' : '',
                        style: TextStyle(
                          color: Colors.orange,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(height: 0),
          (label != null) ? SizedBox(height: 10) : Container(height: 0),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.5),
              boxShadow: [
                BoxShadow(
                  blurRadius: 7.5,
                  offset: Offset(0.0, 2.5),
                  color: Colors.grey,
                )
              ],
            ),
            width: width,
            // width: double.infinity,
            // height: 40.0,
            child: TextFormField(
              style: TextStyle(fontSize: 20),
              validator: validate,
              controller: controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: (textInputAction != null)
                  ? textInputAction
                  : TextInputAction.done,
              obscureText: (obsecureText != null) ? obsecureText : false,
              keyboardType:
                  (keyBoardType != null) ? keyBoardType : TextInputType.name,
              textCapitalization: (textCapitalization != null)
                  ? textCapitalization
                  : TextCapitalization.none,
              maxLength: (maxLength != null) ? maxLength : null,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
