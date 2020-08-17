import 'package:flutter/material.dart';
import 'package:neonime_app/pages/about.dart';
import 'package:neonime_app/pages/batch.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Drawer(
          child: Column(
        children: [
          Container(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(90),
              // color: Colors.amberAccent,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/assets/drawer-top.jpg'),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.library_books),
                  title: Text('Batch'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Batch(),
                    ));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.schedule),
                  title: Text('Jadwal'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => About(),
                    ));
                  },
                ),
              ],
            ),
          ),
          Flexible(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/assets/drawer-bottom.png'))),
              ))
        ],
      )),
    );
  }
}
