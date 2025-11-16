import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_test_utils/flutter_image_test_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'should render an MyApp normally',
    (WidgetTester tester) async {
      provideMockedNetworkImages(() async {
        await tester.pumpWidget(const MyApp());
        expect(find.text('Flutter Demo'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    },
  );
}
