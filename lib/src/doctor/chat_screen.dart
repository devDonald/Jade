import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medcare/src/doctor/doctor_home.dart';

import 'chats/message.dart';
import 'chats/messages_widget.dart';
import 'chats/new_message_widget.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.username, this.chatId, this.userId, this.receiverId, this.receiverName});
  final String username, chatId, userId, receiverId, receiverName;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FocusNode textFeildFocus = FocusNode();
  TextEditingController textController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final focusNode = FocusNode();
  Message replyMessage;

  void updateNotificationCount() async {
    await chatFeedRef
        .doc("${widget.userId}")
        .collection('chats')
        .where('seen', isEqualTo: false)
        .get()
        .then((value) {
      value.docs.forEach((document) async {
        document.reference.update(<String, dynamic>{
          'seen': true,
        });
      });
    });
  }

  @override
  void initState() {
    textFeildFocus.requestFocus();
    updateNotificationCount();
    super.initState();
  }

  void replyToMessage(Message message) {
    setState(() {
      replyMessage = message;
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: -8,
        title: Row(
          children: <Widget>[
            SizedBox(width: 5.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.username ?? 'User',
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

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: MessagesWidget(
                  groupId: widget.chatId,
                  onSwipedMessage: (message) {
                    replyToMessage(message);
                    focusNode.requestFocus();
                  },
                ),
              ),
            ),
            // NewMessageWidget(
            //   username: widget.username,
            //   focusNode: focusNode,
            //   chatId: widget.chatId,
            //   onCancelReply: cancelReply,
            //   replyMessage: replyMessage,
            // )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textFeildFocus.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<void> choiceAction(String choice) async {
    if (choice == GroupChatMenu.exitGroup) {
        Navigator.of(context).pop();
      }
    }
}

class GroupChatMenu {
  //static const String report = 'Delete Group';
  static const String exitGroup = 'Exit Group';
  //static const String clearChat = 'Clear Chat';
  //TODO delete/add user

  static const List<String> choices = <String>[exitGroup];
}
