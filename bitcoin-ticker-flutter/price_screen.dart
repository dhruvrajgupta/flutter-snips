import 'dart:convert';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/crypto_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  static var cryptoData;
  String selectedCurrency = 'USD';
  String btcPrice = "?";
  static var cryptoMap = Map();

  @override
  void initState() {
    super.initState();
    for (String symbol in cryptoList) {
      cryptoMap[symbol] = "?";
    }
    getCryptoData(selectedCurrency);
  }

  void getCryptoData(String targetCurrency) async {
    try {
      cryptoData = await CoinData().getCryptoData(targetCurrency);
      print(cryptoData);
    } catch (e) {
      print(e);
    }

    if (cryptoData != null) {
      updateUI();
    }
  }

  void updateUI() {
    setState(() {
      for (String symbol in cryptoList) {
        cryptoMap[symbol] =
            jsonDecode(cryptoData)["rates"][symbol].toStringAsFixed(2);
      }
      btcPrice = jsonDecode(cryptoData)["rates"]["BTC"].toStringAsFixed(2);
      selectedCurrency = jsonDecode(cryptoData)["target"];
    });
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String symbol in cryptoList) {
      cryptoCards.add(CryptoCard(
        value: cryptoMap[symbol],
        selectedCurrency: selectedCurrency,
        cryptoCurrency: symbol,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
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
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getAndroidDropdown(),
          ),
        ],
      ),
    );
  }

  CupertinoPicker getIOSPicker() {
    List<Text> pickerValues = [];
    for (String currency in currenciesList) {
      pickerValues.add(Text(currency));
    }

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 19),
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      children: pickerValues,
      onSelectedItemChanged: (value) {
        getCryptoData(currenciesList[value]);
      },
    );
  }

  DropdownButton<String> getAndroidDropdown() {
    List<DropdownMenuItem<String>> dropdownItem = [];
    for (String currency in currenciesList) {
      dropdownItem.add(DropdownMenuItem(
        value: currency,
        child: Text(currency),
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItem,
      onChanged: (value) {
        setState(() {
          getCryptoData(value);
        });
      },
    );
  }
}
