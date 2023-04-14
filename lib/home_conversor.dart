import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeConver extends StatefulWidget {
  const HomeConver({Key? key}) : super(key: key);

  @override
  State<HomeConver> createState() => _HomeConverState();
}

class _HomeConverState extends State<HomeConver> {
  final realControl = TextEditingController();
  final dolarControl = TextEditingController();
  final euroControl = TextEditingController();
  final francoSuicoControl = TextEditingController();
  final btcControl = TextEditingController();

  double dolar = 0;
  double euro = 0;
  double francoSuico = 0;
  double btc = 0;

  @override
  void dispose() {
    realControl.dispose();
    dolarControl.dispose();
    euroControl.dispose();
    francoSuicoControl.dispose();
    btcControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Conversor de Moedas'),
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasError) {
              if (snapshot.connectionState == ConnectionState.done) {
                dolar = double.parse(snapshot.data!['USDBRL']['bid']);
                euro = double.parse(snapshot.data!['EURBRL']['bid']);
                francoSuico = double.parse(snapshot.data!['CHFBRL']['bid']);
                btc = double.parse(snapshot.data!['BTCBRL']['bid']);
                // dolar = snapshot.data!['USD']['buy'];
                // euro = snapshot.data!['EUR']['buy'];
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        Icons.monetization_on_outlined,
                        size: 120,
                      ),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Reais ', 'R\$ ', realControl, _convertReal),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Dolares', 'US\$ ', dolarControl, _convertDolar),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'Euros', '€  ', euroControl, _convertEuro),
                      const SizedBox(height: 20),
                      currencyTextField('Franco Suíço', 'FR ',
                          francoSuicoControl, _convertfrancoSuico),
                      const SizedBox(height: 20),
                      currencyTextField(
                          'BitCoin', 'BTC  ', btcControl, _convertBtc),
                    ],
                  ),
                );
              } else {
                return waitingIndicator();
              }
            } else {
              return waitingIndicator();
            }
          },
        ));
  }

  TextField currencyTextField(String label, String prefixText,
      TextEditingController controller, Function f) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixText: prefixText,
      ),
      onChanged: (value) => f(value),
      keyboardType: TextInputType.number,
    );
  }

  Center waitingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _convertReal(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double real = double.parse(text);

    dolarControl.text = (real / dolar).toStringAsFixed(2);

    euroControl.text = (real / euro).toStringAsFixed(2);

    francoSuicoControl.text = (real / francoSuico).toStringAsFixed(2);

    btcControl.text = (real / btc).toStringAsFixed(8);
  }

  void _convertDolar(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double dolar = double.parse(text);

    realControl.text = (this.dolar * dolar).toStringAsFixed(2);

    euroControl.text = ((this.dolar * dolar) / euro).toStringAsFixed(2);

    francoSuicoControl.text =
        ((this.dolar * dolar) / francoSuico).toStringAsFixed(2);

    btcControl.text =
        ((this.dolar * dolar) / btc).toStringAsFixed(8);
  }

  void _convertEuro(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double euro = double.parse(text);

    realControl.text = (this.euro * euro).toStringAsFixed(2);

    dolarControl.text = ((this.euro * euro) / dolar).toStringAsFixed(2);

    francoSuicoControl.text =
        ((this.euro * euro) / francoSuico).toStringAsFixed(2);
    
    btcControl.text =
        ((this.euro * euro) / btc).toStringAsFixed(8);
  }

  void _convertfrancoSuico(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double francoSuico = double.parse(text);

    realControl.text = (this.francoSuico * francoSuico).toStringAsFixed(2);

    dolarControl.text =
        ((this.francoSuico * francoSuico) / dolar).toStringAsFixed(2);

    euroControl.text =
        ((this.francoSuico * francoSuico) / euro).toStringAsFixed(2);

    btcControl.text =
        ((this.francoSuico * francoSuico) / btc).toStringAsFixed(8);
  }

  void _convertBtc(String text) {
    if (text.trim().isEmpty) {
      _clearFields();
      return;
    }

    double btc = double.parse(text);

    realControl.text = (this.btc * btc).toStringAsFixed(2);

    dolarControl.text = ((this.btc * btc) / dolar).toStringAsFixed(2);

    euroControl.text = ((this.btc * btc) / euro).toStringAsFixed(2);

    francoSuicoControl.text =
        ((this.btc * btc) / francoSuico).toStringAsFixed(2);
  }

  void _clearFields() {
    realControl.clear();
    dolarControl.clear();
    euroControl.clear();
    francoSuicoControl.clear();
    btcControl.clear();
  }
}

Future<Map> getData() async {
  //* ENDEREÇO DA API NOVA
  //* https://docs.awesomeapi.com.br/api-de-moedas

  const requestApi =
      "https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL,CHF-BRL,BTC-BRL";
  var response = await http.get(Uri.parse(requestApi));
  return jsonDecode(response.body);

  //* json manual para teste em caso de
  //* problema com a conexão http
/*   var response = {
    "USDBRL": {
      "code": "USD",
      "codein": "BRL",
      "name": "Dólar Americano/Real Brasileiro",
      "high": "5.3388",
      "low": "5.2976",
      "varBid": "0.0382",
      "pctChange": "0.72",
      "bid": "5.3348",
      "ask": "5.3363",
      "timestamp": "1679660987",
      "create_date": "2023-03-24 09:29:47"
    },
    "EURBRL": {
      "code": "EUR",
      "codein": "BRL",
      "name": "Euro/Real Brasileiro",
      "high": "5.7429",
      "low": "5.6772",
      "varBid": "-0.0095",
      "pctChange": "-0.17",
      "bid": "5.7256",
      "ask": "5.7293",
      "timestamp": "1679660999",
      "create_date": "2023-03-24 09:29:59"
    }
  };

  return jsonDecode(jsonEncode(response));
 */
}
