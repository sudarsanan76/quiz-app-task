// QuestionsModel data model for questions
class QuestionsModel {
  final String category;
  final String id;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String question;
  final List<String> tags;
  final String type;
  final String difficulty;
  final List<dynamic> regions;
  final bool isNiche;

  // Removed 'required'. Fields now have default values.
  QuestionsModel({
    this.category = '',
    this.id = '',
    this.correctAnswer = '',
    this.incorrectAnswers = const [],
    this.question = '',
    this.tags = const [],
    this.type = '',
    this.difficulty = '',
    this.regions = const [],
    this.isNiche = false,
  });

  factory QuestionsModel.fromJson(Map<String, dynamic> json) {
    return QuestionsModel(
      category: json['category'] ?? '',
      id: json['id'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      incorrectAnswers: List<String>.from(json['incorrectAnswers'] ?? []),
      question: json['question'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      type: json['type'] ?? '',
      difficulty: json['difficulty'] ?? '',
      regions: List<dynamic>.from(json['regions'] ?? []),
      isNiche: json['isNiche'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'id': id,
      'correctAnswer': correctAnswer,
      'incorrectAnswers': incorrectAnswers,
      'question': question,
      'tags': tags,
      'type': type,
      'difficulty': difficulty,
      'regions': regions,
      'isNiche': isNiche,
    };
  }
}
