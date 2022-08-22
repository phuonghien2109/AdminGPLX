import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testweb2/helper/traffic_signs.dart';

class TrafficSignsService {
  static Future<List<BienBao>> getAllTrafficSigns() async {
    final questionsRef = FirebaseFirestore.instance.collection('BienBao');
    final questionDoc = await questionsRef.get();

    return questionDoc.docs
        .map((e) => BienBao.fromQueryDocumentSnapshot(e))
        .toList();
  }
}
