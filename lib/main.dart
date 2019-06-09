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
  return json.decode(response.body);//Converter os dados que chegaram pelo response para json
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( //Widget que permite usar a barra superior na Tela
      backgroundColor: Colors.blue,//Cor de fundo da tela
      appBar: AppBar( //widget barra superior
        title: Text("Conversor de Moedas"),//Titulo da barra superior
        backgroundColor: Colors.green, //Cor da barra superior
        centerTitle: true,//Alinhamento do titulo
      ),
    );
  }
}
