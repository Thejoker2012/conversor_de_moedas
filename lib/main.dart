import 'package:flutter/material.dart';

import 'package:http/http.dart' as http; //biblioteca para acessar requisições web
import 'package:async/async.dart';
import 'dart:convert'; //biblioteca para converter strings para json

const request = "";

void main() async{ //Funcão principal

  http.Response response = await http.get(request);
  print(json.decode(response.body)["results"]["currencies"]["USD"]);



  runApp(MaterialApp(
    home: Container(),
  ));
}