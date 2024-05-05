import 'package:google_calendar_uploader/google_calender.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis_auth/googleapis_auth.dart';

import 'google_calendar_uploader_base.dart';

class GoogleCalenderUploaderImpl implements GoogleCalenderUploader {
  CalendarApi? _api;
  CalendarApi get api => _api!;

  @override
  Future<void> insert(String calenderId, int start, int end, String content) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<List<GoogleCalender>> list() async {
    checkClient();
    final calendarList = await api.calendarList.list();
    final list = calendarList.items ?? [];
    return list.map((e) => GoogleCalender(e.id!, e.summary!)).toList();
  }

  @override
  Future<void> init(
    String clientId,
    String clientSecret,
    String accessToken,
    String tokenType,
    String refreshToken,
  ) async {
    final client = autoRefreshingClient(
      ClientId(clientId, clientSecret),
      AccessCredentials(
        AccessToken(tokenType, accessToken, DateTime.now().toUtc()),
        refreshToken,
        ['https://www.googleapis.com/auth/calendar'],
      ),
      Client(),
    );
    _api = cal.CalendarApi(client);
  }

  void checkClient() {
    if (_api == null) {
      throw StateError('require init');
    }
  }
}
