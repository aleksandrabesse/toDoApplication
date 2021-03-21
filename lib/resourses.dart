
import 'package:flutter/material.dart';

String getTask(int i) {
  String current = ' task';
  if (i % 10 == 1 && i != 11) {
    current = ' задача';
  } else if ((i % 10 == 2 || i % 10 == 3 || i % 10 == 4) && i>=21)
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
      month = "января";
      break;
    case 2:
      month = "февраля";
      break;
    case 3:
      month = "марта";
      break;
    case 4:
      month = "апреля";
      break;
    case 5:
      month = "мая";
      break;
    case 6:
      month = "июня";
      break;
    case 7:
      month = "июля";
      break;
    case 8:
      month = "августа";
      break;
    case 9:
      month = "сентября";
      break;
    case 10:
      month = "октября";
      break;
    case 11:
      month = "ноября";
      break;
    case 12:
      month = "декабря";
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
  [const Color(0xFFEEBD89), const Color(0xFFD13DBD)],
  [const Color(0xFFBB73E0), const Color(0xFFFF8DDB)],
  [const Color(0xFF0CCDA3), const Color(0xFFC1FCD3)],
  [const Color(0xFF9FA5D5), const Color(0xFFE8F5C8)],
  [
    const Color(0xFFEF96C5),
    const Color(0xFFCCFBFF),
  ],
  [const Color(0xFFA96F44), const Color(0xFFF2ECB6)],
  [const Color(0xFFED765E), const Color(0xFFE3BDE5)],
  [const Color(0xFF7DC387), const Color(0xFFDBE9EA)],
  [const Color(0xFF6CC6CB), const Color(0xFFEAE5C9)],

  [const Color(0xFFff9a9e), const Color(0xFFfad0c4)],
  [const Color(0xFFa18cd1), const Color(0xFFfbc2eb)],
  [const Color(0xFFfad0c4), const Color(0xFFffd1ff)],
  [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
  [const Color(0xFFfbc2eb), const Color(0xFFa6c1ee)],
  [const Color(0xFFfdcbf1), const Color(0xFFe6dee9)],
  [const Color(0xFFa1c4fd), const Color(0xFFc2e9fb)],
  [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
];

const List<Color> colorsForImportance = [
  const Color(0xff4AD991),
  const Color(0xffFFCA83),
  const Color(0xffFF7285)
];
