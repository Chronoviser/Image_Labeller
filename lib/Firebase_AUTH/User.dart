import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  String name;
  String email;
  String phone;
  String uid;

  User({this.name, @required this.email, this.phone, this.uid});

  Map<String, dynamic> toJson(User user) {
    return {
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'uid': user.uid,
    };
  }

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    return User(
        name: snapshot['name'],
        email: snapshot['email'],
        phone: snapshot['phone'],
        uid: snapshot['uid']);
  }
}
