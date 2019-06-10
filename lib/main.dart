import 'package:flutter/material.dart';

import 'package:http/http.dart' as http; //biblioteca para acessar requisições web
import 'dart:async';
import 'dart:convert'; //biblioteca para converter strings para json

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=68a55d29";

void main() async{ //Funcão principal

  runApp(MaterialApp(
    home: Home(),
  ));
}

//Esperando os dados que virão do futuro para criar um mapa json
Future<Map> getData() async{
  http.Response response = await http.get(request); //Fazendo uma requisição e esperando os dados chegarem
  print(json.decode(response.body));
  return json.decode(response.body);//Converter os dados que chegaram pelo response para json
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final usdController = TextEditingController();
  final eurController = TextEditingController();
  final gbpController = TextEditingController();
  final arsController = TextEditingController();

  double usd, eur ,gbp ,ars ,btc;

  int _info = 2;

  void _clearAll(){
    realController.text = "";
    usdController.text = "";
    eurController.text = "";
    gbpController.text = "";
    arsController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //Widget que permite usar a barra superior na Tela
      backgroundColor: Colors.blueGrey,//Cor de fundo da tela
      appBar: AppBar( //widget barra superior
        title: Text("Conversor de Moedas"),//Titulo da barra superior
        backgroundColor: Colors.green, //Cor da barra superior
        centerTitle: true,//Alinhamento do titulo
      ),
      body: FutureBuilder<Map>( // Widget FutureBuilder que contém um mapa pois a API vai retorar um mapa
          future: getData(), //Vai pegar os valores futuros vindos do getData e passar para o FutureBuilder
          builder: (context, snapshot){//snapshot é uma fotografia momentania dos dados obtidos do getData
            switch(snapshot.connectionState){//switch para ver o estado dos snapshots
              case ConnectionState.none://caso não estiver conectando em nada
              case ConnectionState.waiting://caso esteja esperando os dados ou uma conexão
                return Center(//Se estiver esperando os dados ele irá mostrear que está carregando dados
                  child: Text("Carregando Dados...",
                  style: TextStyle(color: Colors.green,
                  fontSize: 25.0),
                  textAlign: TextAlign.center,
                  ),
                );
              default:
                if(snapshot.hasError){//Se encontrar algum erro ele retornara Erro ao carregar dados
                  return Center(
                    child: Text("Erro ao Carregar Dados!!!",
                      style: TextStyle(color: Colors.green,
                          fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                else{// Se tudo der certo ele retornará uma página amarela

                  usd = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  eur = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  gbp = snapshot.data["results"]["currencies"]["GBP"]["buy"];
                  ars = snapshot.data["results"]["currencies"]["ARS"]["buy"];

                  void _realTrocar(String text){
                    if(text.isEmpty){
                      _clearAll();
                    }
                    double real = double.parse(text);
                    if(text.isEmpty){
                      _clearAll();
                    }
                    usdController.text = (real/usd).toStringAsFixed(_info);
                    eurController.text = (real/eur).toStringAsFixed(_info);
                    gbpController.text = (real/gbp).toStringAsFixed(_info);
                    arsController.text = (real/ars).toStringAsFixed(_info);
                  }
                  void _usdTrocar(String text){
                    if(text.isEmpty){
                      _clearAll();
                    }
                    double dolar = double.parse(text);
                    realController.text = (dolar * this.usd).toStringAsPrecision(_info);
                    eurController.text = (dolar * this.usd/eur).toStringAsPrecision(_info);
                    gbpController.text = (dolar * this.usd/gbp).toStringAsPrecision(_info);
                    arsController.text = (dolar * this.usd/ars).toStringAsPrecision(_info);
                    print(text);
                  }
                  void _eurTrocar(String text){
                    if(text.isEmpty){
                      _clearAll();
                    }
                    double eur = double.parse(text);
                    realController.text = (eur * this.eur).toStringAsPrecision(_info);
                    usdController.text = (eur * this.eur/usd).toStringAsPrecision(_info);
                    gbpController.text = (eur * this.eur/gbp).toStringAsPrecision(_info);
                    arsController.text = (eur * this.eur/ars).toStringAsPrecision(_info);
                    print(text);
                  }
                  void _gbpTrocar(String text){
                    if(text.isEmpty){
                      _clearAll();
                    }
                    double gbp = double.parse(text);
                    realController.text = (gbp * this.gbp).toStringAsPrecision(_info);
                    usdController.text = (gbp/this.gbp/usd).toStringAsFixed(_info);
                    eurController.text = (gbp/this.gbp/eur).toStringAsFixed(_info);
                    arsController.text = (gbp/this.gbp/ars).toStringAsFixed(_info);
                    print(text);
                  }
                  void _arsTrocar(String text){
                    if(text.isEmpty){
                      _clearAll();
                    }
                    double ars = double.parse(text);
                    realController.text = (gbp * this.gbp).toStringAsPrecision(_info);
                    usdController.text = (ars/this.ars/usd).toStringAsFixed(_info);
                    eurController.text = (ars/this.ars/eur).toStringAsFixed(_info);
                    gbpController.text = (ars/this.ars/gbp).toStringAsFixed(_info);
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,size: 150.0, color: Colors.white),

                        buildTextFields("Reais", "R\$" ,realController, _realTrocar),
                        Divider(),
                        buildTextFields("USD Dólar", "US\$",usdController,_usdTrocar),
                        Divider(),
                        buildTextFields("EUR Euros", "€",eurController,_eurTrocar),
                        Divider(),
                        buildTextFields("GBP Libra", "R\$",gbpController,_gbpTrocar),
                        Divider(),
                        buildTextFields("ARS Peso", "R\$",arsController,_arsTrocar),
                        Divider(),
                      ],
                    ),
                  );
                }

            }
          }),
    );
  }
}
Widget buildTextFields(String label , String prefix, TextEditingController controller , Function func){ //TextField para não precisar repetir código, se está repetindo está errado.

  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.white,
        fontSize: 16.0
    ),
    onChanged: func,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
