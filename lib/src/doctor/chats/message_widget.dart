import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medcare/src/doctor/chats/reply_message_widget.dart';

import '../doctor_home.dart';
import 'attached_image_screen.dart';
import 'message.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({
    @required this.message,
    @required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final width = MediaQuery.of(context).size.width;

    return buildMessage();
  }

  Widget buildMessage() {
    final messageSender = SenderChatBox(
      timeOfMessage: message.time,
      messageContent: message.messageContent,
      isPhoto: message.isPhoto,
      chatId: message.messageId,
      groupId: message.groupId,
    );
    final messageReceiver = ReceiverChatBox(
      senderName: message.userName,
      senderPhoto: message.photo,
      isPhoto: message.isPhoto,
      timeOfMessage: message.time,
      senderId: message.senderId,
      messageContent: message.messageContent,
    );

    if (message.replyMessage == null) {
      return isMe ? messageSender : messageReceiver;
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          buildReplyMessage(),
          isMe ? messageSender : messageReceiver,
        ],
      );
    }
  }

  Widget buildReplyMessage() {
    final replyMessage = message.replyMessage;
    final isReplying = replyMessage != null;

    if (!isReplying) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        child: ReplyMessageWidget(
          message: replyMessage,
        ),
      );
    }
  }
}

class SenderChatBox extends StatelessWidget {
  const SenderChatBox({
    Key key,
    this.timeOfMessage,
    this.messageContent,
    this.isPhoto = false,
    this.onImageTap,
    this.chatId,
    this.groupId,
  }) : super(key: key);
  final String timeOfMessage, messageContent, chatId, groupId;
  final bool isPhoto;
  final Function onImageTap;
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 7.5,
            offset: Offset(0.0, 2.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '$timeOfMessage',
                    style: TextStyle(
                      fontSize: 9.0,
                      color: Colors.black26,
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      var list = List<PopupMenuEntry<Object>>();
                      list.add(
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 17,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () async {
                                  groupChatRef
                                      .doc(groupId)
                                      .collection('chats')
                                      .doc(chatId)
                                      .delete()
                                      .then((onValue) =>
                                          Navigator.of(context).pop());
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 17,
                                  ),
                                ),
                              )
                            ],
                          ),
                          value: 2,
                        ),
                      );
                      return list;
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      size: 20,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0),
          isPhoto
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAttachedImage(
                                  image: CachedNetworkImageProvider(
                                      messageContent),
                                  text: 'Chat Image',
                                )));
                  },
                  child: Stack(
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: messageContent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(
                              new ClipboardData(text: "$messageContent"))
                          .then((_) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text("copied")));
                      });
                    },
                    child: Text(
                      '$messageContent',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
          //     : Text(
          //   '$messageContent',
          //   style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
          //   textAlign: TextAlign.right,
          // ),
        ],
      ),
    );
  }
}

class ReceiverChatBox extends StatelessWidget {
  ReceiverChatBox({
    Key key,
    this.senderName,
    this.senderPhoto,
    this.messageContent,
    this.isPhoto,
    this.timeOfMessage,
    this.onCancel,
    this.onImageTap,
    this.senderId,
  }) : super(key: key);
  final String senderName, senderPhoto, timeOfMessage, messageContent, senderId;
  final bool isPhoto;
  final Function onCancel, onImageTap;

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
        color: Colors.green[100], //for now
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 7.5,
            offset: Offset(0.0, 2.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
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
          isPhoto
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAttachedImage(
                                  image: CachedNetworkImageProvider(
                                      messageContent),
                                  text: 'Chat Image',
                                )));
                  },
                  child: Stack(
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: messageContent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(
                              new ClipboardData(text: "$messageContent"))
                          .then((_) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text("copied")));
                      });
                    },
                    child: Text(
                      '$messageContent',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
