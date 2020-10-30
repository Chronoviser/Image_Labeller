import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peelingfirebase/Firebase_AUTH/MainPage.dart';
import 'package:peelingfirebase/Firebase_AUTH/Repository.dart';
import 'package:peelingfirebase/Firebase_AUTH/auth_services.dart';
import 'package:peelingfirebase/Firebase_AUTH/loginpage.dart';

import 'User.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _email;
  String _password;
  String _confirm_pass;
  bool signingup = false;

  _performSignUp(String email, String pass, String confirmed) async {
    bool validEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (pass != confirmed ||
        email == null ||
        pass == null ||
        !validEmail ||
        pass.length < 6) {
      setState(() {
        signingup = false;
      });
      return;
    }
    Auth auth = Auth();
    FirebaseUser user;
    user = await auth.signUp(email: email, password: pass);

    Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() {
        signingup = false;
        if (user != null) {
          _storeInfoToDatabase(user);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        }
      });
    });
  }

  _storeInfoToDatabase(FirebaseUser user) async {
    User myUser = User(
        email: _email, name: 'Anonymous', phone: 'Phone Number', uid: user.uid);
    Repository repository = Repository();
    repository.addUser(myUser);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: signingup
            ? Center(
                child: LinearProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      Text(
                        "Signup",
                        style: TextStyle(fontFamily: 'cursive', fontSize: 48),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      TextField(
                        onChanged: (val) {
                          _email = val;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            InputDecoration(hintText: "Enter your email"),
                      ),
                      TextField(
                        onChanged: (val) {
                          _password = val;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText:
                                "Enter your password (at least 6 characters long)"),
                      ),
                      TextField(
                        onChanged: (val) {
                          _confirm_pass = val;
                        },
                        obscureText: true,
                        decoration:
                            InputDecoration(hintText: "Confirm your password"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.033,
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            signingup = true;
                          });
                          _performSignUp(_email, _password, _confirm_pass);
                        },
                        color: Colors.black45,
                        child: Text("Signup"),
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.033,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already a member? "),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
