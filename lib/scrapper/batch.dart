import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<dynamic> getBatch(String page) async {
  try {
    List<String> images = <String>[];
    List<String> links = <String>[];
    List<String> titles = <String>[];
    final response = await http.get('https://neonime.moe/batch/page/$page/');
    var document = parse(response.body);
    var items = document.getElementsByClassName('item');
    items.forEach((item) {
      images.add(item.getElementsByTagName('img')[0].attributes['data-wpfc-original-src']);
      links.add(item.getElementsByTagName('a')[0].attributes['href']);
      titles.add(item.getElementsByClassName('title')[0].text);
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

Future<dynamic> getBatchDetail(String url) async {
  try {
    List<String> info = <String>[];
    List<String> downloadUrls = <String>[];
    final response = await http.get(url);
    var document = parse(response.body);
    var contentBox = document.getElementsByClassName('entry-content')[0];
    var title = contentBox.getElementsByTagName('h1')[0].text;
    var image = contentBox.getElementsByTagName('img')[0].attributes['data-wpfc-original-src'];
    var description = contentBox.getElementsByTagName('p');
    contentBox.getElementsByClassName('spaceit').forEach((x) {
      info.add(x.text);
    });
    contentBox.getElementsByClassName('smokeurl')[0].getElementsByTagName('a').forEach((x) {
      downloadUrls.add(x.attributes['href']);
    });
    final data = {
      'title': title,
      'description': description[2].text.length > 100 ? description[2].text : description[3].text,
      'info': info.join('\n\n'),
      'image': image.replaceAll(new RegExp(r'\/w(\d\d\d)\/'), '/original/'),
      'download_url': downloadUrls
    };
    return data;
  } catch (e) {
    print(e);
    throw FormatException('ntah lah');
  }
}