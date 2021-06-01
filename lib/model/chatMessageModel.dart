class Messages {
  /*String id;*/
  String sender;
  String receiver;
  int timestamp;
  String contain;

  Messages({/*this.id,*/ this.sender, this.receiver, this.timestamp, this.contain});

  Messages.fromJson(Map<String, dynamic> json) {
    /*id = json['id'];*/
    sender = json['sender'];
    receiver = json['receiver'];
    timestamp = json['timestamp'];
    contain = json['contain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    /*data['id'] = this.id;*/
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['timestamp'] = this.timestamp;
    data['contain'] = this.contain;
    return data;
  }
}