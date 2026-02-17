
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:quiz_app/provider/admin_questions_provider.dart';
import '../models/questions_model.dart';

/// [AdminQuizViewModel] view model for admin quiz 
class AdminQuizViewModel {
  final int maxQuestions = 10;
  // function to add question
  void addQuestion({
    required WidgetRef ref,
    required String questionText,
    required List<String> options,
    required int correctIndex,
  }) {
    final currentQuestions = ref.read(adminCustomQuestionsProvider);

    if (currentQuestions.length >= maxQuestions) {
      Get.snackbar(
          "Limit Reached", "You can only add up to $maxQuestions questions.");
      return;
    }

    final newQuestion = QuestionsModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: questionText,
      correctAnswer: options[correctIndex],
      incorrectAnswers: options
          .asMap()
          .entries
          .where((e) => e.key != correctIndex)
          .map((e) => e.value)
          .toList(),
      category: "Custom Admin Quiz",
    );

    ref.read(adminCustomQuestionsProvider.notifier).state = [
      ...currentQuestions,
      newQuestion
    ];
    Get.snackbar("Success", "Question added successfully!");
  }
  
  // delete Question 
  void deleteQuestion(WidgetRef ref, String id) {
    ref.read(adminCustomQuestionsProvider.notifier).state = ref
        .read(adminCustomQuestionsProvider)
        .where((q) => q.id != id)
        .toList();
  }
}
