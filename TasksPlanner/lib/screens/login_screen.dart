import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/popup_alert.dart';
import '../screens/home_screen.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.1,
                    top: MediaQuery.of(context).size.width * 0.4,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.width * 0.4)),
                      ),
                      child: OverflowBox(
                        minWidth: 0.0,
                        minHeight: 0.0,
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/man-with-phone-2.0.png',
                              width: MediaQuery.of(context).size.width * 0.8,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.25,
                    child: CustomIconButton(
                      () => Navigator.pop(context),
                      kBackArrowLeft,
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(50.0,
                          MediaQuery.of(context).size.height * 0.38, 50, 50),
                      child: Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2),
                          TextField(
                            controller: emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              email = value;
                            },
                            decoration:
                                kInputDecorationFilled(context, "email"),
                          ),
                          const SizedBox(height: 8.0),
                          TextField(
                            controller: passwordTextController,
                            obscureText: true,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration:
                                kInputDecorationFilled(context, "password"),
                          ),
                          const SizedBox(height: 30.0),
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
                              style: kHintTextStyleDark,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
