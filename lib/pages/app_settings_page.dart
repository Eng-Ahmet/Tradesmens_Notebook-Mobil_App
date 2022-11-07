// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:babalhara/classes/current_user.dart';
import 'package:babalhara/database/database.dart';
import 'package:babalhara/providers/app_settings_provider.dart';
import 'package:babalhara/consts/my_scaffold_props.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static String id = "SettingsPage";
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController marketnameTextController;

  FocusNode marketNameTextFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    marketnameTextController =
        TextEditingController(text: CurrentUser.marketName);
    return GestureDetector(
      onTap: () => marketNameTextFocusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("${getLang(context, "settingsPage")}",
              style: Theme.of(context).textTheme.headline4),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                child: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
        drawer: kMyDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              elevation: 20,
              child: ListTile(
                trailing: CupertinoSwitch(
                    value: Provider.of<AppSettingsProvider>(context).isDarkMode,
                    onChanged: (newVal) {
                      setState(() {
                        Provider.of<AppSettingsProvider>(context, listen: false)
                            .updateThemeMode(newVal);
                      });
                    }),
                leading: Text(
                  "${getLang(context, "darkMode")}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            SizedBox(height: 10),
            Material(
              elevation: 20,
              child: ListTile(
                leading: Text(
                  "${getLang(context, "marketNameLabel")}",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                trailing: SizedBox(
                  width: 150,
                  child: TextField(
                    maxLength: 16,
                    focusNode: marketNameTextFocusNode,
                    controller: marketnameTextController,
                    decoration: InputDecoration(
                      counterText: "",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Material(
              elevation: 20,
              child: ListTile(
                  leading: Text(
                    "${getLang(context, "currentLang")}",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: DropdownButton<String>(
                    items: [
                      DropdownMenuItem(child: Text("en"), value: "en"),
                      DropdownMenuItem(child: Text("tr"), value: "tr"),
                      DropdownMenuItem(child: Text("ar"), value: "ar")
                    ],
                    value: Provider.of<AppSettingsProvider>(context)
                        .currentSelectedLang,
                    onChanged: (String? newSlectedLang) {
                      Provider.of<AppSettingsProvider>(context, listen: false)
                          .updateCurrentLang(newSlectedLang ?? "");
                      setState(() {});
                    },
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ElevatedButton(
                          child: Text('${getLang(context, "update")}'),
                          onPressed: () => updateData(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 20,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: "${getLang(context, "developedBy")}",
                                style: Theme.of(context).textTheme.bodyText1),
                            TextSpan(
                                text: " ${getLang(context, "ahmetBasmaci")}",
                                style: Theme.of(context).textTheme.bodyText2)
                          ])),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateData() async {
    marketNameTextFocusNode.unfocus();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("marketName", marketnameTextController.text);
    Database.updateMarketName(marketnameTextController.text);
    CurrentUser.copyWith(newMarketName: marketnameTextController.text);
    await Provider.of<AppSettingsProvider>(context, listen: false)
        .updateMarketName(context);

    Fluttertoast.showToast(msg: "${getLang(context, "updateSucces")}");
  }
}
