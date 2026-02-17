import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/questions_model.dart';

final questionsProviderData = StateProvider<List<QuestionsModel>>((ref) => []);

// Simple provider to hold the results map
final quizScoreProvider = StateProvider<Map<String, bool>>((ref) => {});

// Total marks (Starts at 0)
final scoreProvider = StateProvider<int>((ref) => 0);

// Player lives (Starts at 3)
final livesProvider = StateProvider<int>((ref) => 3);

// Penalty for skipping (Deduct 5 marks)
const int skipPenalty = 5;
const int correctAward = 10;
