import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../screens/login_screen.dart';
import '../utilities/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: DefaultTextStyle(
                        style: kWelcomeScreenTextStyle,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                                'A simple list for your every day.')
                          ],
                          isRepeatingAnimation: false,
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.32,
                      // centering the image
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/girl-is-sitting-with-a-laptop-on-her-lap.png',
                        width: 105,
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.75,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ElevatedButton(
                          style: kHomePageButtonStyleLight,
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          child: const Text(
                            "Get Started",
                            style: kSubtitleTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
