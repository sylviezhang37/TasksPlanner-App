import 'package:flutter/material.dart';

ThemeData kThemeDataPurple = ThemeData(
  useMaterial3: true,
  fontFamily: 'Lato',
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff21005C),
    onPrimary: Colors.white,
    secondary: Color(0xffBEA8F9),
    onSecondary: Colors.white,
    primaryContainer: Color(0xff7259AC),
    secondaryContainer: Color(0xffFCDDE7),
    error: Colors.black,
    onError: Colors.white,
    background: Color(0xffEBE2F8),
    onBackground: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xff7259AC),
  ),
);

ThemeData kThemeDataDark = ThemeData(
  useMaterial3: true,
  fontFamily: 'Lato',
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff171E65), //text on buttons
    onPrimary: Colors.white,
    secondary: Colors.white, //text input dialog
    onSecondary: Colors.white,
    primaryContainer: Color(0xff171E65), //floating action button
    secondaryContainer: Color(0xffE2CE0D), //tasks card
    error: Colors.black,
    onError: Colors.white,
    background: Colors.white,
    onBackground: Colors.white, //checked
    // surface: Color(0xff0B3DEC),            //elevated buttons on background
    surface: Colors.white, //elevated buttons on background
    onSurface: Color(0xff171E65), //header and subheader
    // onSurface: Colors.red, //header and subheader
    surfaceVariant: Color(0xff0B3DEC),
    onSurfaceVariant: Colors.white,
  ),
);

// ThemeData kThemeDataPurple = ThemeData(
//   useMaterial3: true,
//   fontFamily: 'Lato',
//   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent)
// );

InputDecoration kInputDecoration(BuildContext context, String hintText) =>
    InputDecoration(
      hintText: hintText,
      fillColor: Theme.of(context).colorScheme.primary,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.2,
        ),
      ),
    );

List<BoxShadow> kTaskListBoxShadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, 3),
  )
];

const BorderRadiusGeometry kTaskListCardRadius = BorderRadius.only(
    topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0));

const EdgeInsetsGeometry kTaskListCardPadding =
    EdgeInsets.symmetric(horizontal: 20.0);

const EdgeInsetsGeometry kHeaderPadding =
    EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0, bottom: 30.0);

const SizedBox kSpacing = SizedBox(
  height: 10.0,
);

const TextStyle kSubtitleTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w400,
);

TextStyle kWelcomeScreenTextStyle =
    kThemeDataDark.textTheme.bodyLarge!.copyWith(
  color: kThemeDataDark.colorScheme.onPrimary,
  fontSize: 57.0,
);

const TextStyle kHeaderTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w700,
);

const TextStyle kHomePageHeaderTextStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.w700,
);

const TextStyle kHomePageSubheaderTextStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w500,
);

TextStyle kdialogActionTextStyle =
    kSubtitleTextStyle.copyWith(fontWeight: FontWeight.w700);

ButtonStyle kHomePageButtonStyleDark = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
  backgroundColor: kThemeDataDark.colorScheme.surfaceVariant,
);

ButtonStyle kHomePageButtonStyleLight = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
);

String kPopupTitle = "Oops!";

// style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//           color: Theme.of(context).colorScheme.onPrimary,
//         ),