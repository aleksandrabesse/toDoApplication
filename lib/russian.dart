
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
