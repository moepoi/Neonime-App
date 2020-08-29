import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<dynamic> getAnime(String page) async {
  try {
    List images = <String>[];
    List links = <String>[];
    List titles = <String>[];
    final response = await http
        .get('https://neonime.vip/tvshows/page/$page/')
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

Future<dynamic> getAnimeDetail(String url) async {
  try {
    List<String> episodes = <String>[];
    List<String> episodesTitles = <String>[];
    final response = await http.get(url);
    var document = parse(response.body);
    var episodeBox = document.getElementsByClassName('episodios')[0];
    episodeBox.getElementsByTagName('a').forEach((x) {
      episodes.add(x.attributes['href']);
      episodesTitles.add(x.text);
    });
    var imageBox = document.getElementsByClassName('imagen')[0];
    var image = imageBox.getElementsByTagName('img')[0].attributes['data-src'];
    var infoBox = document.getElementsByClassName('cover')[0];
    var title = infoBox.getElementsByTagName('h1')[0].text;
    var cover = infoBox.attributes['style'].replaceAll('background-image:url(', '').replaceAll(')', '');
    var contentBox = document.getElementsByClassName('contenidotv')[0];
    var description = contentBox.getElementsByTagName('p');
    final data = {
      'title': title,
      'description': description.length > 2 ? description[1].text : description[0].text,
      'image': image.replaceAll(new RegExp(r'\/w(\d\d\d)\/'), '/original/'),
      'cover': cover,
      'episode_title': episodesTitles,
      'episode_url': episodes
    };
    return data;
  } catch (e) {
    print(e);
    throw FormatException('ntah lah');
  }
}
