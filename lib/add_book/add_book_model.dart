import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookModel extends ChangeNotifier {
  String? title;
  String? author;
  Future addbook() async {
    if (title == null || title == "") {
      throw "本のタイトルを選択して下さい";
    }
    if (author == null || author!.isEmpty) {
      throw "本の著者を選択して下さい";
    }
    //FirebaseのFireStoreデータベースにデータを登録
    await FirebaseFirestore.instance.collection("books").add({
      "title": title,
      "author": author,
    });
  }
}
