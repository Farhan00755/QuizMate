import 'package:flutter/foundation.dart';

import '../models/question.dart';

class QuizController extends ChangeNotifier {
  QuizController({required List<Question> questions})
    : _questions = questions,
      _answers = List<int?>.filled(questions.length, null);

  final List<Question> _questions;
  final List<int?> _answers;

  int _currentIndex = 0;

  List<Question> get questions => _questions;

  int get currentIndex => _currentIndex;

  int get totalQuestions => _questions.length;

  Question get currentQuestion => _questions[_currentIndex];

  bool get isLastQuestion => _currentIndex == _questions.length - 1;

  int get selectedIndex => _answers[_currentIndex] ?? -1;

  bool get hasAnsweredCurrent => _answers[_currentIndex] != null;

  double get progress =>
      totalQuestions == 0 ? 0 : (_currentIndex + 1) / totalQuestions;

  int get answeredCount => _answers.where((answer) => answer != null).length;

  int get correctCount {
    var count = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctIndex) {
        count++;
      }
    }
    return count;
  }

  void selectOption(int index) {
    if (index < 0 || index >= currentQuestion.options.length) {
      return;
    }
    if (_answers[_currentIndex] == index) {
      return;
    }
    _answers[_currentIndex] = index;
    notifyListeners();
  }

  void next() {
    if (!hasAnsweredCurrent || isLastQuestion) {
      return;
    }
    _currentIndex++;
    notifyListeners();
  }
}
