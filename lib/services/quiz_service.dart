import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testweb2/helper/question.dart';
import 'package:testweb2/helper/quiz_user.dart';

class QuizService {
  static Future<List<QuizUser>> getAllUsers() async {
    final usersRef = FirebaseFirestore.instance
        .collection('users')
        .orderBy('score', descending: true);
    final userDoc = await usersRef.get();

    return userDoc.docs
        .map((e) => QuizUser.fromQueryDocumentSnapshot(e))
        .toList();
  }

  static Future<List<Question>> getAllQuestions() async {
    final questionsRef = FirebaseFirestore.instance.collection('Question');
    final questionDoc = await questionsRef.get();

    return questionDoc.docs
        .map((e) => Question.fromQueryDocumentSnapshot(e))
        .toList();
  }

  static Future<void> updateHighscore(int currentScore) async {
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(authUser.uid);

    final userDoc = await userRef.get();

    if (userDoc.exists) {
      final user = userDoc.data();

      if (user == null) return;

      final lastHighscore = user['score'];

      if (lastHighscore >= currentScore) {
        return;
      }

      userRef.update({'score': currentScore});
      return;
    }

    userRef.set({
      'email': authUser.email,
      'photoUrl': authUser.photoURL,
      'score': currentScore,
      'name': authUser.displayName,
    });
  }
}
