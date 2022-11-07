// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:babalhara/database/database.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider with ChangeNotifier {
  late SharedPreferences prefs;
  bool isDarkMode = false;
  String marketName = "";
  String currentSelectedLang = "en";
  ThemeMode currentThemeMode = ThemeMode.light;
  AppSettingsProvider() {
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    //set selected theme mode light/dark
    isDarkMode = prefs.getBool("isDarkMode") ?? false;
    await updateThemeMode(isDarkMode);

    //set selected lang
    String? prefLang = prefs.getString("currentSelectedLang");

    if (prefLang != null && prefLang != "") currentSelectedLang = prefLang;

    notifyListeners();
  }

  Future updateThemeMode(bool newIsDarkMode) async {
    isDarkMode = newIsDarkMode;

    if (isDarkMode)
      currentThemeMode = ThemeMode.dark;
    else
      currentThemeMode = ThemeMode.light;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDarkMode", isDarkMode);
    notifyListeners();
  }

  Future updateMarketName(BuildContext context) async {
    // prefs = await SharedPreferences.getInstance();

    // //get the market name
    // String? savedMarketName = prefs.getString("marketName");
    // marketName = savedMarketName ?? "";
    // if (marketName == "") marketName = getLang(context, "marketName");
    notifyListeners();
  }

  void updateCurrentLang(String newSlectedLang) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("currentSelectedLang", newSlectedLang);
    currentSelectedLang = newSlectedLang;

    notifyListeners();
  }
}
