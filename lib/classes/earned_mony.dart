// ignore_for_file: avoid_print

import 'package:babalhara/consts/enums.dart';

import 'mony.dart';

class EarnedMony extends Mony {
  EarnedMony(
      {required DateTime date,
      required int value,
      required String description,
      required MonyType type})
      : super(date: date, value: value, description: description, type: type);
}
