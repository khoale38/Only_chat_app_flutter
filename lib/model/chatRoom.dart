import 'chatMessageModel.dart';

class ChatRoom {
  String id ;
  List<Messages> messages =[];

  ChatRoom({this.id, this.messages});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['messages'] != null) {
      messages =  [];
      json['messages'].forEach((v) {
        messages.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}