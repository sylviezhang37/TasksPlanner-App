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
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
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
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: -(MediaQuery.of(context).size.width * 0.5) / 2,
                  child: Image.asset(
                    'assets/girl-with-phone-2.0.png',
                    width: MediaQuery.of(context).size.height,
                    // Removing 'height' to let the image maintain its aspect ratio
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.75,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      style: kElevatedButtonStyle,
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: const Text(
                        "Get Started",
                        style: kBodyTextStyleDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
