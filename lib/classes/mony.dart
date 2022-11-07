import 'package:babalhara/consts/enums.dart';

class Mony {
  Mony(
      {required this.date,
      this.value = 0,
      this.description = "",
      this.type = MonyType.allmony});

  DateTime date;
  int value;
  String description;
  MonyType type;
}
