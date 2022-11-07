// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:babalhara/classes/mony.dart';
import 'package:babalhara/classes/selected_date.dart';
import 'package:babalhara/consts/enums.dart';
import 'package:babalhara/database/database.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTable extends StatefulWidget {
  TableByHistory tableByHistory;

  MonyType monyType;

  MyTable({required this.monyType, required this.tableByHistory});

  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  final List<TableRow> _tableRowList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDateFromDB(),
      builder: (context, AsyncSnapshot<List<Mony>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LinearProgressIndicator();
        if (snapshot.hasData) {
          updateTableFields(snapshot.data ?? []);
          return Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(borderRadius: BorderRadius.circular(10)),
            children: _tableRowList,
          );
        } else if (snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        } else
          return Container();
      },
    );
  }

  updateTableFields(List<Mony> monyList) {
    _tableRowList.clear();
    //add table header
    _tableRowList.add(
      TableRow(
        children: [
          Text("${getLang(context, "date")}",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center),
          Text("${getLang(context, "theAmount")}",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center),
          Text("${getLang(context, "type")}",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center),
          Text("${getLang(context, "description")}",
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center),
        ],
      ),
    );

    for (var item in monyList) {
      _tableRowList.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: getTableRowCell(
                  DateFormat('yyyy-MM-dd H:m').format(item.date), item),
            ),
            getTableRowCell(item.value.toString(), item),
            getTableRowCell(translateToAR(item.type.name), item),
            getTableRowCell(item.description, item),
          ],
        ),
      );
    }
  }

  String translateToAR(String enWord) {
    String arWord = "";
    if (enWord == MonyType.expenses.name)
      arWord = "${getLang(context, "expenses")}";
    else if (enWord == MonyType.purchases.name)
      arWord = "${getLang(context, "purchases")}";
    else if (enWord == MonyType.earnedMony.name)
      arWord = "${getLang(context, "earnedMony")}";
    else if (enWord == MonyType.profitabel.name)
      arWord = "${getLang(context, "profitabel")}";

    return arWord;
  }

  Widget getTableRowCell(String label, Mony item) {
    return TableRowInkWell(
      child: Text(
        label,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
      onLongPress: () {
        showDeleteDialog(item);
      },
    );
  }

  void showDeleteDialog(Mony item) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              alignment: Alignment.center,
              title: Center(
                child: Text("${getLang(context, "deleteData")}",
                    style: Theme.of(context).textTheme.headline5),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("${getLang(context, "realyWantToDelete")}",
                        textAlign: TextAlign.center),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder.all(
                          borderRadius: BorderRadius.circular(10)),
                      children: [
                        TableRow(children: [
                          Text("${getLang(context, "description")}",
                              textAlign: TextAlign.center),
                          Text("${getLang(context, "type")}",
                              textAlign: TextAlign.center),
                          Text("${getLang(context, "theAmount")}",
                              textAlign: TextAlign.center),
                          Text("${getLang(context, "date")}",
                              textAlign: TextAlign.center),
                        ]),
                        TableRow(children: [
                          Text(item.description, textAlign: TextAlign.center),
                          Text(translateToAR(item.type.name),
                              textAlign: TextAlign.center),
                          Text(item.value.toString(),
                              textAlign: TextAlign.center),
                          Text(DateFormat('yyyy-MM-dd H:m').format(item.date),
                              textAlign: TextAlign.center),
                        ])
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      await Database.deleteData(item);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text("${getLang(context, "confirm")}",
                        style: Theme.of(context).textTheme.headline6)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("${getLang(context, "close")}",
                        style: Theme.of(context).textTheme.headline6)),
              ],
            ));
  }

  Future<List<Mony>> getDateFromDB() async {
    List<Mony> allProfitabelList =
        await Database.getMonyByType(widget.monyType);
    return getWantedMonyList(allProfitabelList, widget.tableByHistory);
  }

  List<Mony> getWantedMonyList(
      List<Mony> allMonyList, TableByHistory tableByHistory) {
    List<Mony> wantedList = [];
    switch (tableByHistory) {
      case TableByHistory.all:
        wantedList.addAll(allMonyList);
        break;

      case TableByHistory.byYear:
        int selectedYear =
            int.parse(SelectedDate.timeMap.values.elementAt(0).dateValue);

        for (var item in allMonyList)
          if (item.date.year == selectedYear) wantedList.add(item);
        break;

      case TableByHistory.byMonth:
        int selectedYear =
            int.parse(SelectedDate.timeMap.values.elementAt(0).dateValue);
        int selectedMonth =
            int.parse(SelectedDate.timeMap.values.elementAt(1).dateValue);

        for (var item in allMonyList)
          if (item.date.year == selectedYear &&
              item.date.month == selectedMonth) wantedList.add(item);
        break;

      case TableByHistory.byDay:
        int selectedYear =
            int.parse(SelectedDate.timeMap.values.elementAt(0).dateValue);
        int selectedMonth =
            int.parse(SelectedDate.timeMap.values.elementAt(1).dateValue);
        int selectedDay =
            int.parse(SelectedDate.timeMap.values.elementAt(2).dateValue);

        for (var item in allMonyList)
          if (item.date.year == selectedYear &&
              item.date.month == selectedMonth &&
              item.date.day == selectedDay) wantedList.add(item);

        break;

      default:
    }
    return wantedList;
  }
}
