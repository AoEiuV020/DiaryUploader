// ignore_for_file: empty_catches

import 'package:intl/intl.dart';

class DateTimeParser {
  final startDateFormat = DateFormat("M月d日");
  final lineTimeWithSecondsFormat = DateFormat("HH:mm:ss");
  final lineTimeFormat = DateFormat("HH:mm");
  DateTime current = DateTime.now();
  (DateTime?, String) parse(String line) {
    line = line.trim();

    // 找到第一个空格的位置
    int spaceIndex = line.indexOf(' ');

    // 根据第一个空格的位置拆分字符串
    String firstPart = line.substring(0, spaceIndex != -1 ? spaceIndex : null);

    (DateTime?, String) result(DateTime date) {
      // 能进入这个方法就说明date正常解析到位了，
      current = date;
      String secondPart =
          spaceIndex != -1 ? line.substring(spaceIndex + 1).trim() : '';
      return (date, secondPart);
    }

    try {
      return result(parseLineWithSecondsTime(firstPart));
    } catch (e) {}
    try {
      return result(parseLineTime(firstPart));
    } catch (e) {}
    try {
      return result(parseStartDate(firstPart));
    } catch (e) {}
    // 到这里说明没解析到时间，
    return (null, line);
  }

  DateTime parseLineTime(String part) {
    final date = lineTimeFormat.parse(part);
    return current.copyWith(hour: date.hour, minute: date.minute, second: 0);
  }

  DateTime parseLineWithSecondsTime(String part) {
    final date = lineTimeWithSecondsFormat.parse(part);
    return current.copyWith(
        hour: date.hour, minute: date.minute, second: date.second);
  }

  DateTime parseStartDate(String part) {
    // 将日期字符串转换为DateTime对象
    final date = startDateFormat.parse(part);
    // 获取当前年份
    int currentYear = DateTime.now().year;
    // 设置年份为当前年份
    return DateTime(currentYear, date.month, date.day);
  }
}
