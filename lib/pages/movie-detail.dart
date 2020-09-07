import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async_loader/async_loader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:neonime_app/scrapper/movie.dart';

// ignore: must_be_immutable
class MovieDetail extends StatelessWidget {
  final GlobalKey<AsyncLoaderState> asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  InAppWebViewController webView;

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
            initState: () async => await getMovieDetail(postUrl),
            renderLoad: () => new CircularProgressIndicator(),
            renderError: ([error]) {
              print(error);
              return Text(error.toString());
            },
            renderSuccess: ({data}) {
              return Center(
                child: ListView(
                  children: [
                    Container(
                      height: 200,
                      child: Center(
                        child: InAppWebView(
                          initialUrl: data['stream_url'][0],
                          onWebViewCreated:
                              (InAppWebViewController controller) {
                            webView = controller;
                          },
                          initialOptions: InAppWebViewGroupOptions(
                              android: AndroidInAppWebViewOptions(
                                  useWideViewPort: false)),
                        ),
                      ),
                    ),
                    Card(
                        child: Container(
                      margin: EdgeInsets.all(5),
                      child: Text(
                        data['description'],
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
                    Card(
                      child: InkWell(
                        onTap: () {},
                        child: Row(
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
                                    errorWidget: (context, url, error) => Image.asset('lib/assets/image-error.webp'),
                                    fadeOutDuration: Duration(milliseconds: 5),
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: 120,
                                      height: 130,
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
                              flex: 5,
                              child: Text(
                                data['title'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: CupertinoButton.filled(
                          child: Text('Click to Download'),
                          onPressed: () {
                            List<CupertinoActionSheetAction> listButton =
                                List<CupertinoActionSheetAction>();
                            var counter = 0;
                            data['download_url'].forEach((link) {
                              counter++;
                              listButton.add(CupertinoActionSheetAction(
                                child: Text(
                                  'Download #${counter.toString()}',
                                ),
                                onPressed: () {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text('Your Download Link'),
                                          content: Text(link),
                                          actions: [
                                            CupertinoDialogAction(
                                              child: Text('Go'),
                                              onPressed: () async {
                                                await InAppBrowser
                                                    .openWithSystemBrowser(
                                                        url: link);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                      barrierDismissible: true);
                                },
                              ));
                            });
                            if (listButton.length > 5) {
                              listButton.removeRange(5, listButton.length);
                            }
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return CupertinoActionSheet(
                                    title: Text('Download Link'),
                                    message:
                                        Text('Click the button to download'),
                                    actions: listButton,
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
