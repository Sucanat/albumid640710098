import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PhotoAlbum {
  final int userId;
  final int id;
  final String title;

  PhotoAlbum({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory PhotoAlbum.fromJson(Map<String, dynamic> json) {
    return PhotoAlbum(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<PhotoAlbum>? _albumList;
  String? _error;

  void getPhotoAlbums() async {
    try {
      setState(() {
        _error = null;
      });

      final response = await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.data.toString());

      List list = jsonDecode(response.data.toString());
      // Use a Set to keep track of unique user IDs
      Set<int> uniqueUserIds = Set();
      setState(() {
        _albumList = list.map((item) {
          final album = PhotoAlbum.fromJson(item);
          uniqueUserIds.add(album.userId);
          return album;
        }).toList();
      });

      // Print the number of unique user IDs
      debugPrint('Number of unique user IDs: ${uniqueUserIds.length}');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('Error: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getPhotoAlbums();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              getPhotoAlbums();
            },
            child: const Text('RETRY'),
          )
        ],
      );
    } else if (_albumList == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = Column(
        children: [
          Text('Number of unique user IDs: ${_getUniqueUserIdsCount()}'),
          Expanded(
            child: ListView.builder(
              itemCount: _albumList!.length,
              itemBuilder: (context, index) {
                var album = _albumList![index];
                return Card(
                  color: Colors.lightBlue[50], // Setting the background color of the card
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(album.title),
                      subtitle: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.purpleAccent, // Setting the background color of the container
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                'Album ID: ${album.id}',
                                style: TextStyle(
                                  color: Colors.white, // Setting the text color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.teal, // Setting the background color of the container
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                'User ID: ${album.userId}',
                                style: TextStyle(
                                  color: Colors.white, // Setting the text color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return Scaffold(body: body);
  }

  int _getUniqueUserIdsCount() {
    return _albumList?.map((album) => album.userId).toSet().length ?? 0;
  }
}
