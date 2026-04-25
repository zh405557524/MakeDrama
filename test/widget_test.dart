import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:make_drama/global.dart';
import 'package:make_drama/main.dart';

void main() {
  setUp(() async {
    Get.reset();
    Get.testMode = true;
    await Global.init();
  });

  testWidgets('AI drama app renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('AI漫剧'), findsOneWidget);
    expect(find.text('让故事动起来'), findsOneWidget);
    expect(find.text('+  开始创作  ›'), findsOneWidget);
  });
}
