import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/questions_model.dart';
import 'package:quiz_app/provider/questions_provider.dart';
import 'package:quiz_app/viewModel/question_list_view_model.dart';
import 'package:quiz_app/views/question_card.dart';

class QuestionListPage extends ConsumerStatefulWidget {
  final List<QuestionsModel>? manualQuestions;
  const QuestionListPage({
    super.key,
    this.manualQuestions,
  });

  @override
  ConsumerState<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends ConsumerState<QuestionListPage> {
  int _currentIndex = 0;
  final QuestionListViewModel _questionListViewModel = QuestionListViewModel();

  @override
  Widget build(BuildContext context) {
    // 1. If we have manual questions (Admin Mode), use them directly
    if (widget.manualQuestions != null) {
      return _buildQuizBody(widget.manualQuestions!);
    }

    // 2. Otherwise, watch the API provider (Standard Mode)
    final questionsList = ref.watch(questionsProviderData);

    return _buildQuizBody(questionsList);
  }

  Widget _buildQuizBody(List<QuestionsModel> questionsList) {
    if (questionsList.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No questions available."),
        ),
      );
    }

    final isLastQuestion = _currentIndex == questionsList.length - 1;
    final lives = ref.watch(livesProvider);
    final score = ref.watch(scoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Score: $score"), // Displaying score in AppBar
        centerTitle: true,
        actions: [
          Row(
            children: List.generate(
              3,
              (index) => Icon(
                Icons.favorite,
                color: index < lives ? Colors.red : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Question Progress
            Text(
              "Question ${_currentIndex + 1} of ${questionsList.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // 2. The Question Card
            QuestionCard(
              key: ValueKey(questionsList[_currentIndex].id),
              question: questionsList[_currentIndex],
              onAnswerSelected: (isCorrect) {
                _questionListViewModel.updateScore(
                  ref: ref,
                  questionId: questionsList[_currentIndex].id,
                  isCorrect: isCorrect,
                );
              },
            ),

            const Spacer(),

            // 3. Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentIndex > 0
                      ? () => setState(() => _currentIndex--)
                      : null,
                  child: const Text("Previous"),
                ),
                isLastQuestion
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          _questionListViewModel.handleSubmit(
                              context, ref, questionsList.length);
                        },
                        child: const Text(
                          "Submit Answers",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () => setState(() => _currentIndex++),
                        child: const Text("Next"),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
