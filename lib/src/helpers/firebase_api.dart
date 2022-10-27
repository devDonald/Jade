import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medcare/src/doctor/groupchat_tab/groupchat_tab_contents/chats/message.dart';
import 'package:medcare/src/screens/users_home.dart';

class FirebaseApi {
  static Future uploadMessage(
      String senderPhoto,
      String toUsername,
      String messageContent,
      String toUid,
      String fromUid,
      String senderName) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    DocumentReference _docRef = usersRef
        .doc(fromUid)
        .collection('chats')
        .doc(toUid)
        .collection('chat')
        .doc();
    final newMessage = Message(
      chatType: 'text',
      receiverId: toUid,
      receiverName: toUsername,
      date: formatted,
      time: "${new DateFormat.jm().format(new DateTime.now())}",
      isPhoto: false,
      isRecorded: false,
      isPinned: false,
      seen: false,
      visible: true,
      messageId: _docRef.id,
      senderId: fromUid,
      photo: senderPhoto,
      userName: senderName,
      messageContent: messageContent,
      timestamp: DateTime.now().toUtc(),
    );
    await _docRef.set(newMessage.toJson()).then((value) async {
      doctorRef
          .doc(toUid)
          .collection('chats')
          .doc(fromUid)
          .collection('chat')
          .doc(_docRef.id)
          .set(newMessage.toJson());
      await feedRef.doc(toUid).collection('chats').doc(_docRef.id).set({
        'senderId': fromUid,
        'senderName': senderName,
        'message': messageContent,
        'type': 'chat',
        'seen': false,
        'timestamp': DateTime.now().toUtc(),
        'receiverId': toUid,
        'receiverName': toUsername,
      });
      await doctorRef.doc(toUid).collection('chats').doc(fromUid).update({
        'username': senderName,
        'photo': senderPhoto,
        'latestChat': messageContent,
        'timestamp': timestamp,
        'date': formatted,
        'time': "${new DateFormat.jm().format(new DateTime.now())}",
      });
    });
  }

  static Future uploadMessageFromDoctor(
      String senderPhoto,
      String toUsername,
      String messageContent,
      String toUid,
      String fromUid,
      String senderName) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    DocumentReference _docRef = doctorRef
        .doc(fromUid)
        .collection('chats')
        .doc(toUid)
        .collection('chat')
        .doc();
    final newMessage = Message(
      chatType: 'text',
      receiverId: toUid,
      receiverName: toUsername,
      date: formatted,
      time: "${new DateFormat.jm().format(new DateTime.now())}",
      isPhoto: false,
      isRecorded: false,
      isPinned: false,
      seen: false,
      visible: true,
      messageId: _docRef.id,
      senderId: fromUid,
      photo: senderPhoto,
      userName: senderName,
      messageContent: messageContent,
      timestamp: DateTime.now().toUtc(),
    );
    await _docRef.set(newMessage.toJson()).then((value) async {
      usersRef
          .doc(toUid)
          .collection('chats')
          .doc(fromUid)
          .collection('chat')
          .doc(_docRef.id)
          .set(newMessage.toJson());
      await feedRef.doc(toUid).collection('chats').doc(_docRef.id).set({
        'senderId': fromUid,
        'senderName': senderName,
        'message': messageContent,
        'type': 'chat',
        'seen': false,
        'timestamp': DateTime.now().toUtc(),
        'receiverId': toUid,
        'receiverName': toUsername,
      });
    });
  }
}
