import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../data/questions.dart';
import '../models/question.dart';
import '../widgets/primary_button.dart';

const double _contentMaxWidth = 560;

/// Layar kuis yang menampilkan soal pilihan ganda satu per satu.
///
/// Tahap ini menambahkan progres soal ("Soal x dari y" + progress bar) dan
/// perpindahan ke soal berikutnya. Penilaian akhir dan Result Screen akan
/// ditambahkan pada tahap berikutnya.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.playerName});

  /// Nama pengguna dari Home Screen, akan dipakai pada Result Screen nanti.
  final String playerName;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Indeks soal yang sedang ditampilkan.
  int _currentIndex = 0;

  // Jawaban pengguna per soal (indeks opsi), `null` bila belum dijawab.
  final List<int?> _answers = List<int?>.filled(quizQuestions.length, null);

  Question get _currentQuestion => quizQuestions[_currentIndex];

  int get _selectedIndex => _answers[_currentIndex] ?? -1;

  bool get _isLastQuestion => _currentIndex == quizQuestions.length - 1;

  void _selectOption(int index) {
    setState(() {
      _answers[_currentIndex] = index;
    });
  }

  void _handleNext() {
    if (_answers[_currentIndex] == null) {
      return;
    }

    if (_isLastQuestion) {
      // Result Screen akan ditambahkan pada tahap berikutnya.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Semua soal sudah dijawab.'),
          ),
        );
      return;
    }

    setState(() {
      _currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _currentQuestion;
    final hasAnswer = _answers[_currentIndex] != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _QuizHeader(onBack: () => Navigator.of(context).maybePop()),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                  child: _QuizProgress(
                    current: _currentIndex + 1,
                    total: quizQuestions.length,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _contentMaxWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _QuestionCard(question: question),
                        const SizedBox(height: 20),
                        const Text(
                          'Pilih satu jawaban yang paling tepat.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (var i = 0; i < question.options.length; i++) ...[
                          _OptionTile(
                            index: i,
                            text: question.options[i],
                            isSelected: _selectedIndex == i,
                            onTap: () => _selectOption(i),
                          ),
                          if (i != question.options.length - 1)
                            const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                  child: PrimaryButton(
                    label: _isLastQuestion ? 'Selesai' : 'Soal berikutnya',
                    onPressed: hasAnswer ? _handleNext : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Header sederhana: tombol kembali + nama aplikasi.
class _QuizHeader extends StatelessWidget {
  const _QuizHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 20, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
            tooltip: 'Kembali',
          ),
          const SizedBox(width: 2),
          const Text(
            'QuizMate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Indikator progres: teks "Soal x dari y" dan progress bar.
class _QuizProgress extends StatelessWidget {
  const _QuizProgress({required this.current, required this.total});

  /// Nomor soal yang sedang ditampilkan (dimulai dari 1).
  final int current;

  /// Jumlah seluruh soal.
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Soal $current dari $total',
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : current / total,
            minHeight: 6,
            backgroundColor: AppColors.border,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

/// Kartu berisi teks pertanyaan.
class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        question.question,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Satu pilihan jawaban dengan penanda huruf (A, B, C, D).
///
/// Dapat ditekan untuk memilih. Opsi yang dipilih ditandai dengan border
/// dan penanda huruf berwarna primary.
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final int index;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  String get _letter => String.fromCharCode(65 + index);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  _letter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15.5,
                    height: 1.35,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
