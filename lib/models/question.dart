/// Model untuk satu soal kuis pilihan ganda.
class Question {
  const Question({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  /// Teks pertanyaan yang ditampilkan ke pengguna.
  final String question;

  /// Daftar pilihan jawaban.
  final List<String> options;

  /// Indeks jawaban benar di dalam [options].
  final int correctIndex;

  /// Teks jawaban benar, memudahkan saat menampilkan hasil nanti.
  String get correctAnswer => options[correctIndex];
}
