class Question {
  const Question({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  final String question;
  final List<String> options;
  final int correctIndex;

  String get correctAnswer => options[correctIndex];
}
