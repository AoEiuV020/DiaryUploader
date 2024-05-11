import 'dart:developer';

import 'package:google_calendar_uploader/google_calendar.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import 'google_calendar_uploader_base.dart';

class GoogleCalendarUploaderImpl implements GoogleCalendarUploader {
  CalendarApi? _api;
  CalendarApi get api => _api!;
  String? _calendarId;
  String get calendarId => _calendarId!;

  @override
  Future<String> insert(int start, int end, String content) async {
    checkClient();
    if (_calendarId == null) {
      throw StateError('require setSelectedCalendar');
    }
    // 创建事件
    final event = Event()
      ..summary = 'Flutter Event'
      ..description = content
      ..start = EventDateTime(
          dateTime: DateTime.fromMillisecondsSinceEpoch(start).toUtc())
      ..end = EventDateTime(
          dateTime: DateTime.fromMillisecondsSinceEpoch(end).toUtc());
    final result = await api.events.insert(event, calendarId);
    log(result.toJson().toString());
    return result.id!;
  }

  @override
  void setSelectedCalendar(GoogleCalendar calendar) {
    _calendarId = calendar.id;
  }

  @override
  Future<List<GoogleCalendar>> list() async {
    checkClient();
    final calendarList = await api.calendarList.list();
    final list = calendarList.items ?? [];
    return list.map((e) => GoogleCalendar(e.id!, e.summary!)).toList();
  }

  @override
  Future<void> init(
    String clientId,
    String clientSecret,
    String accessToken,
    String tokenType,
    String? refreshToken,
  ) async {
    final Client client;
    final access = AccessCredentials(
      AccessToken(tokenType, accessToken, DateTime.now().toUtc()),
      refreshToken,
      ['https://www.googleapis.com/auth/calendar'],
    );
    if (refreshToken == null) {
      client = authenticatedClient(Client(), access);
    } else {
      client = autoRefreshingClient(
        ClientId(clientId, clientSecret),
        access,
        Client(),
      );
    }
    _api = CalendarApi(client);
  }

  void checkClient() {
    if (_api == null) {
      throw StateError('require init');
    }
  }
}
