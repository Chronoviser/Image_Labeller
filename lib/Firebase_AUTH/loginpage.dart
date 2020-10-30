import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peelingfirebase/Firebase_AUTH/signuppage.dart';

import 'MainPage.dart';
import 'auth_services.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email;
  String _password;
  bool logingin = false;

  _performLogin(String email, String pass) async {
    bool validEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (email == null || pass == null || !validEmail || pass.length < 6) {
      setState(() {
        logingin = false;
      });
      return;
    }

    Auth auth = Auth();
    FirebaseUser user;
    user = await auth.login(email: email, password: pass);
    Future.delayed(Duration(seconds: 1)).then((_) {
      setState(() {
        logingin = false;
        if (user != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: logingin
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
                        "Login",
                        style: TextStyle(fontFamily: 'cursive', fontSize: 48),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      TextField(
                        onChanged: (val) {
                          _email = val;
                        },
                        decoration:
                            InputDecoration(hintText: "Enter your email"),
                      ),
                      TextField(
                        onChanged: (val) {
                          _password = val;
                        },
                        obscureText: true,
                        decoration:
                            InputDecoration(hintText: "Enter your password"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.033,
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            logingin = true;
                          });
                          _performLogin(_email, _password);
                        },
                        color: Colors.black45,
                        child: Text("Login"),
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.033,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("New user? "),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()));
                              },
                              child: Text(
                                "create account",
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
