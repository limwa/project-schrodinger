import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/Lecture.dart';
import 'package:app_feup/view/Widgets/DateRectangle.dart';
import 'package:app_feup/view/Widgets/GenericCard.dart';
import 'package:app_feup/view/Widgets/RequestDependentWidgetBuilder.dart';
import 'package:app_feup/view/Widgets/ScheduleSlot.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../../utils/Constants.dart' as Constants;

class ScheduleCard extends GenericCard {

  ScheduleCard({Key key}) : super(key: key);

  ScheduleCard.fromEditingInformation(Key key, bool editingMode, Function onDelete):super.fromEditingInformation(key, editingMode, onDelete);

  final double borderRadius = 12.0;
  final double leftPadding = 12.0;
  final List<Lecture> lectures = new List<Lecture>();

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, Tuple2<List<Lecture>, RequestStatus>>(
        converter: (store) => Tuple2(store.state.content['schedule'], store.state.content['scheduleStatus']),
        builder: (context, lecturesInfo) {
          return RequestDependentWidgetBuilder(
              context: context,
              status: lecturesInfo.item2,
              contentGenerator: generateSchedule,
              content: lecturesInfo.item1,
              contentChecker: lecturesInfo.item1 != null && lecturesInfo.item1.length > 0,
              onNullContent: Center(
                                child:
                                 Text("Não existem aulas para apresentar",
                                  style: Theme.of(context).textTheme.display1, textAlign: TextAlign.center
                                  )
                                )
          );
        }
    );
  }

  Widget generateSchedule(lectures, context){
    return Container(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: getScheduleRows(context, lectures),
        ));
  }

  List<Widget> getScheduleRows(context, List<Lecture> lectures){

    if (lectures.length >= 2){  // In order to display lectures of the next week
      Lecture lecturefirstCycle = Lecture.clone(lectures[0]);
      lecturefirstCycle.day += 7;
      Lecture lecturesecondCycle = Lecture.clone(lectures[1]);
      lecturesecondCycle.day += 7;
      lectures.add(lecturefirstCycle);
      lectures.add(lecturesecondCycle);
    }
    List<Widget> rows = new List<Widget>();

    var now = new DateTime.now();
    var added = 0; // Lectures added to widget
    var lastDayAdded = 0; // Day of last added lecture
    var stringTimeNow = (now.weekday-1).toString().padLeft(2, '0') +

    now.hour.toString().padLeft(2, '0') + ":" +
    now.minute.toString().padLeft(2, '0');  // String with current time within the week

    for(int i = 0; added < 2 && i < lectures.length; i++){
      var stringEndTimeLecture = lectures[i].day.toString().padLeft(2, '0') + lectures[i].endTime; // String with end time of lecture

      if (stringTimeNow.compareTo(stringEndTimeLecture) < 0){

        if (now.weekday - 1 != lectures[i].day && lastDayAdded < lectures[i].day) // If it is a lecture from future days and no date title has been already added
          rows.add(new DateRectangle(date: Lecture.dayName[lectures[i].day % 7]));

        rows.add(createRowFromLecture(context, lectures[i]));
        lastDayAdded = lectures[i].day;
        added++;
      }
    }

    if (rows.length == 0){ // Edge case where there is only one lecture in the week and we already had it this week
      rows.add(new DateRectangle(date: Lecture.dayName[lectures[0].day % 7]));
      rows.add(createRowFromLecture(context, lectures[0]));
    }
    return rows;
  }

  Widget createRowFromLecture(context, lecture){
    return new Container (
        margin: EdgeInsets.only(bottom: 10),
        child: new ScheduleSlot(
          subject: lecture.subject,
          rooms: lecture.room,
          begin: lecture.startTime,
          end: lecture.endTime,
          teacher: lecture.teacher,
          typeClass: lecture.typeClass,
        )
    );
  }

  @override
  String getTitle() => "Horário";

  @override
  onClick(BuildContext context) => Navigator.pushNamed(context, '/' + Constants.NAV_SCHEDULE);
}
