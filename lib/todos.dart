// ignore_for_file: prefer_const_constructors, unused_field, unnecessary_brace_in_string_interps, avoid_print

import 'package:app_1/todos_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todos extends StatefulWidget {
  const Todos({Key? key}) : super(key: key);

  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  final url = "https://jsonplaceholder.typicode.com/todos";
  Future<List<TodosModel>> _fetchPosts() async {
    await _loadCounter();

    final url = "https://jsonplaceholder.typicode.com/todos/?userId=${_id}";
    try {
      final response = await http.get(Uri.parse(url));
      return todosModelFromJson(response.body);
    } catch (err) {
      return [];
    }
  }

  String? _email, _name;
  late int _id;

  _loadCounter() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _id = (_prefs.getInt('id') ?? '' as int);
    print('object:$_id');
    _name = (_prefs.getString('name') ?? '');
    _email = (_prefs.getString('email') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Todos'),
        ),
        body: FutureBuilder<List<TodosModel>>(
          future: _fetchPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 180,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             Comments(id: snapshot.data![index].id)));
                        },
                        child: Card(
                          color: Colors.blueGrey.shade100,
                          shadowColor: Colors.black,
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID:${snapshot.data![index].id.toString()}',
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                'TITLE:${snapshot.data![index].title}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
              ),
            );
          },
        ));
  }
}
