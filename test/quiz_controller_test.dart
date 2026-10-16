// Unit test untuk QuizController (logika jalannya kuis).

import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_mate/data/questions.dart';
import 'package:quiz_mate/state/quiz_controller.dart';

void main() {
  test('Tidak pindah soal sebelum dijawab', () {
    final controller = QuizController(questions: quizQuestions);
    addTearDown(controller.dispose);

    expect(controller.currentIndex, 0);
    expect(controller.hasAnsweredCurrent, isFalse);
    expect(controller.selectedIndex, -1);

    controller.next();

    expect(controller.currentIndex, 0);
  });

  test('Menyimpan jawaban dan maju ke soal berikutnya', () {
    final controller = QuizController(questions: quizQuestions);
    addTearDown(controller.dispose);

    controller.selectOption(1);
    expect(controller.selectedIndex, 1);
    expect(controller.hasAnsweredCurrent, isTrue);

    controller.next();
    expect(controller.currentIndex, 1);
    expect(controller.selectedIndex, -1);
    expect(controller.hasAnsweredCurrent, isFalse);
  });

  test('Menandai soal terakhir', () {
    final controller = QuizController(questions: quizQuestions);
    addTearDown(controller.dispose);

    expect(controller.isLastQuestion, isFalse);

    for (var i = 0; i < quizQuestions.length - 1; i++) {
      controller.selectOption(0);
      controller.next();
    }

    expect(controller.currentIndex, quizQuestions.length - 1);
    expect(controller.isLastQuestion, isTrue);
    expect(controller.progress, 1.0);
  });
}
