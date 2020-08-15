import 'dart:convert';

import 'package:bitcoin_ticker/coin_data.dart';
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

  @override
  void initState() {
    super.initState();
    getCryptoData();
  }

  void getCryptoData() async {
    try {
      cryptoData = await CoinData().getCryptoData();
    } catch (e) {
      print(e);
    }

    if (cryptoData != null) {
      updateUI();
    }
  }

  void updateUI() {
    setState(() {
      btcPrice = jsonDecode(cryptoData)["rates"]["BTC"].toStringAsFixed(2);
    });
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
          Padding(
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
                  '1 BTC = $btcPrice USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
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
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      children: pickerValues,
      onSelectedItemChanged: (value) {
        print(value);
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
          print(value);
          selectedCurrency = value;
        });
      },
    );
  }
}
