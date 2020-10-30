import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:peelingfirebase/Firebase_AUTH/Repository.dart';
import 'package:peelingfirebase/Firebase_AUTH/loginpage.dart';

import 'User.dart';
import 'auth_services.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

FSBStatus status;
bool doing = false;

class _MainPageState extends State<MainPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;
  User currentUser;
  String imageUrl;
  Repository repository = Repository();

  setUp() async {
    user = await auth.currentUser();
    currentUser = await repository.getUser(user);
    imageUrl = await repository.getUserImage(user.uid);
    setState(() {
      status = FSBStatus.FSB_CLOSE;
    });
    Future.delayed(Duration(seconds: 2)).then((_) => this.setState(() {
          doing = false;
        }));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      doing = true;
    });
    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: doing
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Keep Calm 😇, we are setting up your profile", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20,),
                    CircularProgressIndicator()
                  ],
                ),
              )
            : FoldableSidebarBuilder(
                status: status,
                screenContents: LandingPage(),
                drawer: CustomDrawer(currentUser, imageUrl),
                drawerBackgroundColor: Colors.white),
        floatingActionButton: FloatingActionButton(
          tooltip: "Settings",
          backgroundColor: Colors.black45,
          child: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            setState(() {
              status = status == FSBStatus.FSB_OPEN
                  ? FSBStatus.FSB_CLOSE
                  : FSBStatus.FSB_OPEN;
            });
          },
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("You are logged in 😊"));
  }
}

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  User user;
  String url;

  CustomDrawer(this.user, this.url);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Repository repository = Repository();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.60,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          SizedBox(
            height: 7,
          ),
          uploading
              ? CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/loading.gif'),
                )
              : StreamBuilder<DocumentSnapshot>(
                  stream: repository.getStream(widget.user.uid),
                  builder: (context, snapshot) {
                    return CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.transparent,
                      backgroundImage: snapshot.hasData
                          ? NetworkImage(snapshot.data['url'])
                          : AssetImage('assets/loading.gif'),
                    );
                  }),
          SizedBox(
            height: 7,
          ),
          FlatButton(
            onPressed: () {
              getUrl() async {
                await repository.filePicker(context, widget.user.uid);
              }

              getUrl();
              Future.delayed(Duration(seconds: 2));
            },
            color: Colors.white30,
            child: Text("Change Profile Image"),
          ),
          Divider(
            color: Colors.white,
            thickness: 2,
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Text(
              widget.user.name,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Divider(color: Colors.white),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8.0),
            child: Text(widget.user.email,
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          Divider(color: Colors.white),
          SizedBox(
            height: 10,
          ),
          Text(widget.user.phone,
              style: TextStyle(color: Colors.white, fontSize: 18)),
          Divider(color: Colors.white),
          FlatButton(
            onPressed: () {
              _showUpdateDialog(context, widget.user);
              setState(() {});
            },
            color: Colors.white30,
            child: Text("Update Profile"),
          ),
          Divider(
            color: Colors.white,
            thickness: 2,
          ),
          FlatButton(
            onPressed: () {
              Auth _auth = Auth();
              _auth.logout();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            color: Colors.white30,
            splashColor: Colors.white,
            child: Text("<- Logout"),
          )
        ],
      ),
    );
  }

  Future<bool> _showUpdateDialog(BuildContext context, User user) {
    String name = user.name;
    final String email = user.email;
    String phone = user.phone;
    String res = "";

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: MediaQuery.of(context).size.height * 0.20),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Update 🧔 Profile",
                          style: TextStyle(fontSize: 24, color: Colors.black)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: (val) {
                          name = val;
                        },
                        decoration: InputDecoration(hintText: name),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(email,
                            style:
                                TextStyle(fontSize: 20, color: Colors.black45)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onChanged: (val) {
                          phone = val;
                        },
                        decoration: InputDecoration(hintText: phone),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (name != null &&
                            phone != null &&
                            phone.length == 10) {
                          if (name == user.name && phone == user.phone) {
                            Navigator.of(context).pop();
                          }
                          user.name = name;
                          user.phone = phone;
                          repository.updateUser(user);
                          Future.delayed(Duration(seconds: 1));
                          Navigator.of(context).pop();
                          setState(() {});
                        } else {
                          setState(() {
                            res = "Invalid Info, Not Acceptable 😥";
                          });
                        }
                      },
                      color: Colors.black45,
                      child: Text(
                        "Update",
                      ),
                      textColor: Colors.white,
                      splashColor: Colors.cyan,
                    ),
                    Text(res, style: TextStyle(color: Colors.red))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
