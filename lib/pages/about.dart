import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 220),
                child: Text(
                  'This App Created By',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                )
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/assets/creator.webp'),
                    fit: BoxFit.scaleDown
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20, bottom: 220),
              child: Text('Moe Poi ~', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
