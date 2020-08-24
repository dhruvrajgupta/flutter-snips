import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  String baseUrl = "http://api.coinlayer.com/live";
  String apiKey = "API KEY";

  Future getCryptoData(String targetCurrency) async {
    print(targetCurrency);
    http.Response response =
        await http.get("$baseUrl?access_key=$apiKey&target=$targetCurrency");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("Error: There was some error in fetching data");
      throw 'Problem fetching data';
    }
  }
}
