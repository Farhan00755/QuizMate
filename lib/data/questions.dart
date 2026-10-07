import '../models/question.dart';

/// Soal kuis lokal yang dipakai aplikasi.
///
/// Data disimpan langsung di kode (tanpa backend) agar mudah diganti
/// atau dipindah ke sumber lain pada tahap berikutnya.
const List<Question> quizQuestions = [
  Question(
    question: 'Apa kepanjangan dari CPU?',
    options: [
      'Central Processing Unit',
      'Computer Personal Unit',
      'Central Program Utility',
      'Control Processing Unit',
    ],
    correctIndex: 0,
  ),
  Question(
    question: 'Bahasa pemrograman apa yang digunakan untuk membangun aplikasi Flutter?',
    options: ['Java', 'Kotlin', 'Dart', 'Swift'],
    correctIndex: 2,
  ),
  Question(
    question: 'Manakah yang termasuk perangkat penyimpanan sekunder?',
    options: ['RAM', 'SSD', 'Cache', 'Register'],
    correctIndex: 1,
  ),
  Question(
    question: 'Apa fungsi utama dari sistem operasi?',
    options: [
      'Mengedit foto',
      'Menghitung pajak',
      'Mencetak dokumen',
      'Mengelola perangkat keras dan program',
    ],
    correctIndex: 3,
  ),
  Question(
    question: 'Satu byte terdiri dari berapa bit?',
    options: ['4', '8', '16', '32'],
    correctIndex: 1,
  ),
  Question(
    question: 'Dalam pemrograman, apa yang dimaksud dengan bug?',
    options: [
      'Fitur baru',
      'Kesalahan pada program',
      'Jenis perangkat keras',
      'Nama bahasa pemrograman',
    ],
    correctIndex: 1,
  ),
  Question(
    question: 'Manakah yang termasuk bahasa pemrograman tingkat tinggi?',
    options: ['Bahasa mesin', 'Kode biner', 'Python', 'Bahasa assembly'],
    correctIndex: 2,
  ),
  Question(
    question: 'Apa kepanjangan dari WWW?',
    options: [
      'Wide World Web',
      'World Web Wide',
      'World Wide Web',
      'Web Wide World',
    ],
    correctIndex: 2,
  ),
];
