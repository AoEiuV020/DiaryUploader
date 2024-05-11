import '../google_calendar.dart';
import 'google_calendar_uploader_impl.dart';

/// Checks if you are awesome. Spoiler: you are.
abstract class GoogleCalendarUploader {
  factory GoogleCalendarUploader() => GoogleCalendarUploaderImpl();
  Future<void> init(
    String clientId,
    String clientSecret,
    String accessToken,
    String tokenType,
    String? refreshToken,
  );
  Future<List<GoogleCalendar>> list();
  void setSelectedCalendar(GoogleCalendar calendar);
  Future<String> insert(int start, int end, String content);
}
