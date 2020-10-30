import 'dart:async';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MlkitHome extends StatefulWidget {
  @override
  _MlkitHomeState createState() => _MlkitHomeState();
}

class _MlkitHomeState extends State<MlkitHome> {
  File imageFile;
  bool no = true;
  String data = "No data to Show";
  final List<String> imageLabels = [];
  int index = 0;
  String imageType = 'Gallery';

  _pickImage() async {
    setState(() {
      no = true;
      imageLabels.clear();
      data = "No data to Show";
      index = 0;
    });
    if (imageType == 'Gallery') {
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    } else {
      imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    if (imageFile != null) {
      setState(() {
        no = false;
      });
    }
  }

  Future<void> detectLabels() async {
    setState(() {
      imageLabels.clear();
      data = "No Data To show";
      index = 0;
    });
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    final ImageLabeler labelDetector = FirebaseVision.instance
        .imageLabeler(ImageLabelerOptions(confidenceThreshold: 0.50));

    final List<ImageLabel> labels =
        await labelDetector.processImage(visionImage);

    for (ImageLabel label in labels) {
      imageLabels.add(label.text);
    }
    setState(() {
      data = imageLabels[0];
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        elevation: 10,
        title: Text("Image Labeler",
            style: TextStyle(
                color: Colors.white, fontFamily: 'cursive', fontSize: 48)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 250,
                width: 250,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                child: no
                    ? Image.asset('assets/loading.gif')
                    : Image.file(imageFile),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 5.0),
                child: Text(
                  "Pick An Image",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    elevation: 10,
                    child: Text("Camera"),
                    color: Colors.cyan,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        imageType = 'Camera';
                        _pickImage();
                      });
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    elevation: 10,
                    child: Text("Gallery"),
                    onPressed: () {
                      setState(() {
                        imageType = 'Gallery';
                        _pickImage();
                      });
                    },
                    color: Colors.white,
                    textColor: Colors.cyan,
                  )
                ],
              ),
              Divider(
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 5.0),
                child: RaisedButton(
                  elevation: 10,
                  onPressed: imageFile==null?null:() {
                    detectLabels();
                  },
                  child: Text("Detect"),
                  color: Colors.black45,
                  textColor: Colors.cyan,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.cyan,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      elevation: 10,
                      onPressed: (data == "No data to Show" || index == 0)
                          ? null
                          : () {
                              index--;
                              if (index < 0) {
                                setState(() {
                                  index = 0;
                                });
                              } else {
                                setState(() {
                                  data = imageLabels[index];
                                });
                              }
                            },
                      color: Colors.black45,
                      child: Text("Prev Label"),
                      textColor: Colors.cyan,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      elevation: 10,
                      onPressed: (data == "No data to Show" ||
                              index == imageLabels.length-1)
                          ? null
                          : () {
                              index++;
                              if (index >= imageLabels.length) {
                                setState(() {
                                  index = imageLabels.length-1;
                                });
                              } else {
                                setState(() {
                                  data = imageLabels[index];
                                });
                              }
                            },
                      color: Colors.black45,
                      child: Text("Next Label"),
                      textColor: Colors.cyan,
                    )
                  ],
                ),
              ),
              Divider(color: Colors.white,),
              SizedBox(height: 10,),
              Text("Made By : Chronoviser 👦 💻",style: TextStyle(color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}
