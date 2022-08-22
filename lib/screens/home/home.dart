import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testweb2/helper/constants.dart';
import 'package:testweb2/provider/quiz_provider.dart';
import 'package:testweb2/screens/home/add_question.dart';
import 'package:testweb2/screens/components/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:testweb2/screens/home/search_question.dart';
import 'package:testweb2/screens/home/update_question.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference user = FirebaseFirestore.instance.collection("Question");

  finaldelete(String document) {
    user.doc(document).delete();
  }

  bool _showBackToTopButton = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final questions = provider.questions;
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(),
            ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final _question = questions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_question.state == true)
                              const Text(
                                '(Câu điểm liệt)',
                                style: TextStyle(color: Colors.red),
                              ),
                            Text(
                              'Câu hỏi ${index + 1}: ${_question.question}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_question.image != '')
                              Row(
                                children: [
                                  CachedNetworkImage(
                                    height: 100,
                                    imageUrl: _question.image,
                                    maxHeightDiskCache: 100,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                  ),
                                  // Image(
                                  //   image: NetworkImage(_question.image),
                                  //   height: 100,
                                  // ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            for (int i = 0; i < _question.answers.length; i++)
                              if (_question.answers[i] != '')
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    '${i + 1}. ${_question.answers[i]}',
                                  ),
                                ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Đáp án: ${_question.correctAnswer}',
                              style: const TextStyle(color: kColor),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PopupMenuButton(
                            color: Colors.white,
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red[400],
                            ),
                            elevation: 2,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  height: 30,
                                  child: GestureDetector(
                                    onTap: () {
                                      finaldelete(_question.id);
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                      showDialog(
                                        builder: (context) => const AlertDialog(
                                          title: Text('Thông báo'),
                                          content: Text('Xóa Thành Công!'),
                                        ),
                                        context: context,
                                      );
                                    },
                                    child: const Text(
                                      'Xóa',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  height: 30,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Hủy',
                                    ),
                                  ),
                                ),
                              ];
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.mode_edit,
                              size: 20,
                              color: Colors.teal[600],
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0)), //this right here
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: UpdateQuestion(
                                          questions: _question,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            elevation: 1.5,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const SearchQuestion(),
                      ),
                    );
                  });
            },
            tooltip: 'Tìm Kiếm',
            child: const Icon(Icons.search),
            backgroundColor: kColor,
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            elevation: 1.5,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const AddQuestion(),
                      ),
                    );
                  });
            },
            tooltip: 'Thêm',
            child: const Icon(Icons.add),
            backgroundColor: kColor,
          ),
          if (_showBackToTopButton == true)
            FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            ),
        ],
      ),
    );
  }
}
