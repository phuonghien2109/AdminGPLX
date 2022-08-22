import 'package:flutter/material.dart';
import 'package:testweb2/helper/question.dart';
import 'package:testweb2/helper/quiz_user.dart';
import 'package:testweb2/helper/traffic_signs.dart';
import 'package:testweb2/services/auth_service.dart';
import 'package:testweb2/services/quiz_service.dart';
import 'package:testweb2/services/traffic_signs_service.dart';

class QuizProvider extends ChangeNotifier {
  // int totalTime = 0;
  List<Question> questions = [];
  List<QuizUser> users = [];

  List<BienBao> bienbao = [];

  QuizProvider() {
    QuizService.getAllQuestions().then((value) {
      questions = value;
      notifyListeners();
    });
    TrafficSignsService.getAllTrafficSigns().then((value) {
      bienbao = value;
      notifyListeners();
    });
    QuizService.getAllUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  Future<void> updateHighscore(int currentScore) async {
    await QuizService.updateHighscore(currentScore);
  }
}
