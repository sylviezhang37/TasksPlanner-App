import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
Themes
 */
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
  fontFamily: 'Rubik',
  textTheme: GoogleFonts.rubikTextTheme(),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff3E2848), //text on buttons
    onPrimary: Colors.white,
    secondary: Colors.white, //text input dialog
    onSecondary: Color(0xff171E65),
    primaryContainer: Color(0xff5A4EEF), //dismissable background
    secondaryContainer: Color(0xffE2F4A6), //tasks card
    error: Colors.black,
    onError: Colors.white,
    background: Colors.white,
    onBackground: Color(0xffECE4F6), //checked
    surface: Colors.white, //elevated buttons on background
    onSurface: Color(0xff3E2848), //header and subheader
    surfaceVariant: Color(0xffB6E0FF),
    onSurfaceVariant: Color(0xff3E2848),
  ),
);

/*
 Input Dialogs
 */
InputDecoration kInputDecoration(BuildContext context, String hintText) =>
    InputDecoration(
      hintText: hintText,
      hintStyle: kHintTextStyleDark,
      fillColor: Theme.of(context).colorScheme.primary,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.2,
        ),
      ),
    );

InputDecoration kInputDecorationFilled(BuildContext context, String hintText) =>
    InputDecoration(
      filled: true,
      hintText: hintText,
      hintStyle: kHintTextStyleDark,
      fillColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide.none,
      ),
    );

/*
Drop down menu
 */
InputDecoration kMenuBoxDecoration(Icon icon, String hinText) =>
    InputDecoration(
      fillColor: kThemeDataDark.colorScheme.primary,
      prefixIcon: icon,
      hintText: hinText,
      hintStyle: kHintTextStyleDark,
      focusedBorder: kOutlineBorder,
      border: kOutlineBorder,
    );


ButtonStyle kDropDownMenuItemStyle = ButtonStyle(
    textStyle: MaterialStatePropertyAll(kHintTextStyleDark),
    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 30)));

/*
floating app bar
 */
EdgeInsetsGeometry kAppBarPadding = EdgeInsets.only(
  left: 16,
  right: 16,
  bottom: Platform.isAndroid ? 16 : 0,
);

Decoration kAppBarDecoration = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(30)),
  boxShadow: [
    BoxShadow(color: Colors.grey[500]!, spreadRadius: 0, blurRadius: 6)
  ],
  color: Colors.transparent,
);

/*
Text Styles
 */
TextStyle kWelcomeScreenTextStyle =
    kThemeDataDark.textTheme.bodyLarge!.copyWith(
  color: kThemeDataDark.colorScheme.primary,
  fontSize: 62.0,
);

const TextStyle kHPHeaderTextStyle = TextStyle(
  fontSize: 35.0,
  fontWeight: FontWeight.w700,
);

const TextStyle kListHeaderTextStyleDark = TextStyle(
  color: Color(0xff3E2848),
  fontSize: 40.0,
  fontWeight: FontWeight.w700,
);

const TextStyle kHPSubHeaderTextStyle = TextStyle(
  color: Color(0xff3E2848),
  fontSize: 30.0,
  fontWeight: FontWeight.w500,
);

const TextStyle kHPAllTasksTextStyle = TextStyle(
  color: Color(0xff3E2848),
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
);

const TextStyle kBodyTextStyleDark = TextStyle(
  color: Color(0xff3E2848),
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
);

TextStyle kHintTextStyleDark = TextStyle(
  color: kThemeDataDark.colorScheme.primary.withOpacity(0.6),
  fontSize: 18.0,
  fontWeight: FontWeight.w400,
);

TextStyle kHintTextStyleMini = TextStyle(
  color: kThemeDataDark.colorScheme.primary.withOpacity(0.6),
  fontSize: 14.0,
  fontWeight: FontWeight.w300,
  decoration: TextDecoration.underline,
);

TextStyle kDialogTitleTextStyle =
kBodyTextStyleDark.copyWith(fontSize: 25, fontWeight: FontWeight.w500);

TextStyle kDialogActionTextStyle =
kBodyTextStyleDark.copyWith(fontWeight: FontWeight.w500);

/*
 randomized home page task list buttons
 */
enum ColorName { blue, orange, yellow, lilac, pink }
int currentColorIndex = 0;

final Map<ColorName, Color> colorMap = {
  ColorName.blue: const Color(0xffB6E0FF),
  ColorName.orange: const Color(0xffFBD976),
  ColorName.pink: const Color(0xffEEA0FF),
  ColorName.lilac: const Color(0xffC5C7FF),
  ColorName.yellow: const Color(0xffE2F4A6),
};

ButtonStyle kHPTaskListStyleRandom(int index) {
  currentColorIndex = index % 5;
  ColorName currentColorName = ColorName.values[currentColorIndex];
  Color color = colorMap[currentColorName]!;

  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    backgroundColor: color,
  );
}

const EdgeInsetsGeometry kTaskListCardPadding =
EdgeInsets.only(top: 20, bottom: 50);

const EdgeInsetsGeometry kTaskListTilePadding =
EdgeInsets.symmetric(horizontal: 20);

List<BoxShadow> kTaskListBoxShadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 5,
    blurRadius: 7,
    offset: const Offset(0, 3),
  )
];

/*
Custom icon buttons
 */
ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: kThemeDataDark.colorScheme.onBackground.withOpacity(.8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
  ),
);

IconButton customIconButton(Function()? onPressed, Icon icon) =>
    IconButton(onPressed: onPressed, icon: icon);

Icon kBackArrowLeft = Icon(
  Icons.keyboard_arrow_left_rounded,
  size: 60,
  color: kThemeDataDark.colorScheme.primary,
);

Icon kOutArrowRight = Icon(
  Icons.arrow_outward_rounded,
  size: 48,
  color: kThemeDataDark.colorScheme.primary,
);

OutlineInputBorder kOutlineBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: kThemeDataDark.colorScheme.onPrimary,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(30.0)));

Icon kListCardArrow = Icon(
  Icons.keyboard_arrow_right_rounded,
  size: 40,
  color: kThemeDataDark.colorScheme.onSurface,
);

/*
Dividers
*/
Widget kDottedLine = DottedLine(
  direction: Axis.horizontal,
  alignment: WrapAlignment.center,
  lineLength: double.infinity,
  lineThickness: 1.5,
  dashLength: 10.0,
  dashColor: Colors.black,
  dashGradient: const [Colors.black, Colors.grey],
  dashGapLength: 8.0,
  dashGapColor: Colors.transparent,
);

const Divider kDivider = Divider(
  height: 10,
  thickness: 1,
);

/*
Other utility components
 */
String kPopupTitle = "Oops!";

const EdgeInsetsGeometry kHeaderPadding =
EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0, bottom: 30.0);

const SizedBox kSpacing = SizedBox(
  height: 10.0,
);
