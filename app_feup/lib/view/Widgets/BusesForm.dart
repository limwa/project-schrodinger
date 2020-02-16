import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/entities/Bus.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BusesForm extends StatefulWidget {
  final String stopCode;
  final Function updateStopCallback;

  BusesForm(this.stopCode, this.updateStopCallback);

  @override
  State<StatefulWidget> createState() {return _BusesFormState(stopCode, updateStopCallback);}
}

class _BusesFormState extends State<BusesForm>{
  final String stopCode;
  final Function updateStopCallback;
  List<Bus> buses = new List();
  final List<bool> busesToAdd = List<bool>.filled(20, false);

  _BusesFormState(this.stopCode, this.updateStopCallback);

  @override
  void initState() {
    getStopBuses();
    super.initState();
  }

  void getStopBuses() async {
    List<Bus> buses = await NetworkRouter.getBusesStoppingAt(stopCode);
    this.setState((){
      this.buses = buses;
      busesToAdd.fillRange(0, buses.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    updateBusStop();
    return ListView(
        children: List.generate(buses.length, (i) {
          return Row(
            children: <Widget>[
              Flexible(
                child: Text('[${buses[i].busCode}] ${buses[i].destination}', overflow: TextOverflow.fade, softWrap: false)
              ),
              Checkbox(value: busesToAdd[i],
                  onChanged: (value) {
                    setState(() {
                      busesToAdd[i] = value;
                    });
                  },
                  activeColor: Theme.of(context).primaryColor
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          );
        })
    );
  }

  void updateBusStop() {
    Set<String> newBuses = new Set();
    for(int i = 0; i < buses.length; i++) {
      if(busesToAdd[i]) {
        newBuses.add(buses[i].busCode);
      }
    }
    updateStopCallback(this.stopCode, new BusStopData(configuredBuses: newBuses, favorited: true));
  }
}