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
    return SafeArea(
      child: Container(
        decoration: kAppBarDecoration, // add shadow
        margin: kAppBarPadding,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: BottomAppBar(
            // shape: CircularNotchedRectangle(),
            elevation: 4.0,
            notchMargin: 5,
            height: 70,
            color: Theme.of(context).colorScheme.onBackground,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                items.length,
                (index) => IconButton(
                  onPressed: items[index].onTap,
                  icon: items[index].icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
