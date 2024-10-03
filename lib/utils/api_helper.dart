import 'dart:convert';

import 'package:http/http.dart' as http;

class APIHelper {
  APIHelper._();

  static APIHelper apiHelper = APIHelper._();

  Future<Map?> quotes() async {
    String QuotesAPI = "https://favqs.com/api/quotes";
    http.Response response = await http.get(
      Uri.parse(QuotesAPI),
      headers: {
        'Authorization': 'Token token=7e47039dbee595a0661f2fb005458bf2',
      },
    );

    if (response.statusCode == 200) {
      Map? quotes = jsonDecode(response.body);

      return quotes;
    }
    return null;
  }
}
