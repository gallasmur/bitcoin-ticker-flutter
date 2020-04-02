import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';
import 'coin_data.dart';
import 'coin_data.dart';
import 'networking_helper.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'USD';
  Map<String, String> exchanges = {};
  NetworkingHelper networkingHelper = NetworkingHelper();

  DropdownButton getDropDownButton() {
    return DropdownButton(
      value: _selectedCurrency,
      items: [
        for (String coin in currenciesList)
          DropdownMenuItem<String>(
            value: coin,
            child: Text(coin),
          )
      ],
      onChanged: (value) {
        setState(() {
          _selectedCurrency = value;
          getExchangeRates();
        });
      },
    );
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        _selectedCurrency = currenciesList[selectedIndex];
        getExchangeRates();
      },
      children: <Widget>[for (String item in currenciesList) Text(item)],
    );
  }

  Widget getPicker() {
    if (Platform.isAndroid) {
      return getDropDownButton();
    } else {
      return getCupertinoPicker();
    }
  }

  getExchangeRates() async {
////    double BTC =
////        await networkingHelper.getExchangeRate('BTC', _selectedCurrency);
////    setState(() {
////      _exchangeBTC = BTC.toStringAsFixed(2);
//    });
    for (String crypto in cryptoList) {
      double exchange =
          await networkingHelper.getExchangeRate(crypto, _selectedCurrency);
      setState(() {
        exchanges[crypto] = exchange.toStringAsFixed(2);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getExchangeRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (String coin in cryptoList)
            CardWidget(
              crypto: coin,
              exchanges: exchanges,
              selectedCurrency: _selectedCurrency,
            ),
          Spacer(
            flex: 1,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key key,
    @required this.exchanges,
    @required String selectedCurrency,
    @required this.crypto,
  })  : _selectedCurrency = selectedCurrency,
        super(key: key);

  final Map<String, String> exchanges;
  final String _selectedCurrency;
  final String crypto;

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
            '1 $crypto = ${exchanges[crypto]} $_selectedCurrency',
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
