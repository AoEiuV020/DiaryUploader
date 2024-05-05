import '../google_calender.dart';
import 'google_calendar_uploader_impl.dart';

/// Checks if you are awesome. Spoiler: you are.
abstract class GoogleCalenderUploader {
  factory GoogleCalenderUploader() => GoogleCalenderUploaderImpl();
  Future<void> init(
    String clientId,
    String clientSecret,
    String accessToken,
    String tokenType,
    String refreshToken,
  );
  Future<List<GoogleCalender>> list();
  Future<void> insert(String calenderId, int start, int end, String content);
}
