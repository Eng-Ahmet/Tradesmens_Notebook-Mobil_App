// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:babalhara/providers/controller_provider.dart';
import 'package:babalhara/consts/enums.dart';
import 'package:babalhara/localization/app_local.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ShowDateScreen extends StatefulWidget {
  const ShowDateScreen({Key? key}) : super(key: key);

  @override
  _ShowDateScreenState createState() => _ShowDateScreenState();
}

class _ShowDateScreenState extends State<ShowDateScreen> {
  late ControllerProvider ctr;
  late ControllerProvider ctr1 = ControllerProvider();

  @override
  Widget build(BuildContext context) {
    ctr = Provider.of<ControllerProvider>(context);
    return FutureBuilder(
      future: ctr1.updateTotalOfDay(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: EdgeInsets.all(12),
            child: ModalProgressHUD(
              inAsyncCall: ctr.isLoading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: setLabelsOfDay(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("An Error");
        } else
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> setLabelsOfDay() {
    List<Widget> _list = [];
    _list.add(
      labelOfDay(
          ctr: ctr,
          label: "${getLang(context, "allExpansesOfDay")}",
          monyType: MonyType.expenses),
    );
    _list.add(
      labelOfDay(
          ctr: ctr,
          label: "${getLang(context, "allPurchasesOfDay")}",
          monyType: MonyType.purchases),
    );
    _list.add(
      labelOfDay(
          ctr: ctr,
          label: "${getLang(context, "allEarnedMonyOfDay")}",
          monyType: MonyType.earnedMony),
    );
    _list.add(
      labelOfDay(
          ctr: ctr,
          label: "${getLang(context, "allProfitabelOfDay")}",
          monyType: MonyType.profitabel),
    );
    return _list;
  }

  Widget labelOfDay(
      {required ControllerProvider ctr,
      required String label,
      required MonyType monyType}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyText2),
        Text("${ctr.getTotalsOfDay(monyType: monyType)}",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.bold, color: Color(0xffFF5252))),
      ],
    );
  }
}
