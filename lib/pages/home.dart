import 'package:flutter/material.dart';
import 'package:neonime_app/components/drawer.dart';
import 'package:neonime_app/components/search.dart';
import 'package:neonime_app/pages/anime.dart';
import 'package:neonime_app/pages/movie.dart';
import 'package:neonime_app/pages/new-release.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Home'),
            actions: [
              IconButton(icon: Icon(Icons.search), onPressed: () {
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Search()));
              })
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: "New Release"),
                Tab(text: "Anime"),
                Tab(text: "Movie"),
              ],
            ),
          ),
          drawer: MainDrawer(),
          body: TabBarView(
            children: [
              Center(
                child: NewRelease(),
              ),
              Center(
                child: Anime(),
              ),
              Center(
                child: Movie(),
              )
            ],
          )
        ),
      ),
    );
  }
}