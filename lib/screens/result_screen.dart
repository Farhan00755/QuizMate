import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/primary_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.playerName,
    required this.correctCount,
    required this.totalQuestions,
  });

  final String playerName;
  final int correctCount;
  final int totalQuestions;

  double get _percentage =>
      totalQuestions == 0 ? 0 : correctCount / totalQuestions;

  String get _feedback {
    if (_percentage >= 0.8) {
      return 'Luar biasa, pemahamanmu sudah sangat baik.';
    }
    if (_percentage >= 0.6) {
      return 'Bagus! Sedikit lagi menuju sempurna.';
    }
    return 'Jangan menyerah, coba lagi ya.';
  }

  void _backToHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _backToHome(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth < 360
                  ? 20.0
                  : 24.0;
              final verticalPadding = constraints.maxHeight < 640 ? 24.0 : 32.0;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - (verticalPadding * 2),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.emoji_events_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Kuis selesai',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kerja bagus, $playerName!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14.5,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 28),
                          _ScoreCard(
                            correctCount: correctCount,
                            totalQuestions: totalQuestions,
                            percentage: _percentage,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _feedback,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 28),
                          PrimaryButton(
                            label: 'Ulangi Kuis',
                            onPressed: () => _backToHome(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.correctCount,
    required this.totalQuestions,
    required this.percentage,
  });

  final int correctCount;
  final int totalQuestions;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Text(
            'Skor kamu',
            style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            '$correctCount / $totalQuestions',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: percentage, minHeight: 8),
          ),
          const SizedBox(height: 10),
          Text(
            '${(percentage * 100).round()}% benar',
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
