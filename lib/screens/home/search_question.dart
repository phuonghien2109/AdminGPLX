import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:testweb2/helper/constants.dart';
import 'package:testweb2/helper/question.dart';
import 'package:testweb2/provider/quiz_provider.dart';
import 'package:testweb2/screens/home/update_question.dart';

class SearchQuestion extends StatefulWidget {
  const SearchQuestion({Key? key}) : super(key: key);

  @override
  State<SearchQuestion> createState() => _SearchQuestionState();
}

TextEditingController controller = TextEditingController();
late List<Question> _questions;

class _SearchQuestionState extends State<SearchQuestion> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    _questions = provider.questions;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kColor,
        title: const Text('Tìm kiếm câu hỏi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TypeAheadField<Question>(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: 'Tìm kiếm ...',
            ),
            controller: controller,
          ),
          suggestionsCallback: UserData.getSuggestions,
          itemBuilder: (context, Question suggestion) {
            final user = suggestion;
            return ListTile(
              title: Text(user.question),
            );
          },
          noItemsFoundBuilder: (context) => SizedBox(
            height: 50,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
              child: const Text(
                'Không tìm thấy',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          onSuggestionSelected: (Question suggestion) {
            setState(() {
              final user = suggestion;
              controller = TextEditingController();
              MainNoti(user: user);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: UpdateQuestion(
                          questions: user,
                        ),
                      ),
                    );
                  });
            });
          },
        ),
      ),
    );
  }
}

class MainNoti extends ChangeNotifier {
  final Question user;

  MainNoti({
    required this.user,
  });

  @override
  notifyListeners();
}

class UserData {
  static final List<Question> users = List.generate(
    190,
    (index) => Question(
      question: _questions[index].question,
      answers: _questions[index].answers,
      explain: _questions[index].explain,
      correctAnswer: _questions[index].correctAnswer,
      id: _questions[index].id,
      image: _questions[index].image,
      state: _questions[index].state,
    ),
  );

  static List<Question> getSuggestions(String query) =>
      List.of(users).where((user) {
        final userLower = user.question.toLowerCase();
        final queryLower = query.toLowerCase();

        return userLower.contains(queryLower);
      }).toList();
}
