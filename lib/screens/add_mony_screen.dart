// ignore_for_file: prefer_const_constructors,prefer_const_literals_to_create_immutables, avoid_print, curly_braces_in_flow_control_structures, must_be_immutable, use_key_in_widget_constructors

import 'package:babalhara/providers/controller_provider.dart';
import 'package:babalhara/consts/enums.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_input_field.dart';

class AddMonyScreen extends StatelessWidget {
  static String id = "AddMonyScreen";
  int newInput = 0;
  late ControllerProvider ctr;
  List<FocusNode> valueFocusNodes = [FocusNode(), FocusNode(), FocusNode()];
  List<FocusNode> desFocusNodes = [FocusNode(), FocusNode(), FocusNode()];
  @override
  Widget build(BuildContext context) {
    ctr = Provider.of<ControllerProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ctr.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () {
                for (var i = 0; i < valueFocusNodes.length; i++) {
                  valueFocusNodes[i].unfocus();
                  desFocusNodes[i].unfocus();
                }
                print("aaaaaaaaaaa");
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    MyInputsField(
                        label: "${getLang(context, "addExpenses")}",
                        functionType: MonyType.expenses,
                        valueFocusNode: valueFocusNodes[0],
                        desFocusNode: desFocusNodes[0]),
                    MyInputsField(
                        label: "${getLang(context, "addPurchases")}",
                        functionType: MonyType.purchases,
                        valueFocusNode: valueFocusNodes[1],
                        desFocusNode: desFocusNodes[1]),
                    MyInputsField(
                        label: "${getLang(context, "addEarnedMony")}",
                        functionType: MonyType.earnedMony,
                        valueFocusNode: valueFocusNodes[2],
                        desFocusNode: desFocusNodes[2],
                        lastField: true),
                  ],
                ),
              ),
            ),
    );
  }
}
