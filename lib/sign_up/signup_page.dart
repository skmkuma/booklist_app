import 'package:booklist_app/book_list/book_list_page.dart';
import 'package:booklist_app/sign_up/signup_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Center(
          // notifyListeners()から値が更新されるとConsumerがrebuildされる
          child: Consumer<SignUpModel>(builder: (context, model, child) {
            return Padding(
              padding: EdgeInsets.all(9),
              child: Column(
                children: [
                  TextField(
                    controller: mailController,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 20),
                        labelText: "E-mail",
                        hintText: 'example@gmail.com'),
                    onChanged: (text) {
                      model.mail = text;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 20),
                      labelText: "Password",
                      hintText: "",
                    ),
                    //入力文字隠し
                    obscureText: true,
                    onChanged: (text) {
                      model.password = text;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text('新規登録する'),
                    // isUpdated()の返り値によって"更新するボタン"を活性非活性にする
                    onPressed: () async {
                      try {
                        //mailとpasswordが埋まっているか確認し、Firebaseに登録実行
                        await model.signup();
                        _showDialog(context, "新規登録完了しました");
                      } on FirebaseAuthException catch (e) {
                        // パスワードに問題がある場合の処理を描く(今回は使わない)
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        // try中でthrowされた場合はダイアログを表示
                        _showDialog(context, e.toString());
                      }
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future _showDialog(BuildContext context, alert) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alert),
          content: Text(alert),
          actions: <Widget>[
            TextButton(
                child: Text("OK"),
                onPressed: alert == "新規登録完了しました"
                    ? () {
                        // "OK"をクリックするとブックリストに画面遷移
                        Navigator.pushReplacement(
                          //pushReplacement:元のページに戻らない時に使用
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookListPage(),
                          ),
                        );
                      }
                    : () {
                        Navigator.pop(context);
                      }),
          ],
        );
      },
    );
  }
}
