import 'package:flutter/material.dart';
import 'package:medcare/src/helpers/firebase_api.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:swipe_to/swipe_to.dart';

import '../screen_data_loading.dart';
import 'message.dart';
import 'message_widget.dart';

class DoctorMessagesWidget extends StatelessWidget {
  final ValueChanged<Message> onSwipedMessage;
  final String toUid, fromUid;
  const DoctorMessagesWidget({
    @required this.onSwipedMessage,
    Key key,
    this.toUid,
    this.fromUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.doctorGetMessages(fromUid, toUid),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return ScreenLoading();
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages.isEmpty
                    ? buildText('Say Hi..')
                    : StickyGroupedListView<dynamic, String>(
                        floatingHeader: true,
                        scrollDirection: Axis.vertical,
                        stickyHeaderBackgroundColor: Colors.black26,
                        physics: BouncingScrollPhysics(),
                        elements: snapshot.data,
                        groupBy: (element) => element.date,
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
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  element.date,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        itemBuilder: (c, element) {
                          return SwipeTo(
                            onRightSwipe: () => onSwipedMessage(element),
                            child: MessageWidget(
                              message: element,
                              isMe: element.senderId == fromUid,
                            ),
                          );
                        },
                      );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
