import 'package:booklist_app/book_list/book_list_page.dart';
import 'package:booklist_app/login/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Log In"),
        ),
        body: Center(
          // notifyListeners()から値が更新されるとConsumerがrebuildされる
          child: Consumer<LoginModel>(builder: (context, model, child) {
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
                    child: Text('ログインする'),
                    // isUpdated()の返り値によって"更新するボタン"を活性非活性にする
                    onPressed: () async {
                      try {
                        //mailとpasswordが埋まっているか確認し、Firebaseに登録実行
                        await model.login();
                        await _showDialog(context, "ログインしました");
                        // "OK"をクリックするとブックリストに画面遷移
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookListPage(),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          _showDialog(context, "登録情報がありません");
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
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
                onPressed: alert == "ログインしました"
                    ? () {
                        // "OK"をクリックするとブックリストに画面遷移
                        Navigator.push(
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
