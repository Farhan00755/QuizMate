// Smoke test dasar untuk Home Screen QuizMate.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_mate/screens/home_screen.dart';

void main() {
  testWidgets('Menampilkan elemen utama Home Screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('QuizMate'), findsOneWidget);
    expect(
      find.text('Uji pengetahuanmu dalam beberapa menit.'),
      findsOneWidget,
    );
    expect(find.text('Nama kamu'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mulai Kuis'), findsOneWidget);
  });

  testWidgets('Menampilkan error saat nama kosong', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.tap(find.text('Mulai Kuis'));
    await tester.pump();

    expect(find.text('Nama wajib diisi'), findsOneWidget);
  });
}
