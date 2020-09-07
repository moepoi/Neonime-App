import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:neonime_app/components/initializer.dart';
import 'package:neonime_app/pages/home.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    super.initState();
    splashScreen();
  }

  splashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () async {
      await initializer().then((data) {
        if (data['version'] != appVersion) {
          showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('Please Update your App !!!'),
                content: Text('Current Version : $appVersion'),
                actions: [
                  CupertinoDialogAction(
                    child: Text('Update Now'),
                    onPressed: () async {
                      await InAppBrowser.openWithSystemBrowser(url: data['update_url']);
                    },
                  )
                ],
              );
            },
            barrierDismissible: false
          );
        } else if (data['message']['enable']) {
          if (!data['message']['closeable']) {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(data['message']['text']),
                  content: Text('Current Version : $appVersion'),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Close'),
                      onPressed: () async {
                        await SystemNavigator.pop();
                      },
                      isDestructiveAction: true,
                    )
                  ],
                );
              },
              barrierDismissible: false
            );
          } else {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(data['message']['text']),
                  content: Text('Current Version : $appVersion'),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (BuildContext context) => Home()
                        ));
                      },
                    )
                  ],
                );
              },
              barrierDismissible: false
            );
          }
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (BuildContext context) => Home()
          ));
        }
      }).catchError((e) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('No Internet Connection'),
              content: Text('Current Version : $appVersion'),
              actions: [
                CupertinoDialogAction(
                  child: Text('Close'),
                  onPressed: () async {
                    await SystemNavigator.pop();
                  },
                  isDestructiveAction: true,
                )
              ],
            );
          },
          barrierDismissible: false
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/splash.webp')
                  )
                ),
              ),
              Text('NEONIME (BETA)', style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))
            ],
          )
        ),
      ),
    );
  }
}
