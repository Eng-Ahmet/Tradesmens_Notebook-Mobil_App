// ignore_for_file: camel_case_types, avoid_print

import 'package:babalhara/classes/mony.dart';
import 'package:babalhara/consts/enums.dart';

class Purchases extends Mony {
  Purchases(
      {required DateTime date, required int value, required String description,required MonyType type})
      : super(date: date, value: value, description: description,type: type);
}
