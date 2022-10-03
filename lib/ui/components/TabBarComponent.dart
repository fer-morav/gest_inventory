import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class TabBarComponent extends StatelessWidget {
  final List<Tab> tabs;
  final List<Widget> tabsView;
  final sizeReference = 700.0;

  const TabBarComponent({
    Key? key,
    required this.tabs,
    required this.tabsView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double getResponsiveText(double size) =>
        size * sizeReference / MediaQuery.of(context).size.longestSide;

    TextStyle _textStyle(double size) => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: getResponsiveText(size),
    );

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: TabBar(
          padding: EdgeInsets.symmetric(horizontal: 20),
          labelStyle: _textStyle(18),
          indicatorWeight: 3,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: lightColor,
          tabs: tabs,
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          dragStartBehavior: DragStartBehavior.down,
          children: tabsView,
        ),
      ),
    );
  }
}
