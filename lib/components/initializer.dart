import 'dart:convert';
import 'package:http/http.dart' as http;

final appVersion = '1.0.0';

dynamic initializer() async {
  final urlConfig = 'https://gitlab.com/moepoi/neonime-app/-/raw/master/info.json';
  final response = await http.get(urlConfig);
  var res = json.decode(response.body);
  return res;
}