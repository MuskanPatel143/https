// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';

import 'package:app_1/photos_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Photos extends StatefulWidget {
  final int id;
  const Photos({Key? key, required this.id}) : super(key: key);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  Future<List<PhotosModel>> _fetchPhotos() async {
    await _loadCounter1();

    print("---------->${widget.id}");
    final url =
        "https://jsonplaceholder.typicode.com/photos/?albumId=${widget.id}";
    try {
      final response = await http.get(Uri.parse(url));
      return photosModelFromJson(response.body);
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
          title: Text('Photos'),
        ),
        body: FutureBuilder<List<PhotosModel>>(
          future: _fetchPhotos(),
          builder: (context, AsyncSnapshot<List<PhotosModel>> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  // return Container(
                  //   height: 180,
                  //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  //   child: Card(
                  //     color: Colors.blueGrey.shade100,
                  //     shadowColor: Colors.black,
                  //     elevation: 5,
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'ID:${snapshot.data![index].id.toString()}',
                  //           style: TextStyle(color: Colors.black),
                  //         ),
                  //         Text(
                  //           'TITLE:${snapshot.data![index].title}',
                  //           style: TextStyle(color: Colors.black),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 15, right: 8, left: 8),
                    // child: Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(30),
                    //       image: DecorationImage(
                    //           image: NetworkImage(
                    //               snapshot.data![index].thumbnailUrl),
                    //           fit: BoxFit.cover)),
                    // ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blueGrey.shade200,
                      child: Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'TITLE:${snapshot.data![index].title}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        // height: 150,
                        // width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: NetworkImage(
                                    snapshot.data![index].thumbnailUrl),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
              );
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
