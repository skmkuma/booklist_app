import 'package:booklist_app/add_book/add_book_model.dart';
import 'package:booklist_app/add_book/add_book_page.dart';
import 'package:booklist_app/book_list/book_list_model.dart';
import 'package:booklist_app/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("BookList App"),
        ),
        body: Center(
          // notifyListeners()から値が更新されるとConsumerがrebuildされる
          child: Consumer<BookListModel>(builder: (context, model, child) {
            final List<Book>? books = model.books;

            if (books == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = books
                .map(
                  (book) => ListTile(
                    title: Text(book.title),
                    subtitle: Text(book.author),
                  ),
                )
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () async {
              //画面遷移
              final bool? bookadd = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true,
                ),
              );

              if (bookadd != null && bookadd) {
                final snackbar = SnackBar(
                    backgroundColor: Colors.green, content: Text("本が追加されました"));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              model.fetchBookList();
            },
            tooltip: 'Add book',
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }
}
