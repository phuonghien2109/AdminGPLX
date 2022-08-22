import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:testweb2/helper/constants.dart';
import 'package:testweb2/helper/traffic_signs.dart';
import 'package:testweb2/screens/traffic_signs/traffic_signs_screen.dart';

class UpdateTrafficSigns extends StatefulWidget {
  const UpdateTrafficSigns({Key? key, required this.bienbao}) : super(key: key);

  final BienBao bienbao;

  @override
  State<UpdateTrafficSigns> createState() => _UpdateTrafficSignsState();
}

class _UpdateTrafficSignsState extends State<UpdateTrafficSigns> {
  late TextEditingController title;
  late TextEditingController subtitle;
  late String _filename;
  FilePickerResult? results;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _key = GlobalKey<FormState>();

    TextEditingController title =
        TextEditingController(text: widget.bienbao.title);

    TextEditingController subtitle =
        TextEditingController(text: widget.bienbao.subtitle);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kColor,
        title: const Text('Sửa Biển Báo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Biển Báo"),
                      controller: title,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Chỉ dẫn"),
                      controller: subtitle,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Image(
                  image: NetworkImage(widget.bienbao.img),
                  height: 70,
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await choseImage(context);
                  },
                  child: const Text('Chọn Hình Ảnh'),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrafficSigns(),
                        ));
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
                    String _image = widget.bienbao.img;
                    final _firebase = FirebaseFirestore.instance;
                    if (title.text == '' || subtitle.text == '') {
                      _showNot(context);
                    } else {
                      if (results != null) {
                        final _path = results!.files.first.bytes;
                        final Reference firestorageRef = FirebaseStorage
                            .instance
                            .ref()
                            .child('traffic_signs/$_filename');
                        await firestorageRef.putData(_path!);
                        final downloadUrl =
                            await firestorageRef.getDownloadURL();
                        setState(() {
                          _image = downloadUrl;
                        });
                      } else {
                        setState(() {
                          _image = widget.bienbao.img;
                        });
                      }
                      await _firebase
                          .collection("BienBao")
                          .doc(widget.bienbao.id)
                          .update(
                        {
                          "title": title.text,
                          "subtitle": subtitle.text,
                          "img": _image,
                        },
                      );
                      setState(
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TrafficSigns(),
                              ));
                        },
                      );

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
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: kColor),
              child: const Text('Đồng ý')),
          onTap: () {
            Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrafficSigns(),
                ));
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
