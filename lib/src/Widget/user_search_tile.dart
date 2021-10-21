import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medcare/src/doctor/groupchat_tab/groupchat_tab_contents/chats/profile_picture.dart';

class UserSearchTile extends StatelessWidget {
  const UserSearchTile({
    Key key,
    this.onTap,
    this.userName,
    this.address,
    this.profileImage,
    this.isBusy = false,
    this.onChat,
    this.state,
  }) : super(key: key);
  final Function onTap, onChat;
  final String userName;
  final String address;
  final String state;
  final String profileImage;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.orange,
            blurRadius: 5,
            offset: Offset(0, 2.5),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: ProfilePicture(
          image: CachedNetworkImageProvider(
            profileImage ?? '',
          ),
          width: 40,
          height: 40,
        ),
        title: Text((userName != null) ? userName : ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text((address != null) ? address : ''),
            SizedBox(height: 5),
            Text((state != null) ? state : ''),
          ],
        ),
        trailing: GestureDetector(
          onTap: onChat,
          child: Container(
            width: 86,
            height: 33,
            padding: EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: (isBusy) ? Colors.orange : Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
                child: Text(
              'Book Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            )),
          ),
        ),
      ),
    );
  }
}
