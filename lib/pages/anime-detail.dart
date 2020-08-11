import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async_loader/async_loader.dart';
import 'package:neonime_app/scrapper/anime.dart';

import 'episode-detail.dart';

class AnimeDetail extends StatelessWidget {
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  @override
  Widget build(BuildContext context) {
    final argsData = ModalRoute.of(context).settings.arguments as Map;
    final title = argsData['title'];
    final postUrl = argsData['url'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: AsyncLoader(
            key: asyncLoaderState,
            initState: () async => await getAnimeDetail(postUrl),
            renderLoad: () => new CircularProgressIndicator(),
            renderError: ([error]) {
              print(error);
              return Text(error.toString());
            },
            renderSuccess: ({data}) {
              return Center(
                  child: ListView(
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: data['image'],
                              placeholder: (context, url) => CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) => Image.asset('lib/assets/image-error.jpg'),
                              fadeOutDuration: Duration(milliseconds: 5),
                              imageBuilder: (context, imageProvider) => Container(
                                width: 120,
                                height: 160,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Container(
                            margin: EdgeInsets.all(8),
                            child: Text(
                              data['title'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            )),
                      )
                    ],
                  ),
                  Card(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Text(data['description']),
                    ),
                  ),
                  Container(
                    height: 542,
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                        itemCount: data['episode_title'].length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(8),
                            child: CupertinoButton.filled(
                              child: Text(data['episode_title'][index]),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EpisodeDetail(),
                                        settings: RouteSettings(arguments: {
                                          'title': data['episode_title'][index],
                                          'url': data['episode_url'][index]
                                        })));
                              },
                            ),
                          );
                        }),
                  ),
                ],
              ));
            }),
      ),
    );
  }
}
