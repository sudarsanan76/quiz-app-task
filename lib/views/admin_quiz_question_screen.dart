import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/provider/admin_questions_provider.dart';
import 'package:quiz_app/viewModel/admin_quiz_view_model.dart';

class AdminQuizQuestionScreen extends ConsumerStatefulWidget {
  const AdminQuizQuestionScreen({super.key});

  @override
  ConsumerState<AdminQuizQuestionScreen> createState() =>
      _AdminQuizQuestionScreenState();
}

class _AdminQuizQuestionScreenState
    extends ConsumerState<AdminQuizQuestionScreen> {

  final AdminQuizViewModel _adminQuizViewModel = AdminQuizViewModel();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (_) => TextEditingController());
  int _correctIndex = 0;

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(adminCustomQuestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Quiz (${questions.length}/${_adminQuizViewModel.maxQuestions})",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: "Enter Question")),
            const SizedBox(height: 20),
            ...List.generate(
                4,
                (index) => Row(
                      children: [
                        Radio<int>(
                          value: index,
                          groupValue: _correctIndex,
                          onChanged: (val) =>
                              setState(() => _correctIndex = val!),
                        ),
                        Expanded(
                            child: TextField(
                                controller: _optionControllers[index],
                                decoration: InputDecoration(
                                    labelText: "Option ${index + 1}"))),
                      ],
                    )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _adminQuizViewModel.addQuestion(
                  ref: ref,
                  questionText: _questionController.text,
                  options: _optionControllers.map((e) => e.text).toList(),
                  correctIndex: _correctIndex,
                );
                _questionController.clear();
                for (var c in _optionControllers) {
                  c.clear();
                }
              },
              child: const Text("Add to List"),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(questions[index].question),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _adminQuizViewModel.deleteQuestion(ref, questions[index].id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
