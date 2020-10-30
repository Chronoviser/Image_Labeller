import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peelingfirebase/Firebase_STORAGE/storage_home.dart';
import 'package:peelingfirebase/upload_download/ud_homepage.dart';
import 'Firebase_AUTH/signuppage.dart';
import 'Firebase_CRUD/crud_hoomepage.dart';
import 'Firebase_MLKIT/face_recognition.dart';
import 'file:///E:/summer_course_android/peeling_firebase/lib/Firebase_CRUD/cars.dart';
import 'file:///E:/summer_course_android/peeling_firebase/lib/Firebase_CRUD/datarepository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MlkitHome(),
    );
  }
}

