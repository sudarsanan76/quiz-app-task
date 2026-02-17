import 'package:dio/dio.dart';
import 'package:quiz_app/models/questions_model.dart';

class QuestionsServices {
  /// [getQuestionsData] acts as a service file for making API call
  Future<List<QuestionsModel>> getQuestionsData(String difficultyLevel) async {
    final dio = Dio();
    // using Dio package making API call
    final response = await dio.get(
        'https://the-trivia-api.com/api/questions?limit=10&difficulty=$difficultyLevel');
    List<dynamic> responseData = response.data;
    List<QuestionsModel> questionsData = [];
    // parsing the raw response Data
    for (var questions in responseData) {
      questionsData.add(QuestionsModel.fromJson(questions));
    }
    return questionsData;
  }
}
