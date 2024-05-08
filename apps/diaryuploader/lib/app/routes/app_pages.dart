import 'package:get/get.dart';

import '../modules/CalendarList/bindings/calendar_list_binding.dart';
import '../modules/CalendarList/views/calendar_list_view.dart';
import '../modules/DiarySplit/bindings/diary_split_binding.dart';
import '../modules/DiarySplit/views/diary_split_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CALENDAR_LIST,
      page: () => const CalendarListView(),
      binding: CalendarListBinding(),
    ),
    GetPage(
      name: _Paths.DIARY_SPLIT,
      page: () => const DiarySplitView(),
      binding: DiarySplitBinding(),
    ),
  ];
}
