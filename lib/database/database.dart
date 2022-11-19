// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, prefer_const_constructors, avoid_print, curly_braces_in_flow_control_structures, prefer_final_fields

import 'package:babalhara/classes/current_user.dart';
import 'package:babalhara/classes/earned_mony.dart';
import 'package:babalhara/classes/expanses.dart';
import 'package:babalhara/classes/global.dart';
import 'package:babalhara/classes/mony.dart';
import 'package:babalhara/classes/profitable.dart';
import 'package:babalhara/classes/purchases.dart';
import 'package:babalhara/consts/enums.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Database {
  static final _fireStore = FirebaseFirestore.instance;
  static List<Mony> _allSelectedMonyList = [];

  static Future<List<Mony>> getMonyByType(MonyType monyType) async {
    _allSelectedMonyList.clear();
    QuerySnapshot<Map<String, dynamic>> data;
    List<QuerySnapshot<Map<String, dynamic>>> allMonyData = [];

    if (monyType == MonyType.allmony) {
      data = await _fireStore
          .collection("users")
          .doc(CurrentUser.id)
          .collection(MonyType.expenses.name)
          .get();
      print(data);
      allMonyData.add(data);
      data = await _fireStore
          .collection("users")
          .doc(CurrentUser.id)
          .collection(MonyType.purchases.name)
          .get();
      allMonyData.add(data);
      data = await _fireStore
          .collection("users")
          .doc(CurrentUser.id)
          .collection(MonyType.earnedMony.name)
          .get();
      allMonyData.add(data);
      data = await _fireStore
          .collection("users")
          .doc(CurrentUser.id)
          .collection(MonyType.profitabel.name)
          .get();
      allMonyData.add(data);

      for (var items in allMonyData)
        for (var item in items.docs)
          addNewMonyToList(getItemType(item["type"]), item);
    } else //get any data by type
    {
      data = await _fireStore.collection(monyType.name).get();

      for (var item in data.docs) addNewMonyToList(monyType, item);
    }
    _allSelectedMonyList.sort((Mony a, Mony b) => a.date.compareTo(b.date));
    return _allSelectedMonyList;
  }

  static void addNewMonyToList(
      MonyType monyType, QueryDocumentSnapshot<Map<String, dynamic>> item) {
    if (monyType == MonyType.expenses)
      _allSelectedMonyList.add(Expenses(
          date: DateTime.parse(item["date"]),
          value: item["value"],
          description: item["description"],
          type: MonyType.expenses));
    else if (monyType == MonyType.purchases)
      _allSelectedMonyList.add(Purchases(
          date: DateTime.parse(item["date"]),
          value: item["value"],
          description: item["description"],
          type: MonyType.purchases));
    else if (monyType == MonyType.earnedMony)
      _allSelectedMonyList.add(EarnedMony(
          date: DateTime.parse(item["date"]),
          value: item["value"],
          description: item["description"],
          type: MonyType.earnedMony));
    else if (monyType == MonyType.profitabel)
      _allSelectedMonyList.add(Profitabel(
          date: DateTime.parse(item["date"]),
          value: item["value"],
          description: item["description"],
          type: MonyType.profitabel));
  }

  static MonyType getItemType(String type) {
    MonyType newType = MonyType.allmony;
    if (type == MonyType.allmony.name)
      newType = MonyType.allmony;
    else if (type == MonyType.expenses.name)
      newType = MonyType.expenses;
    else if (type == MonyType.purchases.name)
      newType = MonyType.purchases;
    else if (type == MonyType.earnedMony.name)
      newType = MonyType.earnedMony;
    else if (type == MonyType.profitabel.name) newType = MonyType.profitabel;
    return newType;
  }

  static void setNewDate(Mony mony) {
    insertToDatabase(
        date: DateFormat('yyyy-MM-dd HH:mm').format(mony.date),
        value: mony.value,
        description: mony.description,
        monyType: mony.type);
    CalculateProfitabel(mony);
  }

  static Future CalculateProfitabel(Mony mony) async {
    //get context from home page
    BuildContext? ctx = myGlobals.scaffoldKey().currentContext;
    late BuildContext context = ctx!;

    QuerySnapshot<Map<String, dynamic>> data = await _fireStore
        .collection("users")
        .doc(CurrentUser.id)
        .collection(MonyType.profitabel.name)
        .get();

    if (mony.type == MonyType.expenses || mony.type == MonyType.purchases)
      mony.value *= -1;

    if (data.docs.isEmpty) {
      //create for new day

      insertToDatabase(
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          value: mony.value,
          description: "${getLang(context, "allProfitabelOfDay")}",
          monyType: MonyType.profitabel);
    } else {
      for (var item in data.docs) {
        if (item["date"] == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          int profitableOfDay = item["value"];
          profitableOfDay += mony.value;

          //? Update On Database
          CollectionReference collectionReference = _fireStore
              .collection("users")
              .doc(CurrentUser.id)
              .collection(MonyType.profitabel.name);

          collectionReference.doc(item.id).update({"value": profitableOfDay});

          break;
        } else {
          //create for new day
          insertToDatabase(
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              value: mony.value,
              description: "${getLang(context, "allProfitabelOfDay")}",
              monyType: MonyType.profitabel);
        }
      }
    }
  }

  static void insertToDatabase(
      {required String date,
      required int value,
      required String description,
      required MonyType monyType}) {
    _fireStore
        .collection("users")
        .doc(CurrentUser.id)
        .collection(monyType.name)
        .add({
      "date": date,
      "value": value,
      "description": description,
      "type": monyType.name
    });
  }

  static Future deleteData(Mony mony) async {
    if (mony.type == MonyType.profitabel) return;

    QuerySnapshot<Map<String, dynamic>> data = await _fireStore
        .collection("users")
        .doc(CurrentUser.id)
        .collection(mony.type.name)
        .get();

    for (var element in data.docs) {
      bool date = element.data()["date"] ==
              DateFormat('yyyy-MM-dd HH:mm').format(mony.date).toString()
          ? true
          : false;
      bool value = element.data()["value"].toString() == mony.value.toString()
          ? true
          : false;
      bool type = element.data()["type"] == mony.type.name ? true : false;
      bool description = element.data()["description"] == mony.description;
      bool same = date && value && type && description;

      if (same) {
        CollectionReference collectionReference = _fireStore
            .collection("users")
            .doc(CurrentUser.id)
            .collection(mony.type.name);

        await collectionReference
            .doc(element.id)
            .delete()
            .then((value) => print("deleted"))
            .catchError((e) => print("error when delete --$e"));

        mony.value *= -1;
        CalculateProfitabel(mony);
      }
    }
  }

  static void updateMarketName(String newMarketName) {
    _fireStore
        .collection("users")
        .doc(CurrentUser.id)
        .update({"marketName": newMarketName});
  }
}
