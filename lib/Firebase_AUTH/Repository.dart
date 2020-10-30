import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'User.dart';

class Repository {
  CollectionReference collection = Firestore.instance.collection('users');
  CollectionReference imageRef = Firestore.instance.collection('user_images');
  StorageReference storageReference;

  Future<void> addUser(User user) async {
    collection.document(user.uid).setData(user.toJson(user));
    imageRef.document(user.uid).setData({
      'url':
          'https://cdn0.iconfinder.com/data/icons/social-media-network-4/48/male_avatar-512.png'
    });
  }

  updateUser(User user) async {
    await collection.document(user.uid).updateData(user.toJson(user));
  }

  getUser(FirebaseUser user) async {
    DocumentSnapshot snapshot = await collection.document(user.uid).get();
    User myUser = User.fromSnapshot(snapshot);
    return myUser;
  }

  getUserImage(String uid) async {
    DocumentSnapshot snapshot = await imageRef.document(uid).get();
    return snapshot['url'];
  }

  Stream<DocumentSnapshot> getStream(String uid) {
    return imageRef.document(uid).snapshots();
  }


  String filename;
  File file;

  filePicker(BuildContext context, String uid) async {
    file = await FilePicker.getFile(type: FileType.image);
    if (file != null) {
      uploadFile(file, uid);
    } else {
      return;
    }
  }

  Future<String> uploadFile(File file, String uid) async {
    storageReference = FirebaseStorage.instance.ref().child('user_images/$uid');
    final StorageUploadTask task = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await task.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    imageRef.document(uid).updateData({'url': url});
    return url;
  }
}
