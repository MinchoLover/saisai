import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'app/app.dart';
import 'core/map/naver_map_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (NaverMapConfig.isConfigured) {
    await FlutterNaverMap().init(
      clientId: NaverMapConfig.clientId,
      onAuthFailed: (exception) {
        debugPrint('Naver Map authentication failed: $exception');
      },
    );
  }
  runApp(const SaisaiApp());
}
