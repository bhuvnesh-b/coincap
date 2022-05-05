import 'dart:convert';
import 'dart:developer';
import 'package:coin_cap/models/app_config.dart';
import 'package:coin_cap/pages/home_page.dart';
import 'package:coin_cap/services/https_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  await GetIt.instance.get<HTTPService>().get("/coins/bitcoin");
  runApp(const MyApp());
}

//loading the features from the coingecko api
Future<void> loadConfig() async {
    String _configContent = 
      await rootBundle.loadString("assets/config/main.json");
    //json decode decodes the json file data to a map 
    Map _configData = jsonDecode(_configContent);
    GetIt.instance.registerSingleton<AppConfig>(
      AppConfig(
          COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"],
        ),
    );
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService> (
    HTTPService(),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'coin_cap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromARGB(255, 173, 138, 138),
      ),
      home: HomePage(),
    );
  }
}

