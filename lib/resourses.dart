import 'package:to_do_application/widgets/task.dart';
import 'package:flutter/material.dart';

String getTask(int i) {
  String current = ' task';
  if (i % 10 == 1) {
    current = ' задача';
  } else if (i % 10 == 2 || i % 10 == 3 || i % 10 == 4)
    current = ' задачи';
  else
    current = ' задач';
  return current;
}

String getProject(int i) {
  String current = ' project';
  if (i % 10 == 1) {
    current = ' проекта';
  } else
    current = ' проектов';
  return current;
}

String date(DateTime tm) {
  String month;
  switch (tm.month) {
    case 1:
      month = "январь";
      break;
    case 2:
      month = "февраль";
      break;
    case 3:
      month = "март";
      break;
    case 4:
      month = "апрель";
      break;
    case 5:
      month = "май";
      break;
    case 6:
      month = "июнь";
      break;
    case 7:
      month = "июль";
      break;
    case 8:
      month = "август";
      break;
    case 9:
      month = "сентябрь";
      break;
    case 10:
      month = "октябрь";
      break;
    case 11:
      month = "ноябрь";
      break;
    case 12:
      month = "декабрь";
      break;
  }
  return month;
}

String weekDay(DateTime tm) {
  String month;
  switch (tm.weekday) {
    case 1:
      month = "пн";
      break;
    case 2:
      month = "вт";
      break;
    case 3:
      month = "ср";
      break;
    case 4:
      month = "чт";
      break;
    case 5:
      month = "пт";
      break;
    case 6:
      month = "сб";
      break;
    case 7:
      month = "вс";
      break;
   
  }
  return month;
}
const List<List<Color>> colors = [
  [const Color(0xFFF9957F), const Color(0xFFF2F5D0)],
  [const Color(0xFF9600FF), const Color(0xFFAEBAF8)],
  [const Color(0xFFEEBD89), const Color(0xFFD13DBD)],
  [const Color(0xFFBB73E0), const Color(0xFFFF8DDB)],
  [const Color(0xFF0CCDA3), const Color(0xFFC1FCD3)],
  [const Color(0xFF849B5C), const Color(0xFFBFFFC7)],
  [const Color(0xFF9FA5D5), const Color(0xFFE8F5C8)],
  [
    const Color(0xFFEF96C5),
    const Color(0xFFCCFBFF),
  ],
  [const Color(0xFFA96F44), const Color(0xFFF2ECB6)],
  [const Color(0xFFED765E), const Color(0xFFE3BDE5)],
  [const Color(0xFF7DC387), const Color(0xFFDBE9EA)],
  [const Color(0xFF6CC6CB), const Color(0xFFEAE5C9)],
];

const List<Color> colorsForImportance = [
  const Color(0xff4AD991),
  const Color(0xffFFCA83),
  const Color(0xffFF7285)
];
