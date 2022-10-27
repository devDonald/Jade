import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medcare/src/Widget/user_search_tile.dart';
import 'package:medcare/src/doctor/doctor_model.dart';
import 'package:medcare/src/doctor/groupchat_tab/groupchat_tab_contents/chat_screen.dart';
import 'package:medcare/src/screens/users_home.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class AppointmentDoctors extends StatefulWidget {
  const AppointmentDoctors({
    Key key,
  }) : super(key: key);

  @override
  _AppointmentDoctorsState createState() => _AppointmentDoctorsState();
}

class _AppointmentDoctorsState extends State<AppointmentDoctors> {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  String filter = '';
  String _currentUserName, _currentUserId, _currentUserImage;

  void fetchDetails() async {
    User _currentUser = await FirebaseAuth.instance.currentUser;
    String authid = _currentUser.uid;
    usersRef.doc(authid).get().then((ds) {
      if (ds.exists) {
        setState(() {
          _currentUserName = ds.data()['name'];
          _currentUserId = ds.data()['userId'];
          _currentUserImage = ds.data()['photo'];
        });
      }
    });
  }

  @override
  initState() {
    fetchDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.orange,
        title: Text('Doctors for Appointment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: 10.0,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2.5),
            ),
          ],
        ),
        child: RefreshIndicator(
          child: PaginateFirestore(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemsPerPage: 10,
            itemBuilder: (index, context, snapshot) {
              DoctorModel _users = DoctorModel.fromSnapshot(snapshot);
              if (!_users.isBusy) {
                return UserSearchTile(
                  isBusy: _users.isBusy,
                  userName: "${_users.title} ${_users.name}",
                  address: _users.address,
                  state: "${_users.state} State",
                  profileImage: _users.photo,
                  onTap: () {},
                  onChat: () async {
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    final String formatted = formatter.format(now);
                    await doctorRef
                        .doc(_users.doctorId)
                        .collection('chats')
                        .doc(_currentUserId)
                        .update({
                      'username': _currentUserName,
                      'userId': _currentUserId,
                      'photo': _currentUserImage,
                      'latestChat': 'new appointment',
                      'timestamp': timestamp,
                      'date': formatted,
                      'time':
                          "${new DateFormat.jm().format(new DateTime.now())}",
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          personName: "${_users.title} ${_users.name}",
                          photo: _users.photo,
                          toUid: _users.doctorId,
                          fromUid: _currentUserId,
                        ),
                        //follow user if not owner
                      ),
                    );
                  },
                );
              } else {
                return new Container();
              }
            },
            // orderBy is compulsary to enable pagination
            query: doctorRef.orderBy('name', descending: false),
            isLive: true,
            listeners: [
              refreshChangeListener,
            ],
            itemBuilderType: PaginateBuilderType.listView,
          ),
          onRefresh: () async {
            refreshChangeListener.refreshed = true;
          },
        ),
      ),
    );
  }
}
