import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/models/questions_model.dart';
import 'package:quiz_app/provider/questions_provider.dart';
import 'package:quiz_app/services/questions_services.dart';
import 'package:quiz_app/views/question_list_page.dart';
import 'package:quiz_app/views/user_dashboard.dart';

class QuestionListViewModel {
  // Method to reset game state
  void resetGame(WidgetRef ref) {
    ref.read(livesProvider.notifier).state = 3; // Reset lives to 3
    ref.read(scoreProvider.notifier).state = 0; // Reset score to 0
    ref.read(quizScoreProvider.notifier).state =
        {}; // Clear answered questions map
  }

  // load Questions
  Future<void> loadQuestions(
    BuildContext context,
    String difficulty,
    WidgetRef ref,
  ) async {
    resetGame(ref);
    // Make the API call
    List<QuestionsModel> questionsData =
        await QuestionsServices().getQuestionsData(difficulty);
    Get.off(() => const QuestionListPage());
    // store the data in provider
    ref.read(questionsProviderData.notifier).update(
          (state) => questionsData,
        );
  }

  // handle submit function
  void handleSubmit(
    BuildContext context,
    WidgetRef ref,
    int totalQuestions,
  ) {
    // 1. Read the current results from the StateProvider
    final results = ref.read(quizScoreProvider);

    // 2. Calculate the score
    int finalScore = results.values.where((val) => val == true).length;

    // 3. Show the Result Dialog using GetX
    Get.defaultDialog(
      title: "Quiz Result",
      barrierDismissible: false,
      middleText: "You scored $finalScore out of $totalQuestions",
      confirm: ElevatedButton(
        onPressed: () {
          // 4. Reset the score for the next round
          ref.read(quizScoreProvider.notifier).state = {};

          // 5. Navigate back to home or login
          Get.off(() => UserDashboard());
        },
        child: const Text("Finish"),
      ),
    );
  }

  // updateScore updates the score 
  void updateScore({
    required WidgetRef ref,
    required String questionId,
    required bool isCorrect,
  }) {
    final results = ref.read(quizScoreProvider);

    // Check if they had a previous answer for this specific question
    bool? previousResult = results[questionId];

    // 1. REVERSE PREVIOUS IMPACT
    if (previousResult != null) {
      if (previousResult == true) {
        ref.read(scoreProvider.notifier).state -= 10; // Remove old marks
      } else {
        ref.read(livesProvider.notifier).state += 1; // Give back the life
      }
    }

    // 2. APPLY NEW IMPACT
    if (isCorrect) {
      ref.read(scoreProvider.notifier).state += 10;
    } else {
      ref.read(livesProvider.notifier).state -= 1;
      if (ref.read(livesProvider) <= 0) _handleGameOver(ref);
    }

    // 3. SAVE NEW STATE
    ref.read(quizScoreProvider.notifier).state = {
      ...results,
      questionId: isCorrect,
    };
  }
  
  // skipping the question on clicking next button
  void skipQuestion(WidgetRef ref, String questionId) {
    final results = ref.read(quizScoreProvider);
    if (results.containsKey(questionId)) return;

    // Penalty for skipping
    ref.read(scoreProvider.notifier).state -= skipPenalty;

    // Mark as skipped (null or false)
    ref.read(quizScoreProvider.notifier).state = {
      ...results,
      questionId: false,
    };
  }
  
  // this function executes after game over
  void _handleGameOver(WidgetRef ref) {
    Get.defaultDialog(
      title: "Game Over",
      middleText: "You ran out of lives!",
      barrierDismissible: false,
      confirm: ElevatedButton(
        onPressed: () => {
          resetGame(ref), // Clean up before leaving
          Get.offAll(
            () => UserDashboard(),
          ),
        },
        child: const Text("Restart"),
      ),
    );
  }
}
