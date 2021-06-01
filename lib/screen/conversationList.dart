import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/model/chatUserModel.dart';

import 'chatDetail.dart';


class ConversationList extends StatefulWidget {

  ChatUsers chatUsers;

  ConversationList (
      { this.chatUsers});

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  String roomID;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          Initstate();
          return ChatDetailPage(chatUsers: widget.chatUsers,roomID: roomID,);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.chatUsers.imageURl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.chatUsers.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  void Initstate() {
    var senderID= FirebaseAuth.instance.currentUser.uid;
    var receiverID = widget.chatUsers.id;
    if (senderID.hashCode <= receiverID.hashCode) {
      roomID= '$senderID-$receiverID';
    } else {
      roomID = '$receiverID-$senderID';
    }

  }
}
