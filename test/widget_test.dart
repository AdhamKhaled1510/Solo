import 'package:flutter_test/flutter_test.dart';
import 'package:mystudy_app/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const MyStudyApp());
    expect(find.text('دراستي'), findsNothing);
  });
}
