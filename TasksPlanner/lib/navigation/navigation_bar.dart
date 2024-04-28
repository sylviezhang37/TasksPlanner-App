import 'package:flutter/material.dart';
import '../navigation/nav_bar_item.dart';
import '../utilities/constants.dart';

class CustomNavigationBar extends StatelessWidget {
  final List<NavBarItem> items;

  CustomNavigationBar({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      notchMargin: 5,
      // color: Theme.of(context).colorScheme.secondary,
      color: Colors.white,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              items.length,
              (index) => IconButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        kThemeDataDark.colorScheme.onSurface),
                  ),
                  onPressed: items[index].onTap,
                  icon: items[index].icon))),
    );
  }
}
