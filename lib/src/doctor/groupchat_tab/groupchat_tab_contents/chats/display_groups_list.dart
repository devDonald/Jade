import 'package:flutter/material.dart';

class DisplayGroups extends StatelessWidget {
  final String photo, username, lastChat, time;
  final int chatCount;
  final Function onTap;

  const DisplayGroups(
      {Key key,
      this.photo,
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
              child: Image.network(
                photo ?? '',
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
