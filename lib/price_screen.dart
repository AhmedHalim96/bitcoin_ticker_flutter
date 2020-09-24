import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String selectedVal = 'USD';
  String btcER = '???';
  String etcER = '???';
  String ltcER = '???';

  CoinData coinData = CoinData();

  getCoinData(val) async {
    final coinExchangeRates = await coinData.requestCoinsExchangeRate(val);
    this.setState(() {
      selectedCurrency = val;
      btcER = coinExchangeRates['BTC'].toStringAsFixed(1);
      etcER = coinExchangeRates['ETC'].toStringAsFixed(1);
      ltcER = coinExchangeRates['LTC'].toStringAsFixed(1);
    });
  }

  DropdownButton androidDropDownButton() {
    List<DropdownMenuItem<String>> currencies = [];
    for (String currency in currenciesList) {
      currencies.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }
    return DropdownButton<String>(
      value: selectedVal,
      items: currencies,
      onChanged: (val) async {
        this.setState(() {
          selectedVal = val;
        });
        await this.getCoinData(val);
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> currencies = [];
    for (String currency in currenciesList) {
      currencies.add(Text(
        currency,
        style: TextStyle(color: Colors.white),
      ));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (i) => print(i),
      children: currencies,
    );
  }

  @override
  void initState() {
    super.initState();
    this.getCoinData(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PaddedCard(
                coin: 'BTC',
                currency: selectedCurrency,
                exachangeRate: btcER,
              ),
              PaddedCard(
                coin: 'ETC',
                currency: selectedCurrency,
                exachangeRate: etcER,
              ),
              PaddedCard(
                coin: 'LTC',
                currency: selectedCurrency,
                exachangeRate: ltcER,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.operatingSystem == 'android'
                ? androidDropDownButton()
                : iosPicker(),
          )
        ],
      ),
    );
  }
}

class PaddedCard extends StatelessWidget {
  PaddedCard(
      {@required this.coin,
      @required this.currency,
      @required this.exachangeRate});
  final String coin;
  final String currency;
  final String exachangeRate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coin = $exachangeRate $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
