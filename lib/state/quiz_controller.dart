import 'package:flutter/foundation.dart';

import '../models/question.dart';

/// Mengelola state jalannya kuis: soal aktif, jawaban pengguna, dan progres.
///
/// Logika dipisahkan dari widget agar dapat diuji dan dikembangkan tanpa
/// mengubah tampilan. Memakai [ChangeNotifier] bawaan Flutter sehingga tidak
/// memerlukan package tambahan.
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

  /// Indeks opsi yang dipilih pada soal aktif, atau `-1` bila belum dijawab.
  int get selectedIndex => _answers[_currentIndex] ?? -1;

  /// `true` bila soal aktif sudah dijawab.
  bool get hasAnsweredCurrent => _answers[_currentIndex] != null;

  /// Progres kuis bernilai 0..1.
  double get progress =>
      totalQuestions == 0 ? 0 : (_currentIndex + 1) / totalQuestions;

  /// Menyimpan pilihan pengguna untuk soal aktif.
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

  /// Pindah ke soal berikutnya.
  ///
  /// Tidak melakukan apa-apa bila soal aktif belum dijawab atau sudah
  /// berada di soal terakhir.
  void next() {
    if (!hasAnsweredCurrent || isLastQuestion) {
      return;
    }
    _currentIndex++;
    notifyListeners();
  }
}
