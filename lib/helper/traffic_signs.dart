import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class BienBao {
  final String id;
  final String title;
  final String subtitle;
  final String img;
  BienBao({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.img,
  });

  BienBao copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? img,
  }) {
    return BienBao(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      img: img ?? this.img,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'img': img,
    };
  }

  factory BienBao.fromMap(Map<String, dynamic> map) {
    return BienBao(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      img: map['img'],
    );
  }

  factory BienBao.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final id = snapshot.id;
    data['id'] = id;
    return BienBao.fromMap(data);
  }

  String toJson() => json.encode(toMap());

  factory BienBao.fromJson(String source) =>
      BienBao.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BienBao(id: $id, title: $title, subtitle: $subtitle, img: $img)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BienBao &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.img == img;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ subtitle.hashCode ^ img.hashCode;
  }
}
