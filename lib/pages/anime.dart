import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:neonime_app/scrapper/anime.dart';
import 'anime-detail.dart';

class Anime extends StatefulWidget {
  @override
  _AnimeState createState() => _AnimeState();
}

class _AnimeState extends State<Anime>
    with AutomaticKeepAliveClientMixin<Anime> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  ScrollController _scrollController = new ScrollController();
  List listData;

  Future<Null> _handleRefresh() async {
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _getMoreData() async {
    final nextPage = (listData.length / 15) + 1;
    List newData = await getAnime(nextPage.round().toString()).then((x) {
      return x;
    });
    setState(() {
      listData.addAll(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(),
      child: AsyncLoader(
          key: asyncLoaderState,
          initState: () async => await getAnime('1'),
          renderLoad: () => new CircularProgressIndicator(),
          renderError: ([error]) {
            print(error);
            return Text(error.toString());
          },
          renderSuccess: ({data}) {
            listData = data;
            return ListView.builder(
              controller: _scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnimeDetail(),
                              settings: RouteSettings(arguments: {
                                'title': listData[index]['title'],
                                'url': listData[index]['link']
                              })));
                    },
                    child: Column(
                      children: [
                        Container(
                          child: CachedNetworkImage(
                            imageUrl: listData[index]['image'],
                            placeholder: (context, url) => CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) => Image.asset('lib/assets/image-error.jpg'),
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
                            listData[index]['title'],
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
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
