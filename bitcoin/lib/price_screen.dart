import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'USD';
  List<String> currencyPriceList = ['?', '?', '?'];

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String coin in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(coin),
        value: coin,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> items = [];
    for (String coin in currenciesList) {
      Text newItem = Text(coin);
      items.add(newItem);
    }
    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
          });
        },
        children: items);
  }

//Crea una lista de widgets que luego se alimenta a un Column como sus children
  Widget makeCards() {
    List<CoinCards> cards = [];
    for (String baseCoin in cryptoList) {
      cards.add(CoinCards(
        currencyPriceList: currencyPriceList[cryptoList.indexOf(baseCoin)],
        selectedCurrency: selectedCurrency,
        bCoin: baseCoin,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cards,
    );
  }

  void getData(String? quoteCoin) async {
    CoinData coinData = CoinData();
    for (String baseCoin in cryptoList) {
      var body = await coinData.getDataCoin(quoteCoin, baseCoin);
      double rate = body['rate'];
      setState(() {
        currencyPriceList[cryptoList.indexOf(baseCoin)] =
            rate.toStringAsFixed(2);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData(selectedCurrency);
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
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          )
        ],
      ),
    );
  }
}


class CoinCards extends StatelessWidget {
  CoinCards(
      {required this.currencyPriceList,
      required this.selectedCurrency,
      required this.bCoin});

  final String currencyPriceList;
  final String? selectedCurrency;
  final String bCoin;

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
            '1 $bCoin = $currencyPriceList $selectedCurrency',
            textAlign: TextAlign.center,
            style: kPairStyle,
          ),
        ),
      ),
    );
  }
}

/*
Error Code 	Meaning
400 	Bad Request -- There is something wrong with your request
401 	Unauthorized -- Your API key is wrong
403 	Forbidden -- Your API key doesnt't have enough privileges to access this resource
429 	Too many requests -- You have exceeded your API key rate limits
550 	No data -- You requested specific single item that we don't have at this moment.
*/
