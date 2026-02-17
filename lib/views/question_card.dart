import 'package:flutter/material.dart';
import 'package:quiz_app/models/questions_model.dart';

class QuestionCard extends StatefulWidget {
  final QuestionsModel question;
  final Function(bool isCorrect) onAnswerSelected;

  const QuestionCard(
      {super.key, required this.question, required this.onAnswerSelected});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? _selectedOption;
  late List<String> _allOptions;

  @override
  void initState() {
    super.initState();
    // Combine and shuffle options once when the card is created
    _allOptions = [
      widget.question.correctAnswer,
      ...widget.question.incorrectAnswers
    ];
    _allOptions.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Text
            Text(
              widget.question.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Options List
            ..._allOptions.map((option) {
              final isSelected = _selectedOption == option;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    // Prevent multiple selections
                    setState(() {
                      _selectedOption = option;
                    });
                    // Callback to notify parent
                    widget.onAnswerSelected(
                        option == widget.question.correctAnswer);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      // Logic: Grey by default, Green if selected
                      color: isSelected ? Colors.green : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.green.shade700
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
