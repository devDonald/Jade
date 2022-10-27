import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medcare/src/doctor/groupchat_tab/groupchat_tab_contents/chats/profile_picture.dart';
import 'package:medcare/src/helpers/firebase_api.dart';
import 'package:medcare/src/screens/users_home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class DoctorChatScreen extends StatefulWidget {
  DoctorChatScreen({
    this.personName,
    this.toUid,
    this.photo,
    this.fromUid,
  });
  final String personName, toUid, fromUid, photo;

  @override
  _DoctorChatScreenState createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  FocusNode focusNode;
  bool isTyping = false;
  final _controller = TextEditingController();
  String message = '';
  String _currentUserName, _currentUserId, _currentUserImage;

  void fetchDetails() async {
    User _currentUser = await FirebaseAuth.instance.currentUser;
    String authid = _currentUser.uid;
    doctorRef.doc(authid).get().then((ds) {
      if (ds.exists) {
        setState(() {
          _currentUserName = ds.data()['name'];
          _currentUserId = ds.data()['doctorId'];
          _currentUserImage = ds.data()['photo'];
        });
      }
    });
  }

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    try {
      await FirebaseApi.uploadMessageFromDoctor(
          _currentUserImage,
          widget.personName,
          message,
          widget.toUid,
          _currentUserId,
          _currentUserName);
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('error'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }

    _controller.clear();
  }

  @override
  void initState() {
    fetchDetails();
    super.initState();
  }

  getTextKeyBoard() {
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  ProgressDialog pr;
  String _commentId;
  ScrollController _scrollController = ScrollController();

  Future<void> sendChat() async {}

  Widget buildInput() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      margin: EdgeInsets.only(
        left: 16.5,
        right: 16.5,
        bottom: 15.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 7.5,
            offset: Offset(0.0, 2.5),
            color: Colors.black26,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          // Button send image
          Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextFormField(
                onTap: getTextKeyBoard,
                onChanged: (change) {
                  if (change != '') {
                    setState(() {
                      isTyping = true;
                      message = change;
                    });
                  } else {
                    setState(() {
                      isTyping = false;
                    });
                  }
                },
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                autofocus: false,
                enableSuggestions: true,
                focusNode: focusNode,
                controller: _controller,
                style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Color(0xff8e8e8e)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
          ),

          isTyping
              ? GestureDetector(
                  onTap: () {
                    //send message
                    if (_controller.text != '') {
                      sendMessage();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    margin: EdgeInsets.only(right: 10, left: 5),
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.send,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait, sending chat');

    void choiceAction(String choice) {
      if (choice == GroupChatMenu.exitGroup) {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        titleSpacing: -10,
        title: Row(
          children: <Widget>[
            ProfilePicture(
              image: CachedNetworkImageProvider(widget.photo),
              width: 25.0,
              height: 25.0,
            ),
            SizedBox(width: 5.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.personName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            tooltip: 'options',
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return GroupChatMenu.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            // SvgPicture.asset(
            //   'images/bckg.svg',
            //   fit: BoxFit.fill,
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: StreamBuilder(
                      stream: doctorRef
                          .doc(widget.fromUid)
                          .collection('chats')
                          .doc(widget.toUid)
                          .collection('chat')
                          .orderBy('timestamp', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const Text("Loading...");

                        return StickyGroupedListView<dynamic, String>(
                          floatingHeader: true,
                          scrollDirection: Axis.vertical,
                          stickyHeaderBackgroundColor: Colors.orange,
                          physics: BouncingScrollPhysics(),
                          elements: snapshot.data.docs,
                          groupBy: (element) => element['date'],
                          itemScrollController: GroupedItemScrollController(),
                          order: StickyGroupedListOrder.DESC,
                          reverse: true,
                          groupSeparatorBuilder: (dynamic element) => Container(
                            height: 50,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.orange[300],
                                  border: Border.all(
                                    color: Colors.orange[300],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    element['date'],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          itemBuilder: (c, element) {
                            bool isOwner = false;

                            if (_currentUserId == element['senderId']) {
                              isOwner = true;
                              print('senderId: $isOwner');
                            } else {
                              isOwner = false;
                            }

                            return isOwner
                                ? RecieverChatBox(
                                    chatId: element['messageId'],
                                    schoolId: widget.toUid,
                                    receiverId: widget.toUid,
                                    messageContent: element['messageContent'],
                                    timeOfMessage: element['time'],
                                    recieverName: element['userName'],
                                    recieverPhoto: element['photo'],
                                  )
                                : SenderChatBox(
                                    messageContent: element['messageContent'],
                                    senderName: element['userName'],
                                    senderPhoto: element['photo'],
                                    timeOfMessage: element['time'],
                                  );
                          },
                        );
                      }),
                ),
                //TextPart
                Container(
                  child: Column(
                    children: [
                      buildInput(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextFeildButton extends StatelessWidget {
  const TextFeildButton({
    Key key,
    this.icon,
    this.onTap,
  }) : super(key: key);
  final IconData icon;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: Icon(
          icon,
          size: 19,
          color: Color(0xff8e8e8e),
        ),
      ),
    );
  }
}

class RecieverChatBox extends StatelessWidget {
  const RecieverChatBox({
    Key key,
    this.recieverName,
    this.recieverPhoto,
    this.timeOfMessage,
    this.messageContent,
    this.chatId,
    this.uid,
    this.receiverId,
    this.schoolId,
  }) : super(key: key);
  final String recieverName,
      recieverPhoto,
      timeOfMessage,
      messageContent,
      chatId,
      schoolId,
      uid,
      receiverId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 70.5,
        right: 13.9,
        bottom: 10.5,
      ),
      padding: EdgeInsets.only(
        right: 11.5,
        left: 19.6,
        top: 5.5,
        bottom: 5.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white, //for now
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(0.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$timeOfMessage',
                    style: TextStyle(
                      fontSize: 9.0,
                      color: Colors.grey,
                    ),
                  ),
                  // PopupMenuButton(
                  //
                  //   itemBuilder: (context) {
                  //     var list = List<PopupMenuEntry<Object>>();
                  //     list.add(
                  //       PopupMenuItem(
                  //         child: Row(
                  //           children: [
                  //             Icon(
                  //               Icons.delete,
                  //               size: 17,
                  //               color: Colors.grey,
                  //             ),
                  //             SizedBox(width: 8),
                  //             GestureDetector(
                  //               onTap: () async {
                  //                 // usersRef
                  //                 //     .document(uid)
                  //                 //     .collection('groups')
                  //                 //     .document(groupId)
                  //                 //     .collection('chats')
                  //                 //     .document(chatId).delete().whenComplete(() =>
                  //                 //     Navigator.of(context).pop()
                  //                 // );
                  //
                  //
                  //               },
                  //               child: Text(
                  //                 "Delete",
                  //                 style: TextStyle(
                  //                   color: Colors.grey,
                  //                   fontSize: 17,
                  //                 ),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         value: 2,
                  //       ),
                  //     );
                  //     return list;
                  //   },
                  //   icon: Icon(
                  //     Icons.more_horiz,
                  //     size: 20,
                  //     color: kGreyColor,
                  //   ),
                  //   onSelected: (val) {
                  //     if (val) {
                  //       print('Delete');
                  //       showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) {
                  //
                  //           return DeleteDialog();
                  //         },
                  //       );
                  //     }
                  //   },
                  // ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            '$messageContent',
            style: TextStyle(fontSize: 13.0),
          ),
        ],
      ),
    );
  }
}

class SenderChatBox extends StatelessWidget {
  SenderChatBox({
    Key key,
    this.senderName,
    this.senderPhoto,
    this.messageContent,
    this.timeOfMessage,
  }) : super(key: key);
  final String senderName, senderPhoto, timeOfMessage, messageContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 70.5,
        left: 13.9,
        top: 10.0,
        bottom: 10.5,
      ),
      padding: EdgeInsets.only(
        right: 11.5,
        left: 19.6,
        top: 5.5,
        bottom: 5.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white, //for now
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ProfilePicture(
                    image: CachedNetworkImageProvider(
                      '$senderPhoto',
                    ),
                    width: 30.0,
                    height: 29.5,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '$senderName',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$timeOfMessage',
                    style: TextStyle(
                      fontSize: 9.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            '$messageContent',
            style: TextStyle(fontSize: 13.0),
          ),
        ],
      ),
    );
  }
}

class GroupChatMenu {
  static const String exitGroup = 'Exit Group';
  static const List<String> choices = <String>[exitGroup];
}
