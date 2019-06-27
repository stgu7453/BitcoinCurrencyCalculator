import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'networking.dart';
import 'currency_card.dart';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  double btcValue = 0.0;
  double ethValue = 0.0;
  double ltcValue = 0.0;


  Networker btcNetworker = Networker(btcCurrency: "BTC");
  Networker ethNetworker = Networker(btcCurrency: "ETH");
  Networker ltcNetworker = Networker(btcCurrency: "LTC");


  String selectedCurrency = "EUR";
  List <DropdownMenuItem<String>> currencies = [];

  DropdownButton<String> getAndroidPicker(){
    currencies = [];
    for (String currency in currenciesList) {
      currencies.add(DropdownMenuItem(child: Text(currency), value: currency));
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: currencies,
        onChanged: (value){
          setState(() {
            selectedCurrency = value;
            updateGUI();
          });
        });
  }

  CupertinoPicker getIosPicker(){
    List <Text> cupertinoCurrencies = [];
    for(String currency in currenciesList){
      cupertinoCurrencies.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: cupertinoCurrencies,
    );
  }

  @override
  void initState(){
    super.initState();
    updateGUI();
  }

  void updateGUI() async {
    setState(() {
      btcValue = 0.0;
      ethValue = 0.0;
      ltcValue = 0.0;
    });

    double valBtc = await btcNetworker.getData(selectedCurrency);
    double valEth = await ethNetworker.getData(selectedCurrency);
    double valLtc = await ltcNetworker.getData(selectedCurrency);
    setState((){
      btcValue = valBtc;
      ethValue = valEth;
      ltcValue = valLtc;
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CurrencyCard(btcCurrency: "BTC", value: btcValue, calcCurrency: selectedCurrency,),
              CurrencyCard(btcCurrency: "ETH", value: ethValue, calcCurrency: selectedCurrency,),
              CurrencyCard(btcCurrency: "LTC",value: ltcValue, calcCurrency: selectedCurrency,),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIosPicker() : getAndroidPicker(),
          ),
        ],
      ),
    );
  }
}


