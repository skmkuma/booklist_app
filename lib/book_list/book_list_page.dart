import 'package:booklist_app/add_book/add_book_page.dart';
import 'package:booklist_app/book_list/book_list_model.dart';
import 'package:booklist_app/domain/book.dart';
import 'package:booklist_app/edit_book/edit_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
                  (book) => Slidable(
                    // actionPaneの種類: Behind, Drawer, Scroll, Stretch
                    actionPane: SlidableDrawerActionPane(),
                    child: ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.author),
                    ),
                    // 右からのスライド: secondaryActions: <Widget>[]
                    // 左からのスライド: actions: <Widget>[]
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: '編集',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () async {
                          //編集画面に遷移
                          final String? title = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBookPage(book),
                            ),
                          );

                          if (title != null) {
                            final snackbar = SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("$titleを更新しました"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          }
                          model.fetchBookList();
                        },
                      ),
                      IconSlideAction(
                        caption: '削除',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          //削除しますか？ダイアログを表示
                        },
                      ),
                    ],
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
