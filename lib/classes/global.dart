import 'package:flutter/widgets.dart';

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  late GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }

  GlobalKey scaffoldKey() => _scaffoldKey;
}
