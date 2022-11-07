// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_full_hex_values_for_flutter_colors

import 'package:babalhara/localization/app_local.dart';
import 'package:babalhara/pages/app_settings_page.dart';
import 'package:babalhara/pages/home_page.dart';
import 'package:babalhara/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/controller_provider.dart';
import 'providers/app_settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ControllerProvider()),
      ChangeNotifierProvider(create: (context) => AppSettingsProvider()),
    ],
    child: MyApp(),
  ));
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: Provider.of<AppSettingsProvider>(context).currentThemeMode,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocale.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale:
          Locale(Provider.of<AppSettingsProvider>(context).currentSelectedLang),
      supportedLocales: [Locale("en", "EN"), Locale("ar"), Locale("tr", "TR")],
      localeResolutionCallback: (currentlang, supportLang) {
        if (currentlang != null) {
          for (var lang in supportLang) {
            if (currentlang.languageCode == lang.languageCode)
              return currentlang;
          }
        }

        return supportLang.first;
      },
      routes: {
        SettingsPage.id: (context) => SettingsPage(),
        LoginPage.id: (context) => LoginPage(),
        HomePage.id: (contect) => HomePage()
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: MaterialColor(0xFF01643B, color),
        appBarTheme: AppBarTheme(color: Color(0xFF00804A)),
        scaffoldBackgroundColor: Color(0xFFF0F0F0),
        textTheme: TextTheme(
            bodyText1: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Color(0xFF570016)),
            bodyText2: TextStyle(
                //normal labels
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Color(0xFF064F94)),
            headline1: TextStyle(
                fontSize: 20,
                color: Color(0xff000000),
                fontWeight: FontWeight.w700), //selectable text iin bottomBar
            headline4: TextStyle(color: Colors.white, fontSize: 30), //headers
            headline5: TextStyle(
                //header in alert dialog
                color: Color(0xFFC90913),
                fontWeight: FontWeight.bold,
                fontSize: 33),
            headline6: TextStyle(
                //buttons texts inside dialog
                color: Color(0xFF18075A),
                fontSize: 20,
                fontWeight: FontWeight.w600),
            button: TextStyle(
                //texts inside buttons
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFFFFF))),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(255, 17, 119, 76),
        primarySwatch: MaterialColor(0xFF03484D, color),
        appBarTheme: AppBarTheme(color: Color.fromARGB(255, 17, 119, 76)),
        scaffoldBackgroundColor: Color(0xff1E1E1E),
        textTheme: TextTheme(
            bodyText1: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDD2222)),
            bodyText2: TextStyle(
                //normal labels
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3AC7FF)),
            headline1: TextStyle(
                fontSize: 20,
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w700), //selectable text iin bottomBar
            headline4: TextStyle(color: Colors.white, fontSize: 30), //headers
            headline5: TextStyle(
                //header in alert dialog
                color: Color(0xFFFF414B),
                fontSize: 33,
                fontWeight: FontWeight.bold),
            headline6: TextStyle(
                //buttons texts inside dialog
                color: Color(0xFF2D88FF),
                fontSize: 20),
            button: TextStyle(
                //texts inside buttons
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFFFFF))),
      ),
      home: LoginPage(),
    );
  }
}
