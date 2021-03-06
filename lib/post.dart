// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_final_fields, unused_field, unnecessary_brace_in_string_interps, avoid_print

import 'package:app_1/comments.dart';
import 'package:app_1/post_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final url = "https://jsonplaceholder.typicode.com/posts";
  Future<List<Posts>> _fetchPosts() async {
    await _loadCounter();

    final url = "https://jsonplaceholder.typicode.com/posts/?userId=${_id}";
    try {
      final response = await http.get(Uri.parse(url));
      return postsFromJson(response.body);
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
          title: Text('Posts'),
        ),
        body: FutureBuilder<List<Posts>>(
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
                                  builder: (context) =>
                                      Comments(id: snapshot.data![index].id)));
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
                              Text(
                                'BODY:${snapshot.data![index].body}',
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

  // goToComments() async {
  //   http.Response response = await http.get(
  //     Uri.parse(url),
  //   );

  //   if (response.statusCode == 200) {
  //     List<Posts> post = postsFromJson(response.body);
  //     print(post.first.id);
  //     int index1 = post.indexOf(post[7]).toInt();
  //     SharedPreferences _prefss = await SharedPreferences.getInstance();
  //     // _prefss.setString('userModel', jsonEncode(Posts));
  //     // _prefss.setInt('id', post[index1].id);
  //     // _prefss.setString('title', post[index1].title);
  //     // _prefss.setString('body', post[index1].body);
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => Comments()));

  //     // .where((element) => emailController.text == element.email)
  //     // .first;
  //   }
  // }
}
