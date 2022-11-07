// ignore_for_file: avoid_print

import 'package:babalhara/classes/mony.dart';
import 'package:babalhara/consts/enums.dart';

class Expenses extends Mony {
  Expenses(
      {required DateTime date, required int value, required String description,required MonyType type})
      : super(date: date, value: value, description: description,type:type);
}
