import 'package:uni/model/entities/trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/trip_row.dart';
import 'package:uni/view/theme.dart';

class BusStopRow extends StatelessWidget {
  final String stopCode;
  final List<Trip> trips;
  final stopCodeShow;
  final singleTrip;

  BusStopRow({
    Key key,
    @required this.stopCode,
    @required this.trips,
    this.singleTrip = false,
    this.stopCodeShow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(4.0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: this.getTrips(context),
      ),
    );
  }

  List<Widget> getTrips(context) {
    final List<Widget> row =  List<Widget>();

    if (stopCodeShow) {
      row.add(stopCodeRotatedContainer(context));
    }

    if (trips.isEmpty) {
      row.add(noTripsContainer(context));
    } else {
      final List<Widget> tripRows = getTripRows();

      row.add( Expanded(child:  Column(children: tripRows)));
    }

    return row;
  }

  Widget noTripsContainer(context) {
    return Text('Não há viagens planeadas de momento.',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style:
            Theme.of(context).textTheme.display1.apply(color: greyTextColor));
  }

  Widget stopCodeRotatedContainer(context) {
    return  Container(
      padding: EdgeInsets.only(left: 4.0),
      child:  RotatedBox(
        child: Text(this.stopCode,
            style: Theme.of(context)
                .textTheme
                .display1
                .apply(color: primaryColor)),
        quarterTurns: 3,
      ),
    );
  }

  List<Widget> getTripRows() {
    final List<Widget> tripRows =  List<Widget>();

    if (singleTrip) {
      tripRows.add( Container(
          padding: EdgeInsets.all(12.0), child:  TripRow(trip: trips[0])));
    } else {
      for (int i = 0; i < trips.length; i++) {
        Color color = primaryColor;
        if (i == trips.length - 1) color = Colors.transparent;

        tripRows.add( Container(
            padding: EdgeInsets.all(12.0),
            decoration:  BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1, color: color))),
            child:  TripRow(trip: trips[i])));
      }
    }

    return tripRows;
  }
}
