// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, curly_braces_in_flow_control_structures

import 'package:babalhara/classes/mony.dart';
import 'package:babalhara/consts/enums.dart';
import 'package:babalhara/database/database.dart';
import 'package:flutter/widgets.dart';
import '../classes/earned_mony.dart';
import '../classes/expanses.dart';
import '../classes/purchases.dart';
import 'package:intl/intl.dart';

class ControllerProvider with ChangeNotifier {
  ControllerProvider();

  static int _allExpansesDay = 0;
  static int _allPurchasesDay = 0;
  static int _allEarnedmonyDay = 0;
  static int _allProfitibleOfDay = 0;

  bool isLoading = false;
  void addMony(
      {required MonyType monyType,
      required int newValue,
      required description}) async {
    var newDate = DateTime.now();
    Mony classType = Mony(date: DateTime.now());
    if (monyType == MonyType.expenses)
      classType = Expenses(
          date: newDate,
          description: description,
          value: newValue,
          type: MonyType.expenses);
    else if (monyType == MonyType.purchases)
      classType = Purchases(
          date: newDate,
          description: description,
          value: newValue,
          type: MonyType.purchases);
    else if (monyType == MonyType.earnedMony)
      classType = EarnedMony(
          date: newDate,
          description: description,
          value: newValue,
          type: MonyType.earnedMony);
    Database.setNewDate(classType);
  }

  int getTotalsOfDay({required MonyType monyType}) {
    if (monyType == MonyType.expenses)
      return _allExpansesDay;
    else if (monyType == MonyType.purchases)
      return _allPurchasesDay;
    else if (monyType == MonyType.earnedMony)
      return _allEarnedmonyDay;
    else if (monyType == MonyType.profitabel)
      return _allProfitibleOfDay;
    else
      return 0;
  }

  Future updateTotalOfDay() async {
    isLoading = true;
    List<Mony> data = await Database.getMonyByType(MonyType.allmony);
    _allExpansesDay = 0;
    _allPurchasesDay = 0;
    _allEarnedmonyDay = 0;
    _allProfitibleOfDay = 0;

    for (var item in data) {
      if (DateFormat('yyyy-MM-dd').format(item.date) ==
          DateFormat('yyyy-MM-dd').format(DateTime.now())) {
        if (item.type == MonyType.expenses)
          _allExpansesDay += item.value;
        else if (item.type == MonyType.purchases)
          _allPurchasesDay += item.value;
        else if (item.type == MonyType.earnedMony)
          _allEarnedmonyDay += item.value;
        else if (item.type == MonyType.profitabel)
          _allProfitibleOfDay = item.value;
      }
    }
    isLoading = false;
    notifyListeners();
    return true;
  }
}
