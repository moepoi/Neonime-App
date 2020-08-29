import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<dynamic> getMovie(String page) async {
  try {
    List images = <String>[];
    List links = <String>[];
    List titles = <String>[];
    final response = await http
        .get('https://neonime.vip/movies/page/$page/')
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

Future<dynamic> getMovieDetail(String url) async {
  try {
    List<String> streamUrls = <String>[];
    List<String> downloadUrls = <String>[];
    final response = await http.get(url);
    var document = parse(response.body);
    document.getElementsByClassName('movieplay').forEach((x) {
      if (x.getElementsByTagName('iframe').isNotEmpty) {
        streamUrls.add(x.getElementsByTagName('iframe')[0].attributes['data-src']);
      }
    });
    var downloadBox = document.getElementsByClassName('sbox')[2];
    downloadBox.getElementsByTagName('a').forEach((x) {
      downloadUrls.add(x.attributes['href']);
    });
    var imageBox = document.getElementsByClassName('imagen')[0];
    var image = imageBox.getElementsByTagName('img')[0].attributes['data-src'];
    var detailBox = document.getElementsByClassName('data')[0];
    var title = detailBox.getElementsByTagName('h1')[0].text;
    var descBox = document.getElementsByClassName('entry-content')[0];
    var description = descBox.getElementsByTagName('p');
    final data = {
      'title': title,
      'description': description[1].text.length > 250 ? description[1].text : description[2].text,
      'image': image.replaceAll(new RegExp(r'\/w(\d\d\d)\/'), '/original/'),
      'stream_url': streamUrls,
      'download_url': downloadUrls
    };
    return data;
  } catch (e) {
    print(e);
    throw FormatException('ntah lah');
  }
}
