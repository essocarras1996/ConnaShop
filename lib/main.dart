import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'AppDesactiva.dart';
import 'MyHttpOverrides.dart';
import 'Constantes/constants.dart';
import 'package:http/http.dart' as http;
import 'activation.dart';
import 'navigation_home_screen.dart';
import 'package:cannonshop/Constantes/ZonaTimeApi.dart';






Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Settings.init(cacheProvider: SharePreferenceCache());
  bool? act=Settings.getValue<bool>('key-actives', defaultValue: false)??false;
  bool? appActive=Settings.getValue<bool>('key-appactive', defaultValue: true)??true;

  MethodChannel platform = MethodChannel('backgroundservice');
  runApp(await platform.invokeMethod('security')=='-1558055581'?MyApp(active: act,appActive:appActive):MaterialApp(
      title: 'ConnaShop',
      debugShowCheckedModeBanner: false,
      home:AppDesactive(),
  ));
}

class MyApp extends StatefulWidget {
  final bool active;
  final bool appActive;
  const MyApp({Key? key, required this.active,required this.appActive}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState(active,appActive);
}
class _MyAppState extends State<MyApp> {
  final bool active;
  final bool appActive;
  late bool appActivef;
  late bool time=true;



  MethodChannel platform = MethodChannel('backgroundservice');

  _MyAppState(this.active,this.appActive);

  @override
  void initState() {
    appActivef=appActive;
    setActiveAPP();
    getZoneTime();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: colorDominante,//color bottomBar
      systemNavigationBarDividerColor: colorDominante,// color de dividir bottomBar de screen es una linea
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,

    );
    HttpOverrides.global = new MyHttpOverrides();
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    return MaterialApp(
      title: 'ConnaShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: time?(appActivef? (active?NavigationHomeScreen():Activation()):AppDesactive()):Scaffold(body: Center(
        child: Text('La fecha del teléfono no coincide',style: TextStyle(fontFamily: 'Ubuntu',color: Theme.of(context).primaryColor),),
      ),),
    );
  }
  hours(){
    DateTime fecha1 =DateTime.parse('2022-07-17 00:00:00Z');
    DateTime fecha2 =DateTime.parse('2022-08-17 00:00:00Z');

    // DateTime fecha2 =DateTime.now();

    DateTime horaTotal = fecha1.add(Duration(days: fecha2.day,hours: fecha2.hour,minutes: fecha2.minute));
    Duration duration=fecha2.difference(fecha1);
    print(duration.inDays);
    print(duration.inHours);
    print(duration.inMinutes);
    print('viejo');
    print(horaTotal);
    print(horaTotal.day);
    print(horaTotal.hour);
    print(horaTotal.minute);
    print(horaTotal.second);
    print('Tiempo total ${horaTotal.hour*60+horaTotal.minute}');
  }

  setActiveAPP() async {
  print('esta $active');
    try {
      var data ={'version': '1.0.0'};
      var response = await http.post(Uri.parse('https://whizzlyshop.com/api/activeapp'),body: data);
      print(response.body);
      print(response.body);
      if(response.body.toString().toLowerCase().contains("false")){
        appActivef=false;
        Settings.setValue<bool>('key-appactive', false);
        setState(() {

        });
      }else{
        appActivef=true;
        Settings.setValue<bool>('key-appactive', true);
        setState(() {

        });
      }
    }catch(a){

    }
  }

  Future<void>getZoneTime() async {

    try {
      var customHeaders = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101 Firefox/98.0',
        'Accept': '*/*',
      };
      var dio = Dio()
        ..options.connectTimeout = 60000
        ..options.receiveTimeout = 60000
        ..options.sendTimeout = 60000
        ..options.baseUrl = "http://worldtimeapi.org/api/"
        ..options.responseType = ResponseType.json
        ..options.headers = customHeaders
        ..options.followRedirects = true
        ..options.receiveDataWhenStatusError = false
        ..options.validateStatus = (status) {
          return status! < 504;
        };

      var response = await dio.get('/timezone/America/Havana');
      int? status_code = response.statusCode;
      if(status_code==200){
        var zonaTime= ZonaTimeApi.fromJson(response.data);
        String timeAPI=zonaTime.datetime!.substring(0,10);
        var now = new DateTime.now();
        String timeAPP=now.toString().substring(0,10);
        if(timeAPP==timeAPI){
          setState(() {
            time=true;
          });
        }else{
          setState(() {
            time=false;
          });
        }

      }

      setState(() {

      });
    } catch (r) {
      getZoneTime();
    }
  }





}

