import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<dynamic> getGenre(String type, String page) async {
  try {
    List images = <String>[];
    List links = <String>[];
    List titles = <String>[];
    final response = await http
        .get('https://neonime.vip/tvshows-genre/$type/page/$page/')
        .catchError((e) {
      print(e);
    });
    var document = parse(response.body);
    var table = document.getElementsByClassName('item_1 items')[0];
    table.getElementsByTagName('img').forEach((x) {
      images.add(x.attributes['data-src']);
    });
    table.getElementsByClassName('item').forEach((x) {
      links.add(x.getElementsByTagName('a')[0].attributes['href']);
    });
    table.getElementsByClassName('title-episode-movie').forEach((x) {
      titles.add(x.text);
    });
    var data = <dynamic>[];
    for (var i = 0; i < links.length; i++) {
      data.add({
        'image': images[i].replaceAll(new RegExp(r'\/w(\d\d\d)\/'), '/original/'),
        'link': links[i],
        'title': titles[i]
      });
    }
    return data;
  } catch (e) {
    print(e);
    throw FormatException('ntah lah');
  }
}
