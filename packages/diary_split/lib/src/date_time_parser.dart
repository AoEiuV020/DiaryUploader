// ignore_for_file: empty_catches

import 'package:intl/intl.dart';

class DateTimeParser {
  final startTimeFormat = DateFormat("M月d日");
  (DateTime?, String) parse(String line) {
    line = line.trim();

    // 找到第一个空格的位置
    int spaceIndex = line.indexOf(' ');

    // 根据第一个空格的位置拆分字符串
    String firstPart = line.substring(0, spaceIndex != -1 ? spaceIndex : null);

    DateTime? date;
    try {
      date = parseStartTime(firstPart);
    } catch (e) {}
    if (date == null) {
      return (null, line);
    }
    String secondPart =
        spaceIndex != -1 ? line.substring(spaceIndex + 1).trim() : '';
    return (date, secondPart);
  }

  DateTime parseStartTime(String part) {
    // 将日期字符串转换为DateTime对象
    var date = startTimeFormat.parse(part);
    // 获取当前年份
    int currentYear = DateTime.now().year;
    // 设置年份为当前年份
    date = DateTime(currentYear, date.month, date.day);
    return date;
  }
}
