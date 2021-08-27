import 'package:booklist_app/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBookModel extends ChangeNotifier {
  String? title;
  String? author;

  final titleController = TextEditingController();
  final authorController = TextEditingController();

  final Book book;
  EditBookModel(this.book) {
    titleController.text = book.title;
    authorController.text = book.author;
  }

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setAuthor(String author) {
    this.author = author;
    notifyListeners();
  }

  // タイトルor著者がnullじゃなかったら(更新したら)trueを返す
  bool isUpdated() {
    return title != null || author != null;
  }

  Future update() async {
    // タイトルと著者は変更するとsetTitle()が呼ばれてthis.titleが更新される
    // 変更がない場合だとthis.author=nullとなり、FireStoreのデータベースもnullで
    // 更新されてしまうため、updateの直前にtitleController.text(その時のTextFieldの文字列)を
    // 定義しておく
    this.title = titleController.text;
    this.author = authorController.text;
    //FirebaseのFireStoreデータベースに変更を更新
    await FirebaseFirestore.instance.collection("books").doc(book.id).update({
      "title": title,
      "author": author,
    });
  }
}
