import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medcare/src/Widget/buttons.dart';
import 'package:medcare/src/helpers/auth_service.dart';
import 'package:medcare/src/screens/jade_chat.dart';

final root = FirebaseFirestore.instance;
final usersRef = root.collection('users');
final doctorRef = root.collection('doctors');
final chatFeedRef = root.collection('chatRef');
final chatRef = root.collection('chats');

final timestamp = DateTime.now().toUtc();

class UsersHome extends StatefulWidget {
  @override
  _UsersHomeState createState() => _UsersHomeState();
}

class _UsersHomeState extends State<UsersHome> {
  String _uid, _name;
  void checkInGroup() async {
    // final prefs = await SharedPreferences.getInstance();
    //  = prefs.getString('uid');
    print('uid $_uid');
    try {
      User _currentUser = FirebaseAuth.instance.currentUser;
      String authid = _currentUser.uid;

      root.collection('users').doc(authid).get().then((ds) {
        if (ds.exists) {
          if (mounted) {
            setState(() {
              _uid = ds.data()['userId'];
              _name = ds.data()['name'];
            });
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    checkInGroup();
  }

  Widget buildIsNotInYearBook() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Welcome, ',
                style: GoogleFonts.portLligatSans(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 20,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '$_name',
                    style: TextStyle(color: Colors.orange, fontSize: 30),
                  ),
                ]),
          ),
          SizedBox(height: 20.5),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'I am  ',
                style: GoogleFonts.portLligatSans(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 20,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'JA',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  TextSpan(
                    text: 'DE',
                    style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
                  ),
                ]),
          ),
          Container(
            child: Text(
              'Your online medical assistance \n you can feel feel to chat with me \n if you need any assistance',
              style: TextStyle(fontSize: 17.0),
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
          ),
          SizedBox(height: 15.0),

          ///
          ButtonWithIcon1(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JadeChat(),
                ),
              );
            },
          ),

          ///

          SizedBox(height: 20.5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.orange,
        title: Text('User Home',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: 10.0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildIsNotInYearBook(),
            Row(
              children: [
                HomeCard(
                  icon: Icons.info,
                  title: 'About Us',
                  onTap: () {
                    Navigator.of(context).pushNamed('/addMeter');
                  },
                ),
                HomeCard(
                  icon: Icons.contact_mail,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.of(context).pushNamed('/dtAreas');
                  },
                ),
                HomeCard(
                  icon: Icons.medical_services,
                  title: 'Services',
                  onTap: () {
                    Navigator.of(context).pushNamed('/search');
                  },
                ),
              ],
            ),
            Row(
              children: [
                HomeCard(
                  icon: Icons.person,
                  title: 'My Profile',
                  onTap: () {
                    Navigator.of(context).pushNamed('/searchLatLong');
                  },
                ),
                HomeCard(
                  icon: Icons.history,
                  title: 'Chat History',
                  onTap: () {
                    Navigator.of(context).pushNamed('/history');
                  },
                ),
                HomeCard(
                  icon: Icons.exit_to_app,
                  title: 'Logout',
                  onTap: () {
                    authBloc.signOutUser().then((value) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login1', (r) => false);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    Key key,
    this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);
  final IconData icon;
  final Function onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.285,
            height: MediaQuery.of(context).size.height * 0.15,
            margin:
                EdgeInsets.only(top: 17.5, bottom: 5.0, left: 7.0, right: 7.0),
            //padding: EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 2.5),
                  blurRadius: 10.5,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.orange,
                      size: 35.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            '$title',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
