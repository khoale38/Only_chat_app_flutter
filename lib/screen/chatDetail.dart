import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled3/model/chatMessageModel.dart';
import 'package:untitled3/model/chatUserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatDetailPage extends StatefulWidget {
  ChatUsers chatUsers;
  String roomID;

  ChatDetailPage({this.chatUsers, this.roomID});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  File _image;
  Uuid uuid = new Uuid();
  ScrollController _scrollController ;

  Future getImage() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 150, maxHeight: 150);
    setState(() {
      _image = image;
    });
  }

  final _auth = FirebaseAuth.instance;
  String messageText;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.chatUsers.imageURl),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.chatUsers.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('message')
                  .doc(widget.roomID)
                  .collection(widget.roomID)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasError)
                  return Text('Error: ${streamSnapshot.error}');

                switch (streamSnapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Select lot');
                  case ConnectionState.waiting:
                    return Center(
                      child: Text('Awaiting bids...'),
                    );
                  case ConnectionState.active:
                    {
                      if(!streamSnapshot.hasData)
                        return Center(child: Text('Start your conversation'));
                      final listchat = streamSnapshot.data.docs
                          .map((e) => Messages.fromJson(e.data()))
                          .toList();
                      listchat.sort((a,b)=>(b.timestamp.compareTo(a.timestamp)));
                      return ListView.builder(
                        reverse: true,
                          itemCount: listchat.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Align(
                                alignment: (listchat[index].sender !=
                                        _auth.currentUser.uid
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (listchat[index].receiver ==
                                            _auth.currentUser.uid
                                        ? Colors.grey
                                        : Colors.blue[200]),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    listchat[index].contain,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  case ConnectionState.done:
                    return Text('done');
                }
                return null;
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      Fluttertoast.showToast(
                          msg: "Function not fully developed");
                      /*getImage();
                      String Url = await postFile(imageFile: _image, folderPath: 'chat_photos', fileName: uuid.v4());*/
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,

                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      sendtext(_controller.text);
                      _controller.clear();
                      _controller.clearComposing();


                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendtext(String input) {
    if (input != '') {
      /*var documentReference = */ FirebaseFirestore.instance
          .collection('message')
          .doc(widget.roomID)
          .collection(widget.roomID)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(Messages(
                  sender: _auth.currentUser.uid,
                  receiver: widget.chatUsers.id,
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                  contain: input)
              .toJson());
    } else
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
  }

  File _imageFile;

  static Future<String> postFile(
      {@required File imageFile,
      @required String folderPath,
      @required String fileName}) async {
    Reference reference =
        FirebaseStorage.instance.ref().child(folderPath).child(fileName);

    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);

    String dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return dowUrl;
  }



}

