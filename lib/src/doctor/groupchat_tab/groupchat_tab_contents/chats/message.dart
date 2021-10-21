import 'package:medcare/src/helpers/utils.dart';

class MessageField {
  static final String messageContent = 'messageContent';
  static final String timestamp = 'timestamp';
}

class Message {
  final String senderId, chatType, receiverId, date, receiverName;
  final String photo;
  final String userName, time;
  final String messageContent, messageId;
  final DateTime timestamp;
  final Message replyMessage;
  final bool isPhoto, isPinned, isRecorded, seen, visible;

  const Message({
    this.senderId,
    this.chatType,
    this.receiverId,
    this.date,
    this.receiverName,
    this.photo,
    this.userName,
    this.time,
    this.messageContent,
    this.messageId,
    this.timestamp,
    this.replyMessage,
    this.isPhoto,
    this.isPinned,
    this.isRecorded,
    this.seen,
    this.visible,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        senderId: json['senderId'],
        chatType: json['chatType'],
        receiverId: json['receiverId'],
        date: json['date'],
        receiverName: json['receiverName'],
        time: json['time'],
        isPhoto: json['isPhoto'],
        isPinned: json['isPinned'],
        isRecorded: json['isRecorded'],
        seen: json['seen'],
        visible: json['visible'],
        messageId: json['messageId'],
        photo: json['photo'],
        userName: json['userName'],
        messageContent: json['messageContent'],
        timestamp: Utils.toDateTime(json['timestamp']),
        replyMessage: json['replyMessage'] == null
            ? null
            : Message.fromJson(json['replyMessage']),
      );

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'photo': photo,
        'chatType': chatType,
        'date': date,
        'receiverName': receiverName,
        'time': time,
        'isPhoto': isPhoto,
        'isPinned': isPinned,
        'receiverId': receiverId,
        'isRecorded': isRecorded,
        'seen': seen,
        'visible': visible,
        'messageId': messageId,
        'userName': userName,
        'messageContent': messageContent,
        'timestamp': Utils.fromDateTimeToJson(timestamp),
        'replyMessage': replyMessage == null ? null : replyMessage.toJson(),
      };
}
