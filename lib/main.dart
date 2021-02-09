import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './screens/mainpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Login(), theme: new ThemeData(primarySwatch: Colors.red));
  }
}

class Login extends StatefulWidget {
  @override
  State createState() => new LoginState();
}

class LoginState extends State<Login> {
  bool _isLoading = true;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  login(String email, password) async {
    Map data = {'username': email, 'password': password};
    var jsonData;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response =
        await http.post("http://10.0.2.2:8000/api-token-auth/", body: data);
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      _isLoading = false;
      sharedPreferences.setString("token", jsonData["token"]);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      print(response.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Incorrect Credentials"),
              title: Text("Please enter valid credentials"),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          // child: Padding(
          //   padding: const EdgeInsets.only(left: 22.0, right: 22, top: 40),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image(
                image: new AssetImage("assets/logo.png"),
              ),
              new Form(
                child: new Theme(
                  data: new ThemeData(
                      brightness: Brightness.dark,
                      primarySwatch: Colors.grey,
                      inputDecorationTheme: new InputDecorationTheme(
                          labelStyle: new TextStyle(
                              color: Colors.black, fontSize: 20.0))),
                  child: Container(
                    padding: const EdgeInsets.all(50.0),
                    child: ListView(
                      children: <Widget>[
                        new TextFormField(
                          controller: emailController,
                          decoration: new InputDecoration(
                            labelText: "User Name",
                          ),
                          // keyboardType: TextInputType.number,
                        ),
                        new TextFormField(
                          controller: passwordController,
                          decoration: new InputDecoration(
                            labelText: "Enter Password",
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: new MaterialButton(
                            color: Colors.blueGrey,
                            textColor: Colors.white,
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              login(emailController.text,
                                  passwordController.text);
                            },
                            child: new Text("Login"),
                            splashColor: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
