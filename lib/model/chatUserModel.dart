import 'package:flutter/cupertino.dart';
import 'dart:convert';


class ChatUsers {
  String id;
  String imageURl;
  String mail;
  String name;

  ChatUsers({ this.id, this.imageURl, this.mail, this.name});

  ChatUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageURl = json['imageURl'];
    mail = json['mail'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageURl'] = this.imageURl;
    data['mail'] = this.mail;
    data['name'] = this.name;
    return data;
  }
}