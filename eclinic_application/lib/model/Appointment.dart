import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String Day;
  DateTime startTime;
  DateTime endTime;
  String projectName;
 List students ;


  Appointment({
    required this.id,
    required this.Day,
    required this.startTime,
    required this.endTime,
   required this.projectName,
   required this.students,    
  });

@override
  String toString() {
    // TODO: implement toString
      String srting = "Day ${Day} Date:${startTime.year}/${startTime.month}/${startTime.day} time: ${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute} \n";
    return srting;
  }

String StringDate() {
    // TODO: implement toString
      String srting = "${startTime.year}/${startTime.month}/${startTime.day}\n";
    return srting;
  }

String StringTimeRange() {
    // TODO: implement toString
    String srting = "${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}\n";
    return srting;
  }

  String StringStudents() {
    // TODO: implement toString

    String srting = "";
   for (var i = 0; i < students.length; i++) {
    srting= srting+ "${students[i]} - ";
   }
    
    return srting+"\n";
  }






}