// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, non_constant_identifier_names, use_key_in_widget_constructors, must_be_immutable

import 'package:babalhara/classes/current_user.dart';
import 'package:babalhara/providers/app_settings_provider.dart';
import 'package:babalhara/providers/controller_provider.dart';
import 'package:babalhara/classes/global.dart';
import 'package:babalhara/consts/my_scaffold_props.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:babalhara/screens/add_mony_screen.dart';
import 'package:babalhara/screens/show_all_data.dart';
import 'package:babalhara/screens/show__today_date_screen.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> MyScreens = [
  ShowDateScreen(),
  AddMonyScreen(),
  CalculatorScreen(),
];

class HomePage extends StatefulWidget {
  static String id = "HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedScreen = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: myGlobals.scaffoldKey(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedScreen,
          onTap: (newIndex) {
            selectedScreen = newIndex;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_2),
              label: "${getLang(context, "mainPage")}",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_rounded),
                label: "${getLang(context, "addMony")}"),
            BottomNavigationBarItem(
                icon: Icon(Icons.safety_divider),
                label: "${getLang(context, "showData")}"),
          ],
        ),
        appBar: kMyAppBar(CurrentUser.marketName, context),
        drawer: kMyDrawer(),
        body: MyScreens.elementAt(selectedScreen));
  }
}
