import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/provider/admin_questions_provider.dart';
import 'package:quiz_app/provider/theme_provider.dart';
import 'package:quiz_app/viewModel/question_list_view_model.dart';
import 'package:quiz_app/views/question_list_page.dart';

class UserDashboard extends ConsumerWidget {
  final QuestionListViewModel _questionsViewModel = QuestionListViewModel();

  UserDashboard({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("User Mode")),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Welcome, User!",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text("Theme:"),
                  IconButton(
                    icon: Icon(ref.watch(themeProvider) == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode),
                    onPressed: () {
                      // Toggle logic
                      final currentTheme = ref.read(themeProvider);
                      ref.read(themeProvider.notifier).state =
                          currentTheme == ThemeMode.light
                              ? ThemeMode.dark
                              : ThemeMode.light;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Select Difficulty Level",
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                _questionsViewModel.loadQuestions(context, "easy", ref);
              },
              child: const Text("Easy"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _questionsViewModel.loadQuestions(context, "medium", ref);
              },
              child: const Text("Medium"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _questionsViewModel.loadQuestions(context, "hard", ref);
              },
              child: const Text("Hard"),
            ),
            const SizedBox(
              height: 20,
            ),
            // Inside UserDashboard Column
            ElevatedButton(
              clipBehavior: Clip.hardEdge,
              onPressed: () {
                // 1. Get the custom questions from the Admin Provider
                final customQuestions = ref.read(adminCustomQuestionsProvider);

                if (customQuestions.isEmpty) {
                  Get.snackbar("No Questions",
                      "The Admin hasn't created a custom quiz yet!",
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }

                // 2. Reset Game State (Lives to 3, Score to 0) using our ViewModel
                _questionsViewModel.resetGame(ref);

                // 3. Navigate to the Quiz Page, passing the custom list
                Get.to(
                    () => QuestionListPage(manualQuestions: customQuestions));
              },
              child: const Text("Play Custom Admin Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
