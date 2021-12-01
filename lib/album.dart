// ignore_for_file: prefer_const_constructors, unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:app_1/album_model.dart';
import 'package:app_1/photos.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  final url = "https://jsonplaceholder.typicode.com/albums";
  Future<List<AlbumsModel>> _fetchPosts() async {
    await _loadCounter();

    final url = "https://jsonplaceholder.typicode.com/albums/?userId=${_id}";
    try {
      final response = await http.get(Uri.parse(url));
      return albumsModelFromJson(response.body);
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
          title: Text('Albums'),
        ),
        body: FutureBuilder<List<AlbumsModel>>(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Photos(
                                        id: snapshot.data![index].id,
                                      )));
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
