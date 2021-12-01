// ignore_for_file: prefer_const_declarations, prefer_const_constructors, avoid_print, unnecessary_brace_in_string_interps, prefer_const_constructors_in_immutables

import 'package:app_1/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Comments extends StatefulWidget {
  final int id;
  Comments({Key? key, required this.id}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  Future<List<CommentsModel>> _fetchComments() async {
    await _loadCounter1();

    print("---------->${widget.id}");
    final url =
        "https://jsonplaceholder.typicode.com/comments/?postId=${widget.id}";
    try {
      final response = await http.get(Uri.parse(url));
      return commentsModelFromJson(response.body);
    } catch (err) {
      return [];
    }
  }

  late int _id1;

  _loadCounter1() async {
    SharedPreferences _prefss = await SharedPreferences.getInstance();
    _id1 = (_prefss.getInt('id') ?? '' as int);
    print('text:$_id1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Comments'),
        ),
        body: FutureBuilder<List<CommentsModel>>(
          future: _fetchComments(),
          builder: (context, AsyncSnapshot<List<CommentsModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 180,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                              'NAME:${snapshot.data![index].name}',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'E-MAIL:${snapshot.data![index].email}',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'BODY:${snapshot.data![index].body}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
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
