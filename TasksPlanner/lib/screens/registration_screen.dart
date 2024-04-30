import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/popup_alert.dart';
import '../screens/home_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../models/list_service.dart';
import '../utilities/constants.dart';

class Registration extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _auth = FirebaseAuth.instance;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool showSpinner = false;
  String? email;
  String? password;

  void register() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      if (newUser != Null) {
        ListService().newUserList(_auth.currentUser!.uid);
        Navigator.pushNamed(context, HomePage.id);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage = 'An unknown error occurred.';
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'An account already exists for that email.';
            break;
          default:
            break;
        }
        popUpAlert(context, false, kPopupTitle, errorMessage, () {Navigator.of(context).pop();});
      }
    } finally {
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
      }
      emailTextController.clear();
      passwordTextController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 230.0,
                    child: Image.asset('assets/matey-cyber-security.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 35.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: emailTextController,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kInputDecoration(context, "email"),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  obscureText: true,
                  controller: passwordTextController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kInputDecoration(context, "password"),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  child: Text('Register')),
            ],
          ),
        ),
      ),
    );
  }
}
