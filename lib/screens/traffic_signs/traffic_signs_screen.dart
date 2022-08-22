import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testweb2/helper/constants.dart';
import 'package:testweb2/provider/quiz_provider.dart';
import 'package:testweb2/screens/components/app_bar.dart';
import 'package:testweb2/screens/traffic_signs/add_traffic.dart';
import 'package:testweb2/screens/traffic_signs/search_traffic.dart';
import 'package:testweb2/screens/traffic_signs/update_traffic.dart';

class TrafficSigns extends StatefulWidget {
  const TrafficSigns({Key? key}) : super(key: key);

  @override
  _TrafficSignsState createState() => _TrafficSignsState();
}

class _TrafficSignsState extends State<TrafficSigns> {
  CollectionReference user = FirebaseFirestore.instance.collection("BienBao");

  finaldelete(String document) {
    user.doc(document).delete();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(),
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: provider.bienbao.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image(
                          image: NetworkImage(provider.bienbao[index].img),
                          height: 70,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.bienbao[index].title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                  'Giải Thích: ${provider.bienbao[index].subtitle}'),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            PopupMenuButton(
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
                                        finaldelete(provider.bienbao[index].id);
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                        showDialog(
                                          builder: (context) =>
                                              const AlertDialog(
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
                                                20.0)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.9,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: UpdateTrafficSigns(
                                            bienbao: provider.bienbao[index],
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
                  ),
                );
              },
            )
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
                        child: const SearchTraffic(),
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
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const AddTraffic(),
                      ),
                    );
                  });
            },
            tooltip: 'Thêm',
            child: const Icon(Icons.add),
            backgroundColor: kColor,
          ),
        ],
      ),
    );
  }
}
