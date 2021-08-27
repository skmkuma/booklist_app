import 'package:booklist_app/add_book/add_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(), //..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add BookList"),
        ),
        body: Center(
          // notifyListeners()から値が更新されるとConsumerがrebuildされる
          child: Consumer<AddBookModel>(builder: (context, model, child) {
            return Padding(
              padding: EdgeInsets.all(9),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: '本のタイトル'),
                    onChanged: (text) {
                      model.title = text;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: '本の著者'),
                    onChanged: (text) {
                      model.author = text;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          //ボタンが押された時の処理
                          await model.addbook();
                          Navigator.of(context).pop(true);
                        } catch (e) {
                          final snackbar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      },
                      child: Text('追加する')),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
