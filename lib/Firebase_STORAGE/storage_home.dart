import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peelingfirebase/Firebase_STORAGE/image_viewer.dart';

class StorageHome extends StatefulWidget {
  @override
  _StorageHomeState createState() => _StorageHomeState();
}

class _StorageHomeState extends State<StorageHome> {
  String fileType = '';
  File file;
  String fileName = '';
  bool uploading = false;
  String result = '';

  Future filePicker(BuildContext context) async {
    print("INSIDE FILE PICKER");
    try {
      if (fileType == 'image') {
        file = await FilePicker.getFile(type: FileType.image);

        if (file == null) {
          setState(() {
            uploading = false;
          });
          return;
        } else {
          setState(() {
            fileName = p.basename(file.path);
          });
        }
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'audio') {
        file = await FilePicker.getFile(type: FileType.audio);

        if (file == null) {
          setState(() {
            uploading = false;
          });
          return;
        } else {
          setState(() {
            fileName = p.basename(file.path);
          });
        }
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'video') {
        file = await FilePicker.getFile(type: FileType.video);

        if (file == null) {
          setState(() {
            uploading = false;
          });
          return;
        } else {
          setState(() {
            fileName = p.basename(file.path);
          });
        }
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'pdf') {
        file = await FilePicker.getFile(
            type: FileType.custom, allowedExtensions: ['pdf']);

        if (file == null) {
          setState(() {
            uploading = false;
          });
          return;
        } else {
          setState(() {
            fileName = p.basename(file.path);
          });
        }
        print(fileName);
        _uploadFile(file, fileName);
      }
      if (fileType == 'others') {
        file = await FilePicker.getFile(type: FileType.any);

        if (file == null) {
          setState(() {
            uploading = false;
          });
          return;
        } else {
          setState(() {
            fileName = p.basename(file.path);
          });
        }
        print(fileName);
        _uploadFile(file, fileName);
      }
    } on PlatformException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> _uploadFile(File file, String filename) async {
    print("INSIDE UPLOAD FILE");

    StorageReference storageReference;
    if (fileType == 'image') {
      storageReference =
          FirebaseStorage.instance.ref().child("images/$filename");
    }
    if (fileType == 'audio') {
      storageReference =
          FirebaseStorage.instance.ref().child("audio/$filename");
    }
    if (fileType == 'video') {
      storageReference =
          FirebaseStorage.instance.ref().child("videos/$filename");
    }
    if (fileType == 'pdf') {
      storageReference = FirebaseStorage.instance.ref().child("pdf/$filename");
    }
    if (fileType == 'others') {
      storageReference =
          FirebaseStorage.instance.ref().child("others/$filename");
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        uploading = false;
      });
    });
    print("URL is $url");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: Text(
          "Firebase Storage",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: uploading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Image',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.image,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'image';
                        uploading = true;
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Audio',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.audiotrack,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'audio';
                        uploading = true;
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Video',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.video_label,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'video';
                        uploading = true;
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'PDF',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.pages,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'pdf';
                        uploading = true;
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Others',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.attach_file,
                      color: Colors.redAccent,
                    ),
                    onTap: () {
                      setState(() {
                        fileType = 'others';
                        uploading = true;
                      });
                      filePicker(context);
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    result,
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black45,
        child: IconButton(
          icon: Icon(
            Icons.view_list,
            color: Colors.cyan,
            size: 36,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ImageViewer()));
          },
        ),
      ),
    );
  }
}
