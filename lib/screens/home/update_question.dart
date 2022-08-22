import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:testweb2/helper/constants.dart';
import 'package:testweb2/helper/question.dart';
import 'package:testweb2/screens/home/home.dart';

class UpdateQuestion extends StatefulWidget {
  const UpdateQuestion({
    Key? key,
    required this.questions,
  }) : super(key: key);

  final Question questions;

  @override
  State<UpdateQuestion> createState() => _UpdateQuestionState();
}

class _UpdateQuestionState extends State<UpdateQuestion> {
  late String _filename;
  FilePickerResult? results;
  bool _selected = false;
  bool _selectedState = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _key = GlobalKey<FormState>();

    TextEditingController question =
        TextEditingController(text: widget.questions.question);

    final TextEditingController answer1 =
        TextEditingController(text: widget.questions.answers[0]);

    final TextEditingController answer2 =
        TextEditingController(text: widget.questions.answers[1]);

    final TextEditingController answer3 =
        TextEditingController(text: widget.questions.answers[2]);

    final TextEditingController answer4 =
        TextEditingController(text: widget.questions.answers[3]);

    final TextEditingController correctAnswer =
        TextEditingController(text: widget.questions.correctAnswer);

    final TextEditingController explain =
        TextEditingController(text: widget.questions.explain);

    String _image = widget.questions.image;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kColor,
        title: const Text('Sửa Câu Hỏi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Câu hỏi *"),
                    controller: question,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Câu A *"),
                    controller: answer1,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Câu B *"),
                    controller: answer2,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Câu C"),
                    controller: answer3,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Câu D"),
                    controller: answer4,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Đáp Án *"),
                    controller: correctAnswer,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.questions.image != '')
                          Row(
                            children: [
                              Image(
                                image: NetworkImage(widget.questions.image),
                                height: 100,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        GestureDetector(
                          onTap: () async {
                            await choseImage(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                            child: const Text(
                              'Chọn Ảnh',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        if (widget.questions.image != '')
                          PopupMenuButton(
                            color: kColor,
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
                                      setState(() {
                                        _image = '';
                                      });
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
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Giải Thích *"),
                    controller: explain,
                  ),
                  if (widget.questions.state == false)
                    Row(
                      children: [
                        Checkbox(
                          value: _selected,
                          onChanged: (value) {
                            setState(() {
                              _selected = value!;
                              _selectedState = _selected;
                            });
                          },
                        ),
                        const Text('Câu Điểm Liệt'),
                      ],
                    ),
                  if (widget.questions.state == true)
                    Row(
                      children: [
                        Checkbox(
                          value: !_selected,
                          onChanged: (value) {
                            setState(() {
                              _selected = !value!;
                              _selectedState = !_selected;
                            });
                          },
                        ),
                        const Text('Câu Điểm Liệt'),
                      ],
                    ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: kColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (question.text == '' ||
                        answer1.text == '' ||
                        answer2.text == '' ||
                        correctAnswer.text == '') {
                      _showNot(context);
                    } else {
                      if (_image != '') {
                        if (results != null) {
                          final _path = results!.files.first.bytes;
                          final Reference firestorageRef = FirebaseStorage
                              .instance
                              .ref()
                              .child('questions/$_filename');
                          await firestorageRef.putData(_path!);
                          final downloadUrl =
                              await firestorageRef.getDownloadURL();
                          setState(() {
                            _image = downloadUrl;
                          });
                        } else {
                          setState(() {
                            _image = widget.questions.image;
                          });
                        }
                      }
                      if (results != null) {
                        final _path = results!.files.first.bytes;
                        final Reference firestorageRef = FirebaseStorage
                            .instance
                            .ref()
                            .child('questions/$_filename');
                        await firestorageRef.putData(_path!);
                        final downloadUrl =
                            await firestorageRef.getDownloadURL();
                        setState(() {
                          _image = downloadUrl;
                        });
                      } else {
                        setState(() {
                          _image = '';
                        });
                      }
                      await FirebaseFirestore.instance
                          .collection("Question")
                          .doc(widget.questions.id)
                          .update(
                        {
                          "question": question.text,
                          "answers": [
                            answer1.text,
                            answer2.text,
                            answer3.text,
                            answer4.text,
                          ],
                          "correctAnswer": correctAnswer.text,
                          "image": _image,
                          "explain": explain.text,
                          "state": _selectedState,
                        },
                      );

                      Navigator.pop(context);
                      _showOK(context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      color: kColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> choseImage(context) async {
    results = (await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    ));
    _filename = results!.files.single.name;
    return _filename;
  }
}

void _showNot(BuildContext context) {
  showDialog(
    builder: (context) => AlertDialog(
      title: const Text('Thông báo'),
      content: const Text('Vui lòng nhập đủ các trường !'),
      actions: <Widget>[
        GestureDetector(
          child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: kColor),
              child: const Text('Đồng ý')),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    ),
    context: context,
  );
}

void _showOK(BuildContext context) {
  showDialog(
    builder: (context) => const AlertDialog(
      title: Text('Thông báo'),
      content: Text('Sửa Thành Công!'),
    ),
    context: context,
  );
}
