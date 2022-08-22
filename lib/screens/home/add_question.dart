import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:testweb2/helper/constants.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  late String _filename;
  FilePickerResult? results;
  late String _image;
  bool _selectedState = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController question = TextEditingController();

  final TextEditingController answer1 = TextEditingController();

  final TextEditingController answer2 = TextEditingController();

  final TextEditingController answer3 = TextEditingController();

  final TextEditingController answer4 = TextEditingController();

  final TextEditingController correctAnswer = TextEditingController();

  final TextEditingController explain = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kColor,
        title: const Text('Thêm Câu Hỏi'),
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
                    decoration: const InputDecoration(
                      labelText: "Câu hỏi",
                    ),
                    controller: question,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Câu A"),
                    controller: answer1,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Câu B"),
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
                    decoration: const InputDecoration(labelText: "Đáp Án"),
                    controller: correctAnswer,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
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
                          'Chọn Ảnh Minh Họa',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Giải Thích"),
                    controller: explain,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _selectedState,
                        onChanged: (value) {
                          setState(() {
                            _selectedState = value!;
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
                TextButton(
                  onPressed: () async {
                    if (question.text == '' ||
                        answer1.text == '' ||
                        answer2.text == '' ||
                        correctAnswer.text == '') {
                      _showNot(context);
                    } else {
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
                      FirebaseFirestore.instance.collection("Question").add(
                        {
                          "question": question.text,
                          "answers": [
                            answer1.text,
                            answer2.text,
                            answer3.text,
                            answer4.text
                          ],
                          "correctAnswer": correctAnswer.text,
                          "image": _image,
                          "explain": explain.text,
                          "state": _selectedState,
                        },
                      );

                      setState(() {
                        Navigator.pop(context);
                        _showOK(context);
                      });
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
                      )),
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
            height: 100,
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
      content: Text('Thêm Thành Công !'),
    ),
    context: context,
  );
}
