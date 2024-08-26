import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String receiverId;
  String senderId;
  String status;
  Timestamp timestamp;

  Request(this.receiverId, this.senderId, this.status,this.timestamp);
}
