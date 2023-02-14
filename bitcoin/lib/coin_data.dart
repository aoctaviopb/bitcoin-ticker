import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const kPairStyle = TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      );


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
  Future getDataCoin(String? quoteCoin, String baseCoin) async {
    //https://docs.coinapi.io/#md-docs
    http.Response info = await http.get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/$baseCoin/$quoteCoin?apikey=774F3C5F-9595-44B9-A2A3-140D84F02B49'));
    if (info.statusCode == 200) {
      return jsonDecode(info.body);
    } else {
      print('Can connect. Error ${info.statusCode}');
      throw 'Problem with the get request';
    }
  }
}
