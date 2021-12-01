// ignore_for_file: prefer_const_constructors, unused_element, deprecated_member_use, unused_local_variable, prefer_final_fields, unused_field, prefer_collection_literals

import 'dart:convert';

import 'package:app_1/constants.dart';
import 'package:app_1/list.dart';
import 'package:app_1/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  final url = "https://jsonplaceholder.typicode.com/users";
  var _postJson = [];

  void fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        _postJson = jsonData;
      });
      // ignore: empty_catches
    } catch (err) {}
  }

  Widget _buildEmailRow() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: mainColor,
            ),
            labelText: "E-Mail"),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          Container(
            height: 1.4 * (MediaQuery.of(context).size.height / 20),
            width: 5 * (MediaQuery.of(context).size.width / 10),
            margin: EdgeInsets.only(bottom: 20),
            child: RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: mainColor,
              onPressed: () async {
                loginMethod();
              },
              child: Text(
                'login',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: MediaQuery.of(context).size.height / 40),
              ),
            ),
          )
        ]);
  }

  Widget _buildContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(color: Colors.blueGrey[50]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Login',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height / 30,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildEmailRow(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                ),
                _buildLoginButton()
              ],
            ),
          ),
        )
      ],
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blueGrey[100],
        body: Builder(builder: (context) {
          return Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(70),
                      bottomRight: const Radius.circular(70),
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildContainer(),
                ],
              )
            ],
          );
        }),
      ),
    );
  }

  loginMethod() async {
    http.Response response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      List<Users> user = usersFromJson(response.body);
      int index =
          user.indexWhere((element) => emailController.text == element.email);
      if (index == -1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User not exist')));
      } else {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.setInt('id', user[index].id);
        _prefs.setString('name', user[index].name);
        _prefs.setString('email', user[index].email);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListPage()));
      }
      // .where((element) => emailController.text == element.email)
      // .first;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Processing Data')));
    }
  }
}
