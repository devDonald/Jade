import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medcare/src/doctor/groupchat_tab/groupchat_tab_contents/chats/doctor_chat_screen.dart';
import 'package:medcare/src/screens/users_home.dart';

import 'groupchat_tab/groupchat_tab_contents/chats/display_groups_list.dart';

class ChatList extends StatefulWidget {
  final String doctorId;
  const ChatList({
    Key key,
    this.doctorId,
  }) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Stream _stream;

  @override
  void initState() {
    _stream = doctorRef
        .doc(widget.doctorId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.orange,
        title: Text('Doctor\'s Appointment Chat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: 10.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You currently do not have any Appointment Chat request',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15.0),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot snap = snapshot.data.docs[index];

                return StreamBuilder(
                  stream: feedRef
                      .doc(widget.doctorId)
                      .collection('chats')
                      .where('userId', isEqualTo: snap['userId'])
                      .where('seen', isEqualTo: false)
                      .snapshots(),
                  builder: (context, sna) {
                    int unreadCount = 0;

                    print('im through second stream');
                    print('nope');
                    QuerySnapshot querySnap = sna.data;
                    if (sna.hasData) {
                      unreadCount = querySnap.docs.length;
                    }

                    return DisplayGroups(
                      username: snap['username'],
                      lastChat: snap['latestChat'] ?? '',
                      time: snap['time'] ?? '',
                      photo: snap['photo'],
                      chatCount: unreadCount,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorChatScreen(
                                toUid: snap['userId'],
                                fromUid: widget.doctorId,
                                personName: snap['username'],
                                photo: snap['photo'],
                              ),
                            ));
                      },
                    );
                  },
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
