import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<dynamic> getSearch(String query) async {
  try {
    List<String> images = <String>[];
    List<String> links = <String>[];
    List<String> titles = <String>[];
    final response = await http.get('https://neonime.moe/?s=$query');
    var document = parse(response.body);
    var table = document.getElementsByClassName('item_1 items')[0];
    table.getElementsByTagName('img').forEach((x) {
      images.add(x.attributes['data-src'].replaceAll(new RegExp(r'\/w(\d\d\d)\/'), '/original/'));
      titles.add(x.attributes['alt']);
    });
    table.getElementsByClassName('item episode-home').forEach((x) {
      links.add(x.getElementsByTagName('a')[0].attributes['href']);
    });
    var data = <dynamic>[];
    for (var i = 0; i < links.length; i++) {
      data.add({
        'image': images[i].trim(),
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
