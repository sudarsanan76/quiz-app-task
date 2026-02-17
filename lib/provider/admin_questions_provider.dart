// The StateProvider to hold our list of custom questions
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/models/questions_model.dart';

// provider to store all the admin's custom questions
final adminCustomQuestionsProvider =
    StateProvider<List<QuestionsModel>>((ref) => []);
