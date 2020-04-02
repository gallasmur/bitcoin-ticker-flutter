import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkingHelper {
  final String url = 'https://rest.coinapi.io/v1/exchangerate';
  final String _apikey = 'BC14EAAE-8366-4A29-848F-CE798A647887';
  double exchange;

  Future<double> getExchangeRate(String coin1, String coin2) async {
    http.Response info = await http.get('$url/$coin1/$coin2?apikey=$_apikey');
    print(info.request);
    print(info.statusCode);

    if (info.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(info.body);
      exchange = map['rate'];
    } else {
      exchange = 0;
    }

    return exchange;
  }
}
