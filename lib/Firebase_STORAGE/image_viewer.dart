import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peelingfirebase/Firebase_STORAGE/dataholder.dart';

class ImageViewer extends StatefulWidget {
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  StorageReference imageRef = FirebaseStorage.instance.ref().child("images");
  Uint8List imageFile;

  getImage() {
    if (!requestedIndexes.contains("rawImage.jpg")) {
      imageRef.child("rawImage.jpg").getData(6 * 1024 * 1024).then((value) {
        this.setState(() {
          imageFile = value;
        });
        imageData.putIfAbsent("rawImage.jpg", () => value);
      });
    }
    requestedIndexes.add("rawImage.jpg");
  }

  @override
  void initState() {
    super.initState();
    if(!imageData.containsKey("rawImage.jpg")) {
      getImage();
    }
    else{
      this.setState(() {
        imageFile = imageData["rawImage.jpg"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cloud ☁ Images",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black45,
      body: Center(
        child: _buildList(context),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return imageFile == null
              ? Center(child: CircularProgressIndicator())
              : Container(
                  child: Image.memory(
                    imageFile,
                    fit: BoxFit.cover,
                  ),
                );
        });
  }
}
