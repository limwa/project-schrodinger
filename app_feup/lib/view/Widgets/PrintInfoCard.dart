import 'package:app_feup/model/AppState.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:app_feup/view/Theme.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'GenericCard.dart';

class PrintInfoCard extends GenericCard{
  PrintInfoCard({Key key}):super(key: key);

  PrintInfoCard.fromEditingInformation(Key key, bool editingMode, Function onDelete):super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Table(
            columnWidths: {1: FractionColumnWidth(.4)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
                  child: Text("Valor disponível: ",
                      style: TextStyle(
                          color: greyTextColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w100
                      )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, right: 30.0),
                  child: StoreConnector<AppState, String>(
                    converter: (store) => store.state.content["printBalance"],
                    builder: (context, printBalance) => getInfoText(printBalance, context)
                  ),
                ),
              ])
            ]
        ),
        StoreConnector<AppState, String>(
            converter: (store) => store.state.content["printRefreshTime"],
            builder: (context, printRefreshTime) => showLastRefreshedTime(printRefreshTime, context)
        )
      ],
    );
  }

  @override
  String getTitle() => "Impressões";

  @override
  onClick(BuildContext context) {}

}