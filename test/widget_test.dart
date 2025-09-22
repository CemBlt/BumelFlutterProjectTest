import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dis_hastaneleri/main.dart';

void main() {
  testWidgets('App starts with login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Login screen should be displayed initially
    expect(find.text('Hoş Geldiniz'), findsOneWidget);
    expect(find.text('Hesabınıza giriş yapın'), findsOneWidget);
  });
}
