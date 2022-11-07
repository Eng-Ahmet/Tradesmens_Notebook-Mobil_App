// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:babalhara/classes/current_user.dart';
import 'package:babalhara/consts/my_scaffold_props.dart';
import 'package:babalhara/database/database.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String id = "LoginPage";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  void initState() {
    super.initState();
    readDateFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: kMyAppBar("${getLang(context, "loginPage")}", context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.greenAccent, Color.fromARGB(255, 31, 63, 82)]),
          ),
          child: Center(
              child: SizedBox(
                  height: 60,
                  child: InkWell(
                      onTap: signIn,
                      child: Image.asset("images/google_signin_button.png")))),
        ),
      ),
    );
  }

  void readDateFromLocal() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isSignedIn = await googleSignIn.isSignedIn();
    if (isSignedIn) {
      //signedIn before on current divice
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(preferences.getString("id").toString())
          .get();

      CurrentUser.setUserProperities(
          newId: doc["id"],
          newNickName: doc["nickName"],
          newEmail: doc["email"],
          newPhotoUrl: doc["photoUrl"],
          newMarketName: doc["marketName"]);

      Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
    }
    setState(() {
      isLoading = false;
    });
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });

    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    User? firebaseUser =
        (await FirebaseAuth.instance.signInWithCredential(googleAuthCredential))
            .user;

    if (firebaseUser != null) {
      //signIn secces
      var quarySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: firebaseUser.uid)
          .get();

      if (quarySnapshot.docs.isEmpty) {
        //new user
        FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .set({
          "nickName": firebaseUser.displayName,
          "email": firebaseUser.email,
          "id": firebaseUser.uid,
          "photoUrl": firebaseUser.photoURL,
          "marketName": getLang(context, "marketName")
        });

        //set data to local
        await setDateToLocal(
            nickname: firebaseUser.displayName.toString(),
            email: firebaseUser.email.toString(),
            id: firebaseUser.uid.toString(),
            photoUrt: firebaseUser.photoURL.toString(),
            marketName: getLang(context, "marketName"));
      } else {
        //user signedIn to database before
        DocumentSnapshot oldUser = quarySnapshot.docs.first;
        await setDateToLocal(
            nickname: oldUser["nickName"],
            email: oldUser["email"],
            id: oldUser["id"],
            photoUrt: oldUser["photoUrl"],
            marketName: oldUser["marketName"]);
      }

      Fluttertoast.showToast(msg: getLang(context, "loginSucces"));
      Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
    } else {
      //signIn field
      Fluttertoast.showToast(msg: getLang(context, "loginField"));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future setDateToLocal({
    required String nickname,
    required String email,
    required String id,
    required String photoUrt,
    required String marketName,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("nickName", nickname);
    preferences.setString("email", email);
    preferences.setString("id", id);
    preferences.setString("photoUrl", photoUrt);

    await CurrentUser.setUserProperities(
        newId: id,
        newEmail: email,
        newNickName: nickname,
        newPhotoUrl: photoUrt,
        newMarketName: marketName);
  }
}
