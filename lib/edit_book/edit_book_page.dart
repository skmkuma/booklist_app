import 'package:booklist_app/domain/book.dart';
import 'package:booklist_app/edit_book/edit_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBookPage extends StatelessWidget {
  final Book book;
  EditBookPage(this.book);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBookModel>(
      create: (_) => EditBookModel(book), //..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit BookList"),
        ),
        body: Center(
          // notifyListeners()から値が更新されるとConsumerがrebuildされる
          child: Consumer<EditBookModel>(builder: (context, model, child) {
            return Padding(
              padding: EdgeInsets.all(9),
              child: Column(
                children: [
                  TextField(
                    controller: model.titleController,
                    decoration: InputDecoration(hintText: '本のタイトル'),
                    onChanged: (text) {
                      model.setTitle(text);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: model.authorController,
                    decoration: InputDecoration(hintText: '本の著者'),
                    onChanged: (text) {
                      model.setAuthor(text);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      // isUpdated()の返り値によって"更新するボタン"を活性非活性にする
                      onPressed: model.isUpdated()
                          ? () async {
                              try {
                                //ボタンが押された時の処理
                                await model.update();
                                Navigator.of(context).pop(model.title);
                              } catch (e) {
                                final snackbar = SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(e.toString()));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                              }
                            }
                          : null,
                      child: Text('更新する')),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
