// Smoke test dasar untuk Home Screen dan Quiz Screen QuizMate.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_mate/data/questions.dart';
import 'package:quiz_mate/screens/home_screen.dart';
import 'package:quiz_mate/screens/quiz_screen.dart';

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

  testWidgets('Berpindah ke Quiz Screen saat nama diisi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.enterText(find.byType(TextFormField).first, 'Budi');
    await tester.tap(find.text('Mulai Kuis'));
    await tester.pumpAndSettle();

    expect(find.byType(QuizScreen), findsOneWidget);
  });

  testWidgets('Quiz Screen menampilkan soal pertama dan pilihannya', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: QuizScreen(playerName: 'Budi')),
    );

    final first = quizQuestions.first;
    expect(find.text(first.question), findsOneWidget);
    for (final option in first.options) {
      expect(find.text(option), findsOneWidget);
    }
  });

  testWidgets('Pilihan jawaban dapat ditekan', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: QuizScreen(playerName: 'Budi')),
    );

    final option = quizQuestions.first.options[1];
    await tester.tap(find.text(option));
    await tester.pump();

    expect(find.text(option), findsOneWidget);
  });

  testWidgets('Menampilkan progres dan pindah ke soal berikutnya', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: QuizScreen(playerName: 'Budi')),
    );

    expect(find.text('Soal 1 dari ${quizQuestions.length}'), findsOneWidget);

    await tester.tap(find.text(quizQuestions[0].options.first));
    await tester.pump();
    await tester.tap(find.text('Soal berikutnya'));
    await tester.pumpAndSettle();

    expect(find.text('Soal 2 dari ${quizQuestions.length}'), findsOneWidget);
    expect(find.text(quizQuestions[1].question), findsOneWidget);
  });

  test('Data soal lokal valid', () {
    expect(quizQuestions, isNotEmpty);
    for (final question in quizQuestions) {
      expect(question.options.length, greaterThanOrEqualTo(2));
      expect(
        question.correctIndex,
        inInclusiveRange(0, question.options.length - 1),
      );
      expect(question.correctAnswer, isNotEmpty);
    }
  });
}
