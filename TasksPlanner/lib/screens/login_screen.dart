import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/popup_alert.dart';
import '../screens/home_page.dart';
import '../screens/registration_screen.dart';
import '../utilities/constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool showSpinner = false;
  String? email;
  String? password;
  final _auth = FirebaseAuth.instance;

  void signIn() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim());
      if (credential != Null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, HomePage.id);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        // Ensure the widget is still in the tree.
        setState(() {
          showSpinner = false;
        });
        String errorMessage = 'An unknown error occurred.';
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for that email. Try again.';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password. Try again.';
            break;
          default:
            break;
        }
        popUpAlert(context, false, kPopupTitle, errorMessage, () {
          Navigator.of(context).pop();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          showSpinner = false;
        });
        emailTextController.clear();
        passwordTextController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (context, snapshot) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 35.0, vertical: 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'smiling-man',
                    child: Container(
                      height: 230.0,
                      child: Image.asset(
                          'assets/matey-smiling-man-sitting-at-the-table-and-waving-her-hand.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: kInputDecoration(context, "email"),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        controller: passwordTextController,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: kInputDecoration(context, "password"),
                      ),
                      const SizedBox(height: 35.0),
                      ElevatedButton(
                        onPressed: () {
                          signIn();
                        },
                        style: kElevatedButtonStyle,
                        child: const Text(
                          "Log In",
                          style: kBodyTextStyleDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Registration.id);
                        },
                        child: Text(
                          'Register',
                          style: kHintTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // }
    // );
  }
}
