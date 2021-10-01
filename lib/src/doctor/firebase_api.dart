import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:medcare/src/doctor/doctor_home.dart';
import 'package:medcare/src/helpers/utils.dart';
import 'package:path/path.dart' as Path;

import 'chats/message.dart';

class FirebaseApi {
  static Future uploadMessage(
      String senderPhoto,
      String groupName,
      String messageContent,
      Message replyMessage,
      String userId,
      String chatId,
      String senderName) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    DocumentReference _docRef =
        groupChatRef.doc(chatId).collection('chats').doc();
    final newMessage = Message(
      chatType: 'text',
      groupId: chatId,
      groupName: groupName,
      date: formatted,
      time: "${new DateFormat.jm().format(new DateTime.now())}",
      isPhoto: false,
      isRecorded: false,
      isPinned: false,
      seen: false,
      visible: true,
      messageId: _docRef.id,
      senderId: userId,
      photo: senderPhoto,
      userName: senderName,
      messageContent: messageContent,
      timestamp: DateTime.now().toUtc(),
      replyMessage: replyMessage,
    );
    await _docRef.set(newMessage.toJson()).then((value) async {
      await root
          .collection("groupDetails")
          .doc(chatId)
          .collection("members")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) async {
          String value = element.id;
          if (userId != value) {
            await root
                .collection('feed')
                .doc(value)
                .collection('chats')
                .doc(_docRef.id)
                .set({
              'senderId': userId,
              'senderName': senderName,
              'message': messageContent,
              'type': 'chat',
              'seen': false,
              'timestamp': DateTime.now().toUtc(),
              'receiverId': value,
              'groupName': groupName,
              'groupId': chatId,
            });
          }
        });
      });
    });
  }

  static Stream<List<Message>> getMessages(String groupId) => groupChatRef
      .doc(groupId)
      .collection('chats')
      .orderBy(MessageField.timestamp, descending: false)
      .snapshots()
      .transform(Utils.transformer(Message.fromJson));

  static Future saveImages(
      File file,
      String senderPhoto,
      String groupName,
      Message replyMessage,
      String groupId,
      String senderName,
      String userId) async {
    User _currentUser = FirebaseAuth.instance.currentUser;
    String uid = _currentUser.uid;
    if (file != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('chats/$uid/${Path.basename(file.path)}}');
      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask;
      storageReference.getDownloadURL().then((fileURL) async {
        String image = fileURL;
        final DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(now);
        DocumentReference _docRef =
            groupChatRef.doc(groupId).collection('chats').doc();
        final newMessage = Message(
          chatType: 'photo',
          groupId: groupId,
          groupName: groupName,
          date: formatted,
          time: "${new DateFormat.jm().format(new DateTime.now())}",
          isPhoto: true,
          isRecorded: false,
          isPinned: false,
          seen: false,
          visible: true,
          messageId: _docRef.id,
          senderId: userId,
          photo: senderPhoto,
          userName: senderName,
          messageContent: image,
          timestamp: DateTime.now().toUtc(),
          replyMessage: replyMessage,
        );
        await _docRef.set(newMessage.toJson()).then((value) async {
          await root
              .collection("groupDetails")
              .doc(groupId)
              .collection("members")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((element) {
              String value = element.id;
              if (userId != value) {
                root
                    .collection('feed')
                    .doc(value)
                    .collection('chats')
                    .doc(_docRef.id)
                    .set({
                  'senderId': userId,
                  'senderName': senderName,
                  'message': 'photo',
                  'type': 'chat',
                  'seen': false,
                  'timestamp': DateTime.now().toUtc(),
                  'receiverId': value,
                  'username': groupName,
                  'chatId': groupId,
                });
              }
            });
          });
        });

        await Fluttertoast.showToast(
            msg: "photo sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } else {
      await Fluttertoast.showToast(
          msg: "Please Select a photo",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
