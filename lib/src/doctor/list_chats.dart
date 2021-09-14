import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medcare/src/screens/users_home.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool isInAnyGroup = true, isLoading = false;

  String _uid;

  void checkInGroup() async {
    if (mounted == true) {
      setState(() {
        isLoading = true;
      });
    }
    // final prefs = await SharedPreferences.getInstance();
    //  = prefs.getString('uid');
    try {
      User _currentUser = FirebaseAuth.instance.currentUser;
      String authid = _currentUser.uid;

      root.collection('users').doc(authid).get().then((ds) {
        if (ds.exists) {
          if (mounted) {
            setState(() {
              isInAnyGroup = ds.data()['inGroup'];
              _uid = ds.data()['userId'];
            });
          }
        }
      });
      if (mounted == true) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void seenChat() async {
    User _currentUser = await FirebaseAuth.instance.currentUser;
    String authid = _currentUser.uid;
    var snapshots = chatFeedRef.doc(authid).collection('feedItems').snapshots();
    try {
      await snapshots.forEach((snapshot) async {
        List<DocumentSnapshot> documents = snapshot.docs;

        for (var document in documents) {
          await document.reference.update(<String, dynamic>{
            'seen': true,
          });
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
    seenChat();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (!isInAnyGroup) {
        return buildNoGroupChatContent();
      } else {
        return buildGroupChatContent();
      }
    }
  }

  Widget buildNoGroupChatContent() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Hello Doctor, You have no chat appointments yet, we would notify you when you hava anyone',
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
  }

  Widget buildGroupChatContent() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: usersRef
              .doc(_uid)
              .collection('groups')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("No Groups Yet..."),
              );
            }
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot snap = snapshot.data.docs[index];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading..."),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text("loading..."),
                    );
                  }
                  // return DisplayGroups(
                  //   groupName: snap['groupName'],
                  //   lastChat: snap['latestChat'] ?? '',
                  //   time: snap['time'] ?? '',
                  //   chatCount: 0,
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => GroupChat(
                  //             groupId: snap['groupId'],
                  //             groupName: snap['groupName'],
                  //           ),
                  //         ));
                  //   },
                  // );
                  return StreamBuilder(
                    stream: doctorRef
                        .doc(_uid)
                        .collection('groups')
                        .doc(snap['groupId'])
                        .collection('chats')
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

                      print('unread $unreadCount');
                      return DisplayGroups(
                        groupName: snap['groupName'],
                        lastChat: snap['latestChat'] ?? '',
                        time: snap['time'] ?? '',
                        timestamp: snap['timestamp'],
                        chatCount: unreadCount,
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => ChatPage(
                          //         groupId: snap['groupId'],
                          //         groupName: snap['groupName'],
                          //       ),
                          //     ));
                        },
                      );
                    },
                  );
                });
          }),
    );
  }
}

class DisplayGroups extends StatelessWidget {
  final String groupName, lastChat, time;
  final int chatCount;
  final Function onTap;
  final dynamic timestamp;

  const DisplayGroups(
      {Key key,
      this.groupName,
      this.lastChat,
      this.time,
      this.chatCount,
      this.onTap,
      this.timestamp})
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
              child: Image.asset(
                'images/gla.png',
                height: 85.0,
                width: 50.0,
              ),
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
                    groupName,
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
                    lastChat,
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
                    time,
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
                              "$chatCount",
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
