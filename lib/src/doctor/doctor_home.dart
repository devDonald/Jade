import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medcare/src/helpers/auth_service.dart';

final root = FirebaseFirestore.instance;
final usersRef = root.collection('users');
final doctorRef = root.collection('doctors');
final chatFeedRef = root.collection('chatRef');
final chatRef = root.collection('chats');

final timestamp = DateTime.now().toUtc();

class DoctorHome extends StatefulWidget {
  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  String _uid, _name;
  void checkInGroup() async {
    // final prefs = await SharedPreferences.getInstance();
    //  = prefs.getString('uid');
    print('uid $_uid');
    try {
      User _currentUser = FirebaseAuth.instance.currentUser;
      String authid = _currentUser.uid;

      root.collection('doctors').doc(authid).get().then((ds) {
        if (ds.exists) {
          if (mounted) {
            setState(() {
              _uid = ds.data()['doctorId'];
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

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.orange,
        title: Text('Doctor Home',
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
            Row(
              children: [
                HomeCard(
                  icon: Icons.person,
                  title: 'My Profile',
                  onTap: () {
                    Navigator.of(context).pushNamed('/doctorProfile');
                  },
                ),
                HomeCard(
                  icon: Icons.message,
                  title: 'Chat Appointments',
                  onTap: () {
                    Navigator.of(context).pushNamed('/appointments');
                  },
                ),
                HomeCard(
                  icon: Icons.exit_to_app,
                  title: 'Logout',
                  onTap: () {
                    authBloc.signOutUser().then((value) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login2', (r) => false);
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
