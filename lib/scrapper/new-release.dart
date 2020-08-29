import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<dynamic> getNewRelease(String page) async {
  try {
    List images = <String>[];
    List links = <String>[];
    List titles = <String>[];
    final response = await http
        .get('https://neonime.vip/episode/page/$page/')
        .catchError((e) {
      print(e);
    });
    var document = parse(response.body);
    var table = document.getElementsByClassName('list')[0];
    var top = table.getElementsByClassName('imagen-td');
    for (var image in top) {
      images.add(image.getElementsByTagName('img')[0].attributes['data-src']);
    }
    for (var link in top) {
      links.add(link.getElementsByTagName('a')[0].attributes['href']);
    }
    var bottom = table.getElementsByClassName('bb');
    for (var title in bottom) {
      if (title.getElementsByTagName('a').isNotEmpty) {
        titles.add(title.getElementsByTagName('a')[0].text);
      }
    }
    var data = <dynamic>[];
    for (var i = 0; i < links.length; i++) {
      data.add({
        'image': images[i].replaceAll(new RegExp(r'\/w(\d\d\d)\/'), '/original/'),
        'link': links[i],
        'title': titles[i].replaceAll(' Subtitle Indonesia ','')
      });
    }
    return data;
  } catch (e) {
    print(e);
    throw FormatException('ntah lah');
  }
}

Future<dynamic> getEpisodeDetail(String url) async {
  try {
    List<String> streamUrls = <String>[];
    List<String> downloadUrls = <String>[];
    final response = await http.get(url);
    var document = parse(response.body);
    document.getElementsByTagName('iframe').forEach((x) {
      streamUrls.add(x.attributes['data-src']);
    });
    var downloadBox = document.getElementsByClassName('linkstv')[0];
    downloadBox.getElementsByTagName('a').forEach((x) {
      downloadUrls.add(x.attributes['href']);
    });
    var imageBox = document.getElementsByClassName('imagen')[0];
    var image = imageBox.getElementsByTagName('img')[0].attributes['data-src'];
    var detailUrl = imageBox.getElementsByTagName('a')[0].attributes['href'];
    var contentBox = document.getElementsByClassName('contenidotv')[0];
    var title = contentBox.getElementsByTagName('h2')[0].text;
    var description = '';
    contentBox.getElementsByTagName('p').forEach((x) {
      description += x.text + '\n\n';
    });
    var rmv = title.split(' Episode ');
    title = rmv[0].replaceAll('Sinopsis dari anime ', '');
    final data = {
      'title': title,
      'description': description,
      'image': image.replaceAll(new RegExp(r'\/w(\d\d\d)\/'), '/original/'),
      'detail_url': detailUrl,
      'stream_url': streamUrls,
      'download_url': downloadUrls
    };
    return data;
  } catch (e) {
    print(e);
    throw FormatException('ntah lah');
  }
}