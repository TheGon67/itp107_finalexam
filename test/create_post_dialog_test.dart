import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:post_reader_favorites/widgets/create_post_dialog.dart';
void main() {
  testWidgets('POST dialog rejects empty and whitespace fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CreatePostDialog())));
    await tester.tap(find.text('Send post'));
    await tester.pump();
    expect(find.text('This field cannot be empty.'), findsNWidgets(2));
    await tester.enterText(find.byType(TextFormField).first, '   ');
    await tester.enterText(find.byType(TextFormField).last, '   ');
    await tester.tap(find.text('Send post')); await tester.pump();
    expect(find.text('This field cannot be empty.'), findsNWidgets(2));
  });
}
