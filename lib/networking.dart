import 'package:http/http.dart' as http;
import 'dart:convert';

class Networker{

  final String baseUri = 'https://apiv2.bitcoinaverage.com/indices/global/ticker';
  final String btcCurrency;

  Networker({this.btcCurrency});

  Future<double> getData(String calcCurrency) async{
    http.Response data = await http.get('$baseUri/$btcCurrency$calcCurrency');
    if(data != null) {
      if(data.statusCode == 200){
        var jsonData = jsonDecode(data.body);
        return jsonData["last"];
      }else{
        print(data.statusCode);
        return 0.0;
      }
    }
    return 0.0;
  }

}