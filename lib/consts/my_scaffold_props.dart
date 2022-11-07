// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:babalhara/classes/current_user.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:babalhara/pages/app_settings_page.dart';
import 'package:babalhara/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

kMyAppBar(String appBarLabel, BuildContext context) {
  return AppBar(
    title: Text(
      appBarLabel,
      style: Theme.of(context).textTheme.headline4,
    ),
    centerTitle: true,
  );
}

class kMyDrawer extends StatelessWidget {
  const kMyDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 35),
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.black,
                      child: Image.network(CurrentUser.photoUrl),
                    ),
                  ),
                  Text(CurrentUser.nickName,
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                  Text(CurrentUser.email,
                      style: TextStyle(fontSize: 15, color: Colors.white))
                ],
              )),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                drawerOption(
                  context: context,
                  title: "${getLang(context, "appSettings")}",
                  icon: Icons.settings,
                  onPress: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(SettingsPage.id);
                  },
                ),
                drawerOption(
                  context: context,
                  title: "${getLang(context, "logOut")}",
                  icon: Icons.login,
                  onPress: () async {
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    await FirebaseAuth.instance.signOut();
                    await googleSignIn.disconnect();
                    await googleSignIn.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginPage.id, (route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget drawerOption(
    {required BuildContext context,
    required VoidCallback onPress,
    required String title,
    required IconData icon}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      shadowColor: Color.fromARGB(255, 143, 177, 144),
      child: InkWell(
        onTap: onPress,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(title, style: Theme.of(context).textTheme.bodyText2),
              ),
            ),
            Expanded(child: Icon(icon, color: Theme.of(context).primaryColor))
          ],
        ),
      ),
    ),
  );
}
