import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medcare/src/doctor/chat_screen.dart';
import 'package:medcare/src/screens/users_home.dart';

import 'chats/screen_loading.dart';
import 'doctor_home.dart';

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
    _stream = doctorRef.doc('${widget.doctorId}')
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ScreenLoading();
        } else if (!snapshot.hasData) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You currently do not have any appointment chats available',
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
                stream: chatRef
                    .doc('${widget.doctorId}')
                    .collection('chats')
                    .where('groupId', isEqualTo: snap['groupId'])
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
                    chatCount: unreadCount,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatId: snap['groupId'],
                              username: snap['groupName'],
                              userId: '',
                              receiverId: snap['groupIcon'],
                              receiverName: snap['adminId'],
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
    );
  }
}

class DisplayGroups extends StatelessWidget {
  final String username, lastChat, time;
  final int chatCount;
  final Function onTap;

  const DisplayGroups(
      {Key key,
      this.username,
      this.lastChat,
      this.time,
      this.chatCount = 0,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (screenSize.width - 20) / 2,
        height: 85.0,
        margin: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        padding: EdgeInsets.all(
          12.2,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.1,
              ),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
            SizedBox(
              width: 3,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Expanded(
                      child: Text(
                    lastChat ?? "",
                    style: TextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    time ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  chatCount > 0
                      ? CircleAvatar(
                          radius: 11,
                          backgroundColor: Colors.orange,
                          child: Center(
                            child: Text(
                              "$chatCount" ?? "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
