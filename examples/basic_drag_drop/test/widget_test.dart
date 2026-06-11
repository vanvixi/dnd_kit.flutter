import 'package:flutter_test/flutter_test.dart';

import 'package:basic_drag_drop/main.dart';

void main() {
  testWidgets('App renders initial zones and cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BasicDragDropApp());

    expect(find.text('Basic Drag & Drop'), findsOneWidget);
    expect(find.text('Unassigned'), findsOneWidget);
    expect(find.text('Zone A'), findsOneWidget);
    expect(find.text('Zone B'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
    expect(find.text('Green'), findsOneWidget);
    expect(find.text('Yellow'), findsOneWidget);
  });
}
