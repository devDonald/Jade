import 'package:flutter/material.dart';

class GroupChatTextField extends StatelessWidget {
  final Function onTap, getImageTap, sendMessageTap;
  final Function(String) onChanged;
  final bool isTyping;
  final FocusNode myFocusNode;
  final TextEditingController textController;

  const GroupChatTextField(
      {Key key,
      this.onTap,
      this.onChanged,
      this.getImageTap,
      this.sendMessageTap,
      this.isTyping = false,
      this.myFocusNode,
      this.textController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
              child: TextField(
                maxLines: 3,
                minLines: 1,
                // onTap: onTap,
                onChanged: onChanged,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                autofocus: false,
                focusNode: myFocusNode,
                controller: textController,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Color(0xff8e8e8e)),
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: getImageTap,
            child: Container(
              padding: EdgeInsets.only(right: 10, left: 5),
              child: Icon(
                Icons.camera,
                size: 17,
                color: Color(0xff8e8e8e),
              ),
            ),
          ),
          isTyping
              ? GestureDetector(
                  onTap: sendMessageTap,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    margin: EdgeInsets.only(right: 10, left: 5),
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.send,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
