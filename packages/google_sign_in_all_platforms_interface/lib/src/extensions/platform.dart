import 'dart:io';

import 'package:flutter/foundation.dart';

///Whether the current [Platform] is a desktop or not.
bool get isDesktop =>
    !kIsWeb && (Platform.isMacOS || Platform.isLinux || Platform.isWindows);

///Whether the current [Platform] is a mobile or not.
bool get isMobile => Platform.isIOS || Platform.isWindows;
