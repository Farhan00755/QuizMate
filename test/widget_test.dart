import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_mate/constants/app_colors.dart';
import 'package:quiz_mate/data/questions.dart';
import 'package:quiz_mate/main.dart';
import 'package:quiz_mate/screens/home_screen.dart';
import 'package:quiz_mate/screens/quiz_screen.dart';
import 'package:quiz_mate/screens/result_screen.dart';

Future<void> answerAllQuestions(WidgetTester tester) async {
  for (var i = 0; i < quizQuestions.length; i++) {
    final question = quizQuestions[i];
    final correctOption = find.text(question.options[question.correctIndex]);

    await tester.ensureVisible(correctOption);
    await tester.pumpAndSettle();
    await tester.tap(correctOption);
    await tester.pump();

    await tester.tap(
      find.text(i == quizQuestions.length - 1 ? 'Selesai' : 'Soal berikutnya'),
    );
    await tester.pumpAndSettle();
  }
}

Future<void> startQuiz(WidgetTester tester, {String name = 'Budi'}) async {
  await tester.enterText(find.byType(TextFormField).first, name);
  await tester.tap(find.text('Mulai Kuis'));
  await tester.pumpAndSettle();
}

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
    await startQuiz(tester);

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

  testWidgets('Menyelesaikan kuis menampilkan Result Screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: QuizScreen(playerName: 'Budi')),
    );
    await answerAllQuestions(tester);

    expect(find.byType(ResultScreen), findsOneWidget);
    expect(
      find.text('${quizQuestions.length} / ${quizQuestions.length}'),
      findsOneWidget,
    );
    expect(find.text('Kerja bagus, Budi!'), findsOneWidget);
  });

  testWidgets('Ulangi Kuis dari Result Screen kembali ke Home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await startQuiz(tester);
    await answerAllQuestions(tester);

    await tester.tap(find.text('Ulangi Kuis'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(ResultScreen), findsNothing);
    expect(find.byType(QuizScreen), findsNothing);
  });

  testWidgets('Tombol back di Result Screen kembali ke Home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await startQuiz(tester);
    await answerAllQuestions(tester);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(ResultScreen), findsNothing);
  });

  testWidgets('Aplikasi memakai AppTheme dan menampilkan Home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const QuizMateApp());

    expect(find.byType(HomeScreen), findsOneWidget);

    final theme = Theme.of(tester.element(find.byType(HomeScreen)));
    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.textTheme.bodyMedium?.fontFamily, 'Roboto');
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
