import 'package:example_gallery/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders gallery navigation and the basic demo', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ExampleGalleryApp());

    expect(find.text('dnd_kit'), findsOneWidget);
    expect(find.text('Basic'), findsOneWidget);
    expect(find.text('Kanban'), findsOneWidget);
    expect(find.text('Multi-container'), findsOneWidget);
    expect(find.text('Basic Drag & Drop'), findsOneWidget);
  });

  testWidgets('switches between demos', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ExampleGalleryApp());
    await tester.tap(find.text('Kanban'));
    await tester.pumpAndSettle();

    expect(find.text('dnd_kit Kanban'), findsOneWidget);
    expect(find.text('Write adoption brief'), findsOneWidget);

    await tester.tap(find.text('Multi-container'));
    await tester.pumpAndSettle();

    expect(find.text('Interactive Board'), findsOneWidget);
    expect(find.text('Design Dark Mode UI'), findsOneWidget);
  });
}
