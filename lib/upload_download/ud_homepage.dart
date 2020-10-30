import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UPHome extends StatefulWidget {
  @override
  _UPHomeState createState() => _UPHomeState();
}

class _UPHomeState extends State<UPHome> {
  String filename;
  File file;
  bool uploading = false;

  StorageReference _storageReference;
  CollectionReference collectionReference =
      Firestore.instance.collection('photos');

  Stream<QuerySnapshot> getStream() {
    return collectionReference.snapshots();
  }

  Future _filePicker(BuildContext context) async {
    file = await FilePicker.getFile(type: FileType.image);
    if (file != null) {
      setState(() {
        filename = p.basename(file.path);
      });
      _uploadFile(file, filename);
    } else {
      setState(() {
        uploading = false;
        return;
      });
    }
  }

  Future _uploadFile(File file, String filename) async {
    _storageReference =
        FirebaseStorage.instance.ref().child('photos/$filename');
    final StorageUploadTask task = _storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await task.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    await collectionReference.document().setData({'url': url});
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        uploading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        elevation: 1.0,
        title: Text("Upload and View App"),
        centerTitle: true,
      ),
      body: uploading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: getStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return _buildList(context, snapshot.data.documents);
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        onPressed: () {
          setState(() {
            uploading = true;
          });
          _filePicker(context);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(5),
            child: Image.network(snapshot[index]['url'], fit: BoxFit.cover),
          );
        });
  }
}
