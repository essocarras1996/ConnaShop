import 'dart:convert';
import 'dart:typed_data';

import 'package:cannonshop/Constantes/constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/services.dart';

import 'BaseDatos/LicenciaObject.dart';
import 'BaseDatos/TuEnvioDatabase.dart';
import 'Constantes/ActiveJson.dart';
import 'Constantes/rounded_button.dart';

class Activation extends StatefulWidget {
  const Activation({Key? key}) : super(key: key);

  @override
  State<Activation> createState() => _ActivationState();
}

class _ActivationState extends State<Activation> {
  var _controllerNombre = TextEditingController();
  bool isActive=false;
  String appId="";
  String keyUnique="";
  String path="";
  bool check= false;
  String model="Desconocido";
  String code_encryption="";
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  @override
  initState() {
    // TODO: implement initState
    getApplicationID();
    getCode();
    initPlatformState();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorDominante,
      appBar: AppBar(
        backgroundColor: colorDominante,
        title: Text(
          'Activación',
          style: TextStyle(
            fontFamily: 'Ubuntu',
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        elevation: 0,
      ),
      body: appId=="com.google.cannonshop"?
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40,right: 20,left: 20),
              child: Text(
                'Bienvenidos a ConnaShop v1.0.0, si no posee una licencia puede obtenerla desde la aplicación WhizzlyLicences',
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    color: colorDominante
                ),
              ),
            ),
           Container(
              padding: EdgeInsets.only(top: 25,left: 30,right: 30,bottom: 0),
              child: TextFormField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.normal,color: colorDominante.withOpacity(0.6),fontSize: 14),
                  controller: _controllerNombre,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Pega aquí la Licencia",
                    floatingLabelStyle: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,color: colorDominante.withOpacity(0.7)),
                    labelStyle: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.normal,color: colorDominante.withOpacity(0.7)),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).buttonColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).buttonColor.withOpacity(0.5),
                        width: 2.0,
                      ),
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(child: RoundedButton(text: 'Activar'.toUpperCase(), press: (){
                setCodeActivationNew();
              },color: colorDominante,)),
            ),
            isActive?Padding(
              padding: const EdgeInsets.only(top: 40,right: 20,left: 20),
              child: Text(
                'Reinicie la aplicación para usarla correctamente',
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    color: colorDominante
                ),
              ),
            ):Center(),
          ],
        ),
      ):Center(
        child: Text(
          'Solo puede utilizar la original',
          style: TextStyle(
              fontFamily: 'Ubuntu',
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }


  getUniqueKey(AndroidDeviceInfo build) {
    try{
      model= '${build.model}';
    }catch(a){
    }
  try{
    return '${build.brand}${build.hardware}${build.device}';
  }catch(a){
  }
  try{
    return '${build.brand}${build.device}';
  }catch(a){
  }
  try{
    return '${build.brand}${build.hardware}';
  }catch(a){
  }
  try{
    return '${build.hardware}${build.device}';
  }catch(a){
  }
  try{
    return '${build.device}';
  }catch(a){
  }
  try{
    return '${build.brand}';
  }catch(a){
  }

  }

  setCodeActivationNew() async {
    print(_controllerNombre.text);
    print(model);
    print(keyUnique);
    try {
      var data ={
        'code': _controllerNombre.text,
        'model':model,
        'code_encryption':keyUnique
      };
      var response = await http.post(
          Uri.parse('https://whizzlyshop.com/api/getActiveLicenceEZ'),body: data);
      print(response.body.toString());
      print(response.statusCode);
      if(response.body.toString().contains("Licencia Activada")){
        var jLicencia= ActiveJson.fromJson(jsonDecode(response.body));
        Settings.setValue<bool>('key-actives', true);
        isActive=true;
        List<LicenciaObject> licencia = await TuEnvioDatabase.instance.readAllLicencia();

        if(licencia.isNotEmpty){
          TuEnvioDatabase.instance.deleteLicencias();
          TuEnvioDatabase.instance.createLicencia(new LicenciaObject(code: _controllerNombre.text, time: jLicencia.licenciaActivada!, minutos: jLicencia.minutos!));
        }else{
          TuEnvioDatabase.instance.createLicencia(new LicenciaObject(code: _controllerNombre.text, time: jLicencia.licenciaActivada!, minutos: jLicencia.minutos!));
        }
        Fluttertoast.showToast(msg: 'Activado correctamente',backgroundColor: Colors.grey,gravity: ToastGravity.SNACKBAR);

        _controllerNombre.clear();
        setState(() {

        });
      }else if(response.body.toString().contains("Licencia en uso")){
        Fluttertoast.showToast(msg: 'Licencia en uso',backgroundColor: Colors.grey,gravity: ToastGravity.SNACKBAR);
      }if(response.body.toString().contains("Licencia incompatible")){
        Fluttertoast.showToast(msg: 'Licencia incompatible',backgroundColor: Colors.grey,gravity: ToastGravity.SNACKBAR);
      }else{
        Fluttertoast.showToast(msg: 'Licencia no existe',backgroundColor: Colors.grey,gravity: ToastGravity.SNACKBAR);
      }

    }catch(a){
      Fluttertoast.showToast(msg: 'Error de servidor',backgroundColor: Colors.grey,gravity: ToastGravity.SNACKBAR);
    }

    setState(() {

    });
  }

  static const MethodChannel _channel = const MethodChannel('backgroundservice');



  getApplicationID() async {
    appId = await _channel.invokeMethod('appID');
    setState(() {

    });
  }

  Future<void> getCode() async {
    List<LicenciaObject> licencia = await TuEnvioDatabase.instance.readAllLicencia();
  }

  void initPlatformState() async{
    try{
      keyUnique=getUniqueKey (await deviceInfoPlugin.androidInfo);
    }catch(a){
      keyUnique='samsung';
    }
  }

}
