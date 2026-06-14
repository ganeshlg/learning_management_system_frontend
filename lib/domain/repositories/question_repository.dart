import '../entities/question.dart';
import '../entities/answer.dart';

abstract class QuestionRepository {
  Future<List<Question>> getQuestionsForSession(String sessionId);
  Future<Question> askQuestion(String sessionId, String content);
  Future<Answer> replyToQuestion(String questionId, String content);
}
