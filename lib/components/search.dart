import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:neonime_app/pages/anime-detail.dart';
import 'package:neonime_app/pages/batch-detail.dart';
import 'package:neonime_app/pages/episode-detail.dart';
import 'package:neonime_app/pages/movie-detail.dart';
import 'package:neonime_app/scrapper/search.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  var theBody;

  Future<Null> _resetAsyncLoader() async {
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  Widget startSearch() {
    return Text('SEARCH RESULT WILL BE HERE !!!');
  }

  Widget loadSearch(String query) {
    return AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await getSearch(query),
        renderLoad: () => new CircularProgressIndicator(),
        renderError: ([error]) {
          return Text('Not Found :(');
        },
        renderSuccess: ({data}) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    if (data[index]['link'].contains('/tvshows/')) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AnimeDetail(),
                        settings: RouteSettings(arguments: {
                          'title': data[index]['title'],
                          'url': data[index]['link']
                        })
                      ));
                    } else if (data[index]['link'].contains('/episode/')) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => EpisodeDetail(),
                        settings: RouteSettings(arguments: {
                          'title': data[index]['title'],
                          'url': data[index]['link']
                        })
                      ));
                    } else if (data[index]['link'].contains('/batch/')) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => BatchDetail(),
                        settings: RouteSettings(arguments: {
                          'title': data[index]['title'],
                          'url': data[index]['link']
                        })
                      ));
                    } else {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => MovieDetail(),
                        settings: RouteSettings(arguments: {
                          'title': data[index]['title'],
                          'url': data[index]['link']
                        })
                      ));
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        child: CachedNetworkImage(
                          imageUrl: data[index]['image'],
                          placeholder: (context, url) => CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) => Image.asset('lib/assets/image-error.webp'),
                          fadeOutDuration: Duration(milliseconds: 5),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 400,
                            height: 210,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover
                              ),
                            ),
                          ),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          data[index]['title'],
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  final searchQuery = TextEditingController();

  @override
  void initState() {
    theBody = startSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchQuery,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          onEditingComplete: () {
            setState(() {
              if (asyncLoaderState.currentState == null) {
                theBody = loadSearch(searchQuery.text);
              } else {
                _resetAsyncLoader().whenComplete(() {
                  theBody = loadSearch(searchQuery.text);
                });
              }
            });
          }
        ),
      ),
      body: Center(
        child: theBody,
      ),
    );
  }
}
