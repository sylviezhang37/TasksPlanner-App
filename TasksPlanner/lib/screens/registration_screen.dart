import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/popup_alert.dart';
import '../screens/home_screen.dart';
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
        // Navigator.pushNamed(context, HomePage.id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(previousPageID: 'registration_screen')));
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
        popUpAlert(context, false, kPopupTitle, errorMessage, () {
          Navigator.of(context).pop();
        });
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
                    // left: MediaQuery.of(context).size.width * 0.1,
                    top: MediaQuery.of(context).size.width * 0.8,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.17,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      child: OverflowBox(
                        minWidth: 0.0,
                        minHeight: 0.0,
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/girl-with-map-2.0.png',
                              width: MediaQuery.of(context).size.width * 0.8,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   left: MediaQuery.of(context).size.width * 0.05,
                  //   top: MediaQuery.of(context).size.width * 0.15,
                  //   child: kBackArrowButton(() {Navigator.pop(context);}),
                  // ),
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
                                register();
                              },
                              style: kElevatedButtonStyle,
                              child: const Text(
                                'Register',
                                style: kBodyTextStyleDark,
                              )),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Return',
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
