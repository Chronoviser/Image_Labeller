import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signUp({String email, String password}) async {
    AuthResult res = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password).catchError((_) => null);
    if(res == null) {
      return null;
    }
    FirebaseUser user = res.user;
    return user;
  }

  Future<FirebaseUser> login({String email, String password}) async {
    AuthResult res = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password).catchError((_) => null);
    if(res == null) {
      return null;
    }
    FirebaseUser user = res.user;
    return user;
  }

  Future<void> logout() async{
    await firebaseAuth.signOut();
  }
}
