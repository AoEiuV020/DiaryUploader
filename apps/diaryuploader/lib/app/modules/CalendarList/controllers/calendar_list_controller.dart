import 'package:get/get.dart';
import 'package:google_calendar_uploader/google_calendar_uploader.dart';
import 'package:google_calendar_uploader/google_calender.dart';

class CalendarListController extends GetxController {
  final GoogleCalenderUploader uploader = Get.find();

  Future<List<GoogleCalender>> list() => uploader.list();
}
