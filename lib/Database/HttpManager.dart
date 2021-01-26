import 'package:http/http.dart' as http;

class HttpManager {
  Future<String> getNumberPlate(String url) async {
    url = url
        .replaceAll('https', 'secure')
        .replaceAll('/', 'slash')
        .replaceAll('.', 'dot')
        .replaceAll(':', 'colon')
        .replaceAll('-', 'dash')
        .replaceAll('&', 'ampersand')
        .replaceAll('%', 'per')
        .replaceAll('?', 'ques');

    String baseUrl = 'http://10.0.0.127:5000/number-plate/';
    print("URL is ${baseUrl + url}");
    http.Response res = await http.get(baseUrl + url);
    return res.body;
  }
}
