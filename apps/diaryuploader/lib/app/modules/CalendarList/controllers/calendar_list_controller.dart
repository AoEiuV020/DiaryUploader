import 'package:get/get.dart';
import 'package:google_calendar_uploader/google_calendar_uploader.dart';
import 'package:google_calendar_uploader/google_calendar.dart';

class CalendarListController extends GetxController {
  final GoogleCalendarUploader uploader = Get.find();

  Future<List<GoogleCalendar>> list() => uploader.list();
}
