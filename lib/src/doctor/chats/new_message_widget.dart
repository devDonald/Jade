// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:medcare/src/doctor/chats/reply_message_widget.dart';
//
// import '../firebase_api.dart';
// import 'message.dart';
//
// class NewMessageWidget extends StatefulWidget {
//   final FocusNode focusNode;
//   final String chatId, username;
//   final Message replyMessage;
//   final VoidCallback onCancelReply;
//
//   const NewMessageWidget({
//     @required this.focusNode,
//     @required this.chatId,
//     @required this.replyMessage,
//     @required this.onCancelReply,
//     Key key,
//     this.username,
//   }) : super(key: key);
//
//   @override
//   _NewMessageWidgetState createState() => _NewMessageWidgetState();
// }
//
// class _NewMessageWidgetState extends State<NewMessageWidget> {
//   final _controller = TextEditingController();
//   String message = '', _currentUserName, _currentUserImage;
//   bool isTyping = false;
//   bool isGetImageType = false;
//
//   String gottenUserToReplyTO = '';
//
//   static final inputTopRadius = Radius.circular(12);
//   static final inputBottomRadius = Radius.circular(24);
//
//   void sendMessage() async {
//     FocusScope.of(context).unfocus();
//     widget.onCancelReply();
//
//     try {
//       await FirebaseApi.uploadMessage(_currentUserImage, widget.username,
//           message, widget.replyMessage, widget.chatId, _currentUserName);
//     } catch (e) {
//       Scaffold.of(context).showSnackBar(
//         SnackBar(
//           content: Text('error'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//
//     _controller.clear();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   getTextKeyBoard() {
//     widget.focusNode.requestFocus();
//   }
//
//   File addedImage;
//   final _picker = ImagePicker();
//   bool isPhotoPicked = false;
//   bool isGetUsers = false;
//
//   getImageFile(ImageSource source) async {
//     //Clicking or Picking from Gallery
//
//     var image = await _picker.getImage(source: source);
//
//     //Cropping the image
//
//     File croppedFile = await ImageCropper.cropImage(
//       sourcePath: image.path,
//       maxWidth: 512,
//       maxHeight: 512,
//     );
//
//     setState(() {
//       addedImage = croppedFile;
//       print(addedImage.lengthSync());
//       print('test');
//       isPhotoPicked = true;
//     });
//
//     FocusScope.of(context).unfocus();
//     widget.onCancelReply();
//
//     try {
//       await FirebaseApi.saveImages(
//           addedImage,
//           _currentUserImage,
//           widget.username,
//           widget.replyMessage,
//           widget.chatId,
//           _currentUserName);
//     } catch (e) {
//       Scaffold.of(context).showSnackBar(
//         SnackBar(
//           content: Text('error'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//   Widget buildGetImage() {
//     return Container(
//       margin: EdgeInsets.only(
//         left: 16.5,
//         right: 16.5,
//       ),
//       padding: EdgeInsets.only(left: 15, right: 15, top: 35),
//       width: double.infinity,
//       height: 125.5,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(15.0),
//           topRight: Radius.circular(15.0),
//         ),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 4.5,
//             offset: Offset(0.0, -3.5),
//             color: Colors.black26,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           GestureDetector(
//             onTap: () {
//               getImageFile(ImageSource.camera);
//             },
//             child: Column(
//               children: [
//                 Container(
//                   child: Icon(
//                     Icons.camera_alt,
//                     size: 50,
//                   ),
//                 ),
//                 Text('Camera'),
//               ],
//             ),
//           ),
//           SizedBox(width: 15),
//           GestureDetector(
//             onTap: () {
//               getImageFile(ImageSource.gallery);
//             },
//             child: Column(
//               children: [
//                 Container(
//                   child: Icon(
//                     Icons.photo,
//                     size: 50,
//                   ),
//                 ),
//                 Text('Gallery'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isReplying = widget.replyMessage != null;
//
//     return Container(
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: Column(
//               children: [
//                 if (isReplying) buildReply(),
//                 isGetImageType && isTyping == false
//                     ? buildGetImage()
//                     : Container(),
//                 buildInput(isReplying),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildReply() => Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.grey.withOpacity(0.2),
//           borderRadius: BorderRadius.only(
//             topLeft: inputTopRadius,
//             topRight: inputTopRadius,
//           ),
//         ),
//         child: ReplyMessageWidget(
//           message: widget.replyMessage,
//           onCancelReply: widget.onCancelReply,
//         ),
//       );
//
//   Widget buildInput(bool isReplying) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//       margin: EdgeInsets.only(
//         left: 16.5,
//         right: 16.5,
//         bottom: 15.5,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(
//           5.0,
//         ),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 7.5,
//             offset: Offset(0.0, 2.5),
//             color: Colors.black26,
//           ),
//         ],
//       ),
//       child: Row(
//         children: <Widget>[
//           // Button send image
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 1.0),
//           ),
//
//           // Edit text
//           Flexible(
//             child: Container(
//               child: TextFormField(
//                 onTap: getTextKeyBoard,
//                 onChanged: (change) {
//                   if (change != '') {
//                     setState(() {
//                       isTyping = true;
//                       message = change;
//                     });
//                   } else {
//                     setState(() {
//                       isTyping = false;
//                     });
//                   }
//                 },
//                 textInputAction: TextInputAction.newline,
//                 keyboardType: TextInputType.multiline,
//                 minLines: 1, //Normal textInputField will be displayed
//                 maxLines: 5,
//                 textCapitalization: TextCapitalization.sentences,
//                 autofocus: false,
//                 enableSuggestions: true,
//                 focusNode: widget.focusNode,
//                 controller: _controller,
//                 style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'Type a message...',
//                   hintStyle: TextStyle(color: Color(0xff8e8e8e)),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.only(
//                       topLeft: isReplying ? Radius.zero : inputBottomRadius,
//                       topRight: isReplying ? Radius.zero : inputBottomRadius,
//                       bottomLeft: inputBottomRadius,
//                       bottomRight: inputBottomRadius,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 isGetImageType = !isGetImageType;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.only(right: 10, left: 5),
//               child: Icon(
//                 Icons.camera_alt,
//                 size: 20,
//                 color: Color(0xff8e8e8e),
//               ),
//             ),
//           ),
//           isTyping
//               ? GestureDetector(
//                   onTap: () {
//                     //send message
//                     if (_controller.text != '') {
//                       sendMessage();
//                     }
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.orange,
//                     ),
//                     margin: EdgeInsets.only(right: 10, left: 5),
//                     padding: EdgeInsets.all(4),
//                     child: Icon(
//                       Icons.send,
//                       size: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
