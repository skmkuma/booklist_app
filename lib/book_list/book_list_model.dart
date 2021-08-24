import 'package:book_list_app/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ChangeNotifierを継承することで、変更可能なデータを
// ChangeNotifierProviderを介して渡すことができる
// 受け渡すデータはChangeNotifierを継承しnotifyListeners()を使って変更を知らせる
// Provider.of<T>で親Widgetからデータを受け取る(渡すデータのクラスと<T>は揃える)
class BookListModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('books').snapshots();

  List<Book>? books;

  void fetchBookList() {
    // hoge.listen():hogeが更新されるとlisten以下のコードが走る
    // .map()メソッドを使うことでDocumentSnapshot型⇨List型に変換
    _userStream.listen((QuerySnapshot snapshot) {
      final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final String title = data["title"];
        final String author = data["author"];
        return Book(title, author);
      }).toList();
      this.books = books;
      // notifyListeners(): booksの値が更新され、Consumerが発火する
      notifyListeners();
    });
  }
}
