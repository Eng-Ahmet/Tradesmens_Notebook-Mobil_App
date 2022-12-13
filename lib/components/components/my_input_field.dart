// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_print, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names

import 'package:babalhara/providers/controller_provider.dart';
import 'package:babalhara/consts/enums.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MyInputsField extends StatelessWidget {
  MyInputsField(
      {required this.label,
      required this.functionType,
      required this.valueFocusNode,
      required this.desFocusNode,
      this.lastField = false});
  final String label;
  final MonyType functionType;
  bool lastField;
  String valueInput = "";
  String descriptionInput = "";

  TextEditingController valueText_ctr = TextEditingController();
  TextEditingController descriptionText_ctr = TextEditingController();

  FocusNode valueFocusNode;
  FocusNode desFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyText2),
          TextField(
            controller: valueText_ctr,
            focusNode: valueFocusNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "${getLang(context, "theAmount")}",
                border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(10))),
            onChanged: (value) {
              valueInput = value;
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionText_ctr,
            focusNode: desFocusNode,
            scrollController: ScrollController(),
            maxLines: 2,
            minLines: 1,
            decoration: InputDecoration(
                labelText: "${getLang(context, "description")}",
                border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular(10))),
            onChanged: (value) {
              descriptionInput = value;
            },
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              child: Icon(Icons.add),
              onPressed: () => addValue(context),
            ),
          ),
          lastField ? Container() : SizedBox(height: 40),
          lastField ? Container() : Divider(),
        ],
      ),
    );
  }

  addValue(BuildContext context) {
    try {
      var newNum = int.parse(valueInput);
      //clear text field
      valueText_ctr.clear();
      descriptionText_ctr.clear();

      FocusScope.of(context).unfocus();
      if (functionType == MonyType.expenses) {
        Provider.of<ControllerProvider>(context, listen: false).addMony(
            monyType: MonyType.expenses,
            newValue: newNum,
            description: descriptionInput);
      } else if (functionType == MonyType.purchases) {
        Provider.of<ControllerProvider>(context, listen: false).addMony(
            monyType: MonyType.purchases,
            newValue: newNum,
            description: descriptionInput);
      } else if (functionType == MonyType.earnedMony) {
        Provider.of<ControllerProvider>(context, listen: false).addMony(
            monyType: MonyType.earnedMony,
            newValue: newNum,
            description: descriptionInput);
      }
      Fluttertoast.showToast(msg: getLang(context, "succesMonyAdd"));
    } catch (e) {
      print("----An Error ($valueInput)=>  $e");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text("${getLang(context, "emptyField")}",
                    style: Theme.of(context).textTheme.headline5),
                content: Text("${getLang(context, "fillTheFiledAndTryAgain")}"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("${getLang(context, "ok")}",
                          style: Theme.of(context).textTheme.headline6))
                ],
              ));
    }
  }
}
