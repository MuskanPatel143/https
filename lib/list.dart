// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:app_1/album.dart';
import 'package:app_1/post.dart';
import 'package:app_1/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  DateTime? currentBackPressTime;

  String exit_warning = 'Press back button to exit';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('List'),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          child: Center(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 15),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    tileColor: Colors.blueGrey.shade200,
                    title: Text('POSTS'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Post()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    tileColor: Colors.blueGrey.shade200,
                    title: Text('ALBUMS'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Albums()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    tileColor: Colors.blueGrey.shade200,
                    title: Text('TODOS'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Todos()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    } else {
      SystemNavigator.pop();
    }
    return Future.value(true);
  }
}
