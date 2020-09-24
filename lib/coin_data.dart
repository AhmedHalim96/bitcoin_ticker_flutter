import 'dart:convert';

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

class CoinData {
  String _url = 'https://rest.coinapi.io/v1/exchangerate/';
  String _apiKey = 'A0AFFC7B-11EF-4ADA-8AC0-CFECC4435E83';
  Map _output = {'BTC': 0, 'ETC': 0, 'LTC': 0};

  Future requestCoinsExchangeRate(String currency) async {
    for (String coin in _output.keys) {
      await http
          .get(_url + coin + '/' + currency,
              headers: {'X-CoinAPI-Key': _apiKey})
          .then((res) => {_output[coin] = jsonDecode(res.body)['rate']})
          .catchError((err) => print(err));
    }
    return _output;
  }
}
