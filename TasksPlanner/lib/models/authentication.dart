import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  late FirebaseAuth _auth;
  late User currentUser;

  Authentication() {
    _auth = FirebaseAuth.instance;
  }

  FirebaseAuth get auth => _auth;

  void signOut() {
    _auth.signOut();
  }
}
