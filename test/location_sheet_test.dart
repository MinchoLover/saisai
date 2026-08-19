import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saisai/core/theme/app_theme.dart';
import 'package:saisai/features/search_flow/presentation/location_page.dart';

void main() {
  testWidgets('위치 입력 패널을 접고 다시 펼칠 수 있다', (tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const LocationPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));

    await tester.drag(
      find.bySemanticsLabel('출발지 입력창 접기'),
      const Offset(0, 600),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNothing);
    expect(find.text('서울역  →  광화문'), findsOneWidget);

    await tester.tap(find.text('서울역  →  광화문'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));
  });
}
