// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unnecessary_new, prefer_typing_uninitialized_variables, unnecessary_string_interpolations, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:babalhara/providers/app_settings_provider.dart';
import 'package:babalhara/providers/controller_provider.dart';
import 'package:babalhara/classes/selected_date.dart';
import 'package:babalhara/components/my_table.dart';
import 'package:babalhara/consts/enums.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatefulWidget {
  static String id = "CalculaterScreen";
  CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  Widget selectedTable = Text("");
  late ControllerProvider ctr;
  @override
  void initState() {
    super.initState();
  }

  MonyType selectedMonyType = MonyType.allmony;
  @override
  Widget build(BuildContext context) {
    ctr = Provider.of<ControllerProvider>(context);
    if (selectedTable.runtimeType == Text) {
      selectedTable = Text(
        "${getLang(context, "nothingSelectedYet")}",
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      );
    }
    return ctr.isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.all(0.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  getMyElevatedButton(
                      label: "${getLang(context, "selectSpecificYear")}",
                      tableByHistory: TableByHistory.byYear),
                  getMyElevatedButton(
                      label:
                          "${getLang(context, "selectSpecificYearAndMonth")} ",
                      tableByHistory: TableByHistory.byMonth),
                  getMyElevatedButton(
                      label:
                          "${getLang(context, "selectSpecificYearAndMonthAndDay")}",
                      tableByHistory: TableByHistory.byDay),
                  Divider(),
                  selectedTable
                ],
              ),
            ),
          );
  }

  Widget getMyElevatedButton(
      {required String label, required TableByHistory tableByHistory}) {
    return ElevatedButton(
        onPressed: () {
          resetDateValues();

          showSelectableHistory(tableByHistory: tableByHistory);
        },
        child: Text(label));
  }

  void resetDateValues() {
    SelectedDate.timeMap.values.elementAt(0).dateValue =
        DateTime.now().year.toString();

    SelectedDate.timeMap.values.elementAt(1).dateValue =
        DateFormat('MM').format(DateTime.now());

    SelectedDate.timeMap.values.elementAt(2).dateValue =
        DateFormat('dd').format(DateTime.now());

    selectedMonyType = MonyType.allmony;
  }

  void showSelectableHistory({required TableByHistory tableByHistory}) {
    if (tableByHistory == TableByHistory.all) {
      selectedTable = MyTable(
        monyType: MonyType.allmony,
        tableByHistory: TableByHistory.all,
      );
      setState(() {});
    } else if (tableByHistory == TableByHistory.byYear) {
      getModalBottomSheet(
          labels: ["${getLang(context, "selectYear")}"],
          timeTypes: [SelectedDate.timeMap.values.elementAt(0)],
          tableByHistory: TableByHistory.byYear);
    } else if (tableByHistory == TableByHistory.byMonth) {
      getModalBottomSheet(labels: [
        "${getLang(context, "selectYear")}",
        "${getLang(context, "selectMonth")}"
      ], timeTypes: [
        SelectedDate.timeMap.values.elementAt(0),
        SelectedDate.timeMap.values.elementAt(1)
      ], tableByHistory: TableByHistory.byMonth);
    } else if (tableByHistory == TableByHistory.byDay) {
      getModalBottomSheet(labels: [
        "${getLang(context, "selectYear")}",
        "${getLang(context, "selectMonth")}",
        "${getLang(context, "selectDay")}"
      ], timeTypes: [
        SelectedDate.timeMap.values.elementAt(0),
        SelectedDate.timeMap.values.elementAt(1),
        SelectedDate.timeMap.values.elementAt(2)
      ], tableByHistory: TableByHistory.byDay);
    }
  }

  getModalBottomSheet(
      {required List<String> labels,
      required List<TimeType> timeTypes,
      required TableByHistory tableByHistory}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, bottomSheetSetState) {
              String selectedHistoryHeader = "";
              for (var item in timeTypes) {
                if (selectedHistoryHeader == "")
                  selectedHistoryHeader += item.dateValue;
                else
                  selectedHistoryHeader += " - " + item.dateValue;
              }
              return Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    header(selectedHistoryHeader: selectedHistoryHeader),
                    ...getSelectableTimeMenu(
                        labels: labels,
                        timeTypes: timeTypes,
                        newSetState: bottomSheetSetState),
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (Provider.of<AppSettingsProvider>(context)
                                  .currentSelectedLang ==
                              "ar") ...[
                            setDropDownForMony(
                                bottomSheetSetState: bottomSheetSetState),
                            setLabel(
                                label: "${getLang(context, "selectmonyType")}"),
                          ] else ...[
                            setLabel(
                                label: "${getLang(context, "selectmonyType")}"),
                            setDropDownForMony(
                                bottomSheetSetState: bottomSheetSetState),
                          ]
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("${getLang(context, "close")}",
                                style: Theme.of(context).textTheme.bodyText2),
                            style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(120, 60)))),
                        OutlinedButton(
                          onPressed: () {
                            selectedTable = MyTable(
                                monyType: selectedMonyType,
                                tableByHistory: tableByHistory);
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Text("${getLang(context, "confirm")}",
                              style: Theme.of(context).textTheme.bodyText2),
                          style: ButtonStyle(
                              minimumSize:
                                  MaterialStateProperty.all(Size(120, 60))),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Widget header({required String selectedHistoryHeader}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Text(selectedHistoryHeader,
          style: Theme.of(context).textTheme.bodyText2),
    );
  }

  List<Widget> getSelectableTimeMenu(
      {required List<String> labels,
      required List<TimeType> timeTypes,
      required var newSetState}) {
    List<Widget> selectibleTimeList = [];

    for (int i = 0; i < timeTypes.length; i++) {
      selectibleTimeList.add(Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (Provider.of<AppSettingsProvider>(context).currentSelectedLang ==
                "ar") ...[
              setDropDown(timeType: timeTypes[i], newSetState: newSetState),
              setLabel(label: labels[i]),
            ] else ...[
              setLabel(label: labels[i]),
              setDropDown(timeType: timeTypes[i], newSetState: newSetState),
            ]
          ],
        ),
      ));
    }
    return selectibleTimeList;
  }

  Widget setLabel({required String label}) {
    return Expanded(
      child: Center(
          child: Text(label, style: Theme.of(context).textTheme.headline1)),
    );
  }

  Widget setDropDown({required TimeType timeType, var newSetState}) {
    return Expanded(
      child: Center(
        child: DropdownButton<String>(
          isDense: true,
          value: timeType.dateValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: timeType.dateList.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: TextStyle(fontSize: 20)),
            );
          }).toList(),
          onChanged: (newValue) {
            timeType.dateValue = newValue!;
            newSetState(() {});
          },
        ),
      ),
    );
  }

  Widget setDropDownForMony({required bottomSheetSetState}) {
    return Expanded(
      child: Center(
        child: DropdownButton<MonyType>(
          value: selectedMonyType,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: MonyType.values.map((MonyType item) {
            String itemStr = item.toString();
            if (item == MonyType.allmony)
              itemStr = "${getLang(context, "allMony")}";
            else if (item == MonyType.expenses)
              itemStr = "${getLang(context, "expenses")}";
            else if (item == MonyType.purchases)
              itemStr = "${getLang(context, "purchases")}";
            else if (item == MonyType.earnedMony)
              itemStr = "${getLang(context, "earnedMony")}";
            else if (item == MonyType.profitabel)
              itemStr = "${getLang(context, "profitabel")}";
            return DropdownMenuItem(
              value: item,
              child: Text(itemStr, style: TextStyle(fontSize: 20)),
            );
          }).toList(),
          onChanged: (newValue) {
            selectedMonyType = newValue!;
            bottomSheetSetState(() {});
          },
        ),
      ),
    );
  }
}
