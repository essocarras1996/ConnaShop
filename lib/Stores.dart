import 'dart:convert';
import 'dart:math';

import 'package:cannonshop/Constantes/Items.dart';
import 'package:cannonshop/Constantes/productJsonAdd.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:http/http.dart' as http;
import 'AppDesactiva.dart';
import 'BaseDatos/SessionObject.dart';
import 'BaseDatos/TuEnvioDatabase.dart';
import 'Constantes/ErrorJson.dart';
import 'Constantes/Productos.dart';
import 'Constantes/Tienda.dart';
import 'CustomIcons.dart';
import 'LoginNewWeb.dart';
import 'Constantes/constants.dart';
import 'package:html/dom.dart'as dom;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'activation.dart';

class Stores extends StatefulWidget {
  const Stores({Key? key}) : super(key: key);

  @override
  State<Stores> createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  bool isLoading = false;
  bool login = false;
  bool isLoadingCart =false;
  int item=0;
  String value = Tienda.tabStoreList.first.name;
  List<Tienda> tienda = Tienda.tabStoreList;
  String url = Tienda.tabStoreList.first.url;
  int productos = 0;
  late String cookie;
  late String token;
  late String static_token;
  List<Productos> _list=[];
  List<Items> _listItems=[];
  late String name="";
  String link="/";
  String msn='INICIE SESIÓN';

  @override
  void initState() {
    getUserActive();
    refreshPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Center(),
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(value, style: TextStyle(fontFamily: 'Ubuntu',
              color: colorDominante,
              fontWeight: FontWeight.bold,
              fontSize: 16.5),),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [

        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          backgroundColor: colorDominante,
          onPressed: () async {
            getProduct(link);
          },
          child: Icon(Icons.refresh, color: Colors.white,),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child:   Padding(
                  padding: const EdgeInsets.only(right: 20,left: 20,
                      top: 5,bottom: 10.0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold, color: colorDominante,fontSize: 16.0),
                      children: [
                        TextSpan(
                          text: "${name}   ",
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
            isLoading ?  Positioned.fill(
              top: 80,
              child: Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.2),
                highlightColor: Colors.grey.withOpacity(0.1),
                enabled: isLoading,
                child: getListViewProductRefresh(),
              ),
            ) :
            _list.isEmpty?Positioned.fill(
              top: MediaQuery
                  .of(context)
                  .size
                  .height / 2 - 100,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    msn, style: TextStyle(fontFamily: 'Ubuntu', color: colorDominante, fontWeight: FontWeight.bold),)),):
            Positioned.fill(
              top: 80,
              child: getListViewProduct(),
            ),
            _listItems.isNotEmpty
                ?Padding(
              padding: EdgeInsets.only(top: 27),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 60,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    itemCount: _listItems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          for(var a in _listItems){
                            a.select=0;
                          }
                          _listItems[index].select=1;
                          if(_listItems[index].name!="Inicio"){
                            link='/'+_listItems[index].url.split(".net/")[1];
                          }else{
                            link='/';
                          }
                          setState(() {

                          });
                          getProduct(link);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: _listItems[index].select==1?colorDominante:Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(18.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: _listItems[index].select==1?colorDominante.withOpacity(0.2):Colors.grey.withOpacity(0.2),
                                      offset: Offset(5.0, 5.0),
                                      blurRadius: 8.0
                                  )
                                ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12,right: 15.0,left: 15.0),
                              child: Text( _listItems[index].name,
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontWeight:_listItems[index].select==1? FontWeight.bold:FontWeight.normal,
                                  color: Colors.white,
                                ),),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ):
                isLoading?Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.2),
              highlightColor: Colors.grey.withOpacity(0.1),
              enabled: isLoading,
              child: Padding(
                padding: EdgeInsets.only(top: 27),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 60,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(18.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      offset: Offset(5.0, 5.0),
                                      blurRadius: 8.0
                                  )
                                ]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12,right: 15.0,left: 15.0,bottom: 13),
                              child: Container(
                                width: 100,
                                height: 13.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ):Center(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                    color: colorDominante,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: colorDominante
                            .withOpacity(0.2),
                        blurRadius: 2.5,
                        spreadRadius: 2.5,
                        offset: Offset(0, 1),
                      ),
                    ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => Account()),).then((res) => refreshPage());
                        //  _showDialogCerrarSesion(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color:  Colors.transparent

                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginNewWeb(getUrlStore(value)+"mi-cuenta")),).then((res) => refreshPage());
                              setState(() {

                              });
                            },
                                icon: Icon(
                                  CustomIcons.user, color: Colors.white,)),
                          ),
                        ),
                      ),
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: IconButton(onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => gradeDialog());
                          },
                              icon: Icon(
                                CustomIcons.store, color: Colors.white,)),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, right: 10, bottom: 10),
                      child: Container(
                        height: 150.0,
                        width: 40.0,
                        child: GestureDetector(

                          onTap: () async {
                            if(item>0) {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => LoginNewWeb(
                                      getUrlStore(value) + "pedido")),)
                                  .then((res) => refreshPage());
                            }

                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.shopping_basket,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          if(item>0) {
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => LoginNewWeb(
                                                    getUrlStore(value) + "pedido")),)
                                                .then((res) => refreshPage());
                                          }
                                        }),
                                  ),
                                ),
                              ),
                              Positioned(
                                  left: 24, top: 1.0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3.5, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                      child: !isLoadingCart ? Text(
                                        '${item}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontFamily: 'Ubuntu',
                                            fontWeight: FontWeight.w500),
                                      ) : Container(
                                        width: 10,
                                        height: 15,
                                        padding: EdgeInsets.only(
                                            top: 2.5, bottom: 2.5),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
            login ? Container(

              margin: EdgeInsets.only(bottom: 75, left: 20.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Center(),
              ),
            ) : Center(),
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.only(top: 25.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TimerBuilder.periodic(
                      Duration(seconds: 1), builder: (context) {
                    return Text(
                      "${getSystemTime()}",
                      style: TextStyle(
                          fontFamily: "Ubuntu",
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getSystemTime() {
    var now = new DateTime.now();
    try{
      DateTime fecha1 =DateTime.parse(time);
      DateTime fecha2 =DateTime.now();
      Duration duration=fecha2.difference(fecha1);
      if(duration.inDays>=int.parse(minutos)){
        Settings.setValue<bool>('key-actives', false);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Activation()), (route) => false);
      }
    }catch(a){}

    return new DateFormat("hh:mm:ss a").format(now);
  }

  refreshPage() async {
    var data = await TuEnvioDatabase.instance.readSesion(1);
    cookie=data.cookie;
    setState(() {

    });
  }

  StatefulBuilder gradeDialog() {
    return StatefulBuilder(
      builder: (context, _setter) {
        return AlertDialog(
          backgroundColor: Theme
              .of(context)
              .cardColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(

            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Seleccione una provincia", style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            color: colorDominante,
                            fontSize: 17.0),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: colorDominante
                        .withOpacity(0.7),
                    height: 4.0,
                  ),


                  Padding(
                    padding: EdgeInsets.only(
                        top: 15, left: 30, right: 30, bottom: 30),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.78,

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Theme
                              .of(context)
                              .buttonColor
                              .withOpacity(0.5), width: 2.0)

                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(20.0)),
                            icon: Icon(Icons.arrow_drop_down, color: colorDominante
                                .withOpacity(0.5),),
                            value: value,
                            isDense: false,
                            isExpanded: true,
                            style: TextStyle(
                              color: Colors.black38, fontSize: 18,),
                            underline: Container(
                              height: 1,
                              color: colorDominante
                                  .withOpacity(0.5),
                            ),
                            items: tienda.map(buildMenuItem).toList(),
                            onChanged: (value) =>
                                setState(() {
                                  _listItems.clear();
                                  _list.clear();
                                  name="";
                                  item=0;
                                  msn='INICIE SESIÓN';
                                  link="/";
                                  _setter(
                                        () {
                                      this.value = value!;
                                    },
                                  );
                                  _changeGrade(value);
                                }),

                          ),
                        ),
                      ),

                    ),
                  ),

                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      setState(() {

                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: colorDominante,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "Aceptar",
                        style: TextStyle(fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16.0,),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _changeGrade(_newGrade) {
    setState(
          () {
        value = _newGrade;
      },
    );
  }

  DropdownMenuItem<String> buildMenuItem(Tienda item) =>
      DropdownMenuItem(
        alignment: Alignment.center,
        value: item.name,
        child: Text(
          item.name,
          style: TextStyle(fontFamily: 'Ubuntu',
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
              color: colorDominante
                  .withOpacity(0.5)),
        ),
      );

  String getUrlStore(String value) {
    url="";
    for(var item in tienda){
      if(item.name== value){
        print(item.url);
        url=item.url;
        return item.url;
      }
    }
    return url;
  }

  getProduct(String url) async{


    isLoading=true;
    setState(() {

    });

    var customHeaders = {
      'Accept-Encoding'.toLowerCase(): 'deflate'.toLowerCase(),
      'User-Agent'.toLowerCase(): 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.125 Safari/537.36'.toLowerCase(),
      'Cookie'.toLowerCase(): cookie,
      'accept'.toLowerCase(): 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'.toLowerCase(),
      'accept-language'.toLowerCase(): 'es-ES,es;q=0.9'.toLowerCase(),
      'cache-control'.toLowerCase(): 'no-cache'.toLowerCase(),
      'pragma'.toLowerCase(): 'no-cache'.toLowerCase(),
      'sec-ch-ua'.toLowerCase(): '"Chromium";v="92", " Not A;Brand";v="99", "Google Chrome";v="92"'.toLowerCase(),
      'sec-ch-ua-mobile'.toLowerCase(): '?1'.toLowerCase(),
      'sec-fetch-dest'.toLowerCase(): 'document'.toLowerCase(),
      'sec-fetch-mode'.toLowerCase(): 'navigate'.toLowerCase(),
      'sec-fetch-site'.toLowerCase(): 'none'.toLowerCase(),
      'sec-fetch-user'.toLowerCase(): '?1'.toLowerCase(),
      'upgrade-insecure-requests'.toLowerCase():'1'.toLowerCase()
    };
    var dio = Dio()
      ..options.connectTimeout = 900000
      ..options.receiveTimeout = 900000
      ..options.sendTimeout = 900000
      ..options.baseUrl=getUrlStore(value)
      ..options.responseType = ResponseType.plain
      ..options.headers = customHeaders
      ..options.followRedirects=false
      ..options.receiveDataWhenStatusError=true
      ..options.validateStatus = (status) {
        return status! < 505;
      }
      ..interceptors.add(LogInterceptor());
    try{
      var response = await dio.get(url);


      if(response.statusCode==200){
        msn='No hay productos disponibles';
        try {
          var document = parse(response.data);
          name = document.getElementsByClassName('account').first.text;
          var list_productos;
          static_token="";
          //var a = document.getElementById("center_column")?.text;
          // print(a);
          var tet= document.getElementsByTagName('head').first.getElementsByTagName('script').first.outerHtml.split(";");

          var carrito = document.getElementsByClassName("shopping_cart").first.getElementsByTagName('a > span');
          try{
            item = int.parse(carrito.first.text);
          }catch(s){
            item = 0;
          }

          for(int i = 0; i< tet.length;i++){
            if(tet[i].contains("static_token")){
              static_token=tet[i].replaceAll("\'", "").replaceAll(";", "").replaceAll("var", "").replaceAll(" ", "").replaceAll("=", "").replaceAll("static_token", "");
              print(static_token);
            }
            if(tet[i].contains("token")&&!tet[i].contains("static_token")){
              token=tet[i].replaceAll("\'", "").replaceAll(";", "").replaceAll("var", "").replaceAll(" ", "").replaceAll("=", "").replaceAll("token", "");
              print(token);
            }
          }
          try{
            var next = document.getElementById('pagination_next_bottom')!.getElementsByTagName('li').where((e) => e.attributes.containsKey('href'))
                .map((e) => e.attributes['href']).last
                .toString().replaceAll(")", "").replaceAll("(", "");
            print(next);
          }catch(a){}
          try{
            var previous = document.getElementById('pagination_previous_bottom')!.getElementsByTagName('li').where((e) => e.attributes.containsKey('href'))
                .map((e) => e.attributes['href']).last
                .toString().replaceAll(")", "").replaceAll("(", "");
            print(previous);
          }catch(a){}



          _list.clear();
          if(link=="/"){
            var itemsList =document.getElementById('block_top_menu')?.getElementsByTagName('ul').first.querySelectorAll('li');
            _listItems.clear();
            _listItems.add(new Items(name: 'Inicio', url: '/', select: 0));
            for(dom.Element a in itemsList!){
              String name =a.getElementsByTagName('a').first.text;
              String url=a.getElementsByTagName('a')
                  .where((e) => e.attributes.containsKey('href'))
                  .map((e) => e.attributes['href']).first
                  .toString().replaceAll(")", "").replaceAll("(", "");
              if(!name.contains("Aviso")||!name.contains("Inicio")){
                _listItems.add(new Items(name: name, url: url, select: 0));
              }

            }print(_listItems.length);
            _listItems = _listItems.toSet().toList();
            final ids = _listItems.map((e) => e.name).toSet();
            _listItems.retainWhere((x) => ids.remove(x.name));

            print(_listItems.length);
            _listItems[0].select=1;
            setState(() {

            });
            list_productos =document.getElementById('blocknewproducts')?.querySelectorAll('li');
            for(dom.Element a in list_productos){
              String nombre = a.getElementsByClassName('product-name').first.text.replaceAll(" ", "?")
                  .replaceAll(new RegExp(r"\?\?+"), "")
                  .replaceAll(new RegExp(r"\s+"), "")
                  .replaceAll("?", " ");
              String precio = a.getElementsByClassName('content_price').first.text.replaceAll(" ", "?")
                  .replaceAll(new RegExp(r"\?\?+"), "")
                  .replaceAll(new RegExp(r"\s+"), "")
                  .replaceAll("?", " ");
              String photo = a.getElementsByClassName('product-image-container').first.getElementsByTagName('a').first.getElementsByTagName('img')
                  .where((e) => e.attributes.containsKey('src'))
                  .map((e) => e.attributes['src'])
                  .toString().replaceAll("(", "").replaceAll(")", "");
              String product_id=a.getElementsByClassName('button-container').first.getElementsByTagName('a')
                  .where((e) => e.attributes.containsKey('data-id-product'))
                  .map((e) => e.attributes['data-id-product'])
                  .toString().replaceAll(")", "").replaceAll("(", "");
              String url_add=a.getElementsByClassName('button-container').first.getElementsByTagName('a')
                  .where((e) => e.attributes.containsKey('href'))
                  .map((e) => e.attributes['href']).first
                  .toString().replaceAll(")", "").replaceAll("(", "");
              String url_details=a.getElementsByClassName('button-container').first.getElementsByTagName('a')
                  .where((e) => e.attributes.containsKey('href'))
                  .map((e) => e.attributes['href']).last
                  .toString().replaceAll(")", "").replaceAll("(", "");
              if(!nombre.toLowerCase().contains("aviso")||!nombre.toLowerCase().contains("aviso!!!")||!nombre.toLowerCase().contains("inicio")){
                _list.add(Productos(nombre: nombre.replaceAll("(MLC) ", "").replaceAll("(MLC)", ""),precio: precio.replaceAll("USD \$", ""),descripcion:url_details,id_producto: product_id,photo: photo,static_token: static_token,token: token,url_add: url_add));
                if(nombre.toLowerCase().contains("pollo")||nombre.toLowerCase().contains("detergente")||nombre.toLowerCase().contains("perrito")||nombre.toLowerCase().contains("salchicha")||nombre.toLowerCase().contains("aceite")||nombre.toLowerCase().contains("gelatina")||nombre.toLowerCase().contains("galleta")||nombre.toLowerCase().contains("galleticas")||nombre.toLowerCase().contains("refresco")||nombre.toLowerCase().contains("malta")||nombre.toLowerCase().contains("aceite")||nombre.toLowerCase().contains("hot")||nombre.toLowerCase().contains("dogs")||nombre.toLowerCase().contains("harina")){
                  for(var a in _listItems){
                    if(a.select==1){
                      alertTelegram(nombre.replaceAll("(MLC) ", "").replaceAll("(MLC)", ""),precio.replaceAll("USD \$", "")+" USD", a.name, url_details);
                    }
                  }

                }
              }


            }
          }else{
            list_productos =document.querySelector("ul.product_list.grid.row")!.querySelectorAll('li');
            for(dom.Element a in list_productos){
              String nombre = a.getElementsByClassName('product-name').first.text.replaceAll(" ", "?")
                  .replaceAll(new RegExp(r"\?\?+"), "")
                  .replaceAll(new RegExp(r"\s+"), "")
                  .replaceAll("?", " ");
              String precio = a.getElementsByClassName('content_price').first.text.replaceAll(" ", "?")
                  .replaceAll(new RegExp(r"\?\?+"), "")
                  .replaceAll(new RegExp(r"\s+"), "")
                  .replaceAll("?", " ");
              String photo = a.getElementsByClassName('product-image-container').first.getElementsByTagName('a').first.getElementsByTagName('img')
                  .where((e) => e.attributes.containsKey('src'))
                  .map((e) => e.attributes['src'])
                  .toString().replaceAll("(", "").replaceAll(")", "");
              String product_id=a.getElementsByClassName('button-container').first.getElementsByTagName('a')
                  .where((e) => e.attributes.containsKey('data-id-product'))
                  .map((e) => e.attributes['data-id-product'])
                  .toString().replaceAll(")", "").replaceAll("(", "");
              String url_add=a.getElementsByClassName('button-container').first.getElementsByTagName('a')
                  .where((e) => e.attributes.containsKey('href'))
                  .map((e) => e.attributes['href']).first
                  .toString().replaceAll(")", "").replaceAll("(", "");
              String url_details=a.getElementsByClassName('button-container').first.getElementsByTagName('a')
                  .where((e) => e.attributes.containsKey('href'))
                  .map((e) => e.attributes['href']).last
                  .toString().replaceAll(")", "").replaceAll("(", "");
              if(!nombre.toLowerCase().contains("aviso")||!nombre.toLowerCase().contains("inicio")){
                _list.add(Productos(nombre: nombre.replaceAll("(MLC) ", "").replaceAll("(MLC)", ""),precio: precio.replaceAll("USD \$", ""),descripcion:url_details,id_producto: product_id,photo: photo,static_token: static_token,token: token,url_add: url_add));
                if(nombre.toLowerCase().contains("pollo")||nombre.toLowerCase().contains("detergente")||nombre.toLowerCase().contains("perrito")||nombre.toLowerCase().contains("salchicha")||nombre.toLowerCase().contains("aceite")||nombre.toLowerCase().contains("gelatina")||nombre.toLowerCase().contains("galleta")||nombre.toLowerCase().contains("galleticas")||nombre.toLowerCase().contains("refresco")||nombre.toLowerCase().contains("malta")||nombre.toLowerCase().contains("aceite")||nombre.toLowerCase().contains("hot")||nombre.toLowerCase().contains("dogs")||nombre.toLowerCase().contains("harina")){
                  for(var a in _listItems){
                    if(a.select==1){
                      alertTelegram(nombre.replaceAll("(MLC) ", "").replaceAll("(MLC)", ""),precio.replaceAll("USD \$", "")+" USD", a.name, url_details);
                    }
                  }

                }
              }


            }
          }




          setState(() {

          });


        } catch (e) {}

      }else if (response.statusCode==503){
        msn='Tienda en Mantenimiento';
        setState(() {

        });
      }else if (response.statusCode==504){
        msn='Error 504 servicio no disponible';
        setState(() {

        });
      }


    }catch(Exception){
      msn='Error al establecer cnx';
      print('Error al establecer cnx');
    }

    isLoading=false;
    setState(() {

    });



  }



  getListViewProduct(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: _list.length,
        padding: const EdgeInsets.only(top: 8),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {

          return InkWell(
            onTap: (){

            },
            child: Container(
              margin: EdgeInsets.only(right: 30.0,left: 30.0,top: 10.0,bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft:Radius.circular(25.0),topRight: Radius.circular(25.0),bottomLeft: Radius.circular(25.0),bottomRight:Radius.circular(5.0) ),
                boxShadow: [
                  BoxShadow(
                    color: colorDominante.withOpacity(0.3),
                    blurRadius: 2.5,
                    spreadRadius: 2.5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: colorDominante),
                              borderRadius: BorderRadius.only(topLeft:Radius.circular(25.0),topRight: Radius.circular(25.0),bottomLeft: Radius.circular(25.0),bottomRight:Radius.circular(5.0) )
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft:Radius.circular(25.0),topRight: Radius.circular(25.0),bottomLeft: Radius.circular(25.0) ,bottomRight:Radius.circular(5.0)),
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.29,
                              height: 120,
                              color: Colors.white,
                              child: Center(
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: '${_list[index].photo!}',
                                      placeholder: (context, url) => Container(
                                          height: 20,
                                          width: 20,
                                          margin: EdgeInsets.all(5),
                                          padding: EdgeInsets.all(30.0),
                                          child: new CircularProgressIndicator(
                                              color: colorDominante)),
                                      errorWidget: (context, url, error) => new Icon(Icons.image_not_supported_outlined,color: colorDominante,)
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0,top: 8.0,bottom: 8.0,left: 20.0),
                                child: Text('${_list[index].nombre}',
                                  style: TextStyle(
                                    fontFamily:'Ubuntu',
                                    color: colorDominante.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow:TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 2,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 18, right: 16),
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  text: TextSpan(
                                    style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold, color: colorDominante.withOpacity(0.7),fontSize: 15),
                                    children: [
                                      TextSpan(
                                        text: "\$${_list[index].precio.toString().split('.')[0]}.",
                                      ),
                                      TextSpan(
                                        text: "${double.parse(_list[index].precio!).toStringAsFixed(2)?.toString().split('.')[1]} ",
                                        style: TextStyle(fontSize: 13),

                                      ),
                                      TextSpan(
                                        text: "USD",
                                      ),

                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 0.0),
                                child: Divider(
                                  color: colorDominante.withOpacity(0.5),
                                  height: 10,
                                  thickness: 1.5,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: IconButton(onPressed: () async {

                                        }, icon: Icon(Icons.source_outlined,color: colorDominante,)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: IconButton(onPressed: () async {
                                          String name = '${_list[index].nombre}';
                                          String precio = '\$${_list[index].precio} USD';
                                          String u = '${_list[index].descripcion}';
                                          List<String> imagePaths = [];
                                          String departamento="";
                                          for(var a in _listItems){
                                            if(a.select==1){
                                              departamento =a.name;
                                            }
                                          }
                                          try{
                                            final cache = await DefaultCacheManager();
                                            final file = await cache.getSingleFile('${_list[index].photo!}');
                                            imagePaths.add(file.path);
                                            Share.shareFiles(imagePaths,
                                                text: "#alerta\nTienda: $value \nDepartamento: $departamento\nProducto: $name\nPrecio: $precio\nLink: $u");
                                          }catch(Unhandled){
                                            Share.share("#alerta\nTienda: $value \nDepartamento: $departamento\nProducto: $name\nPrecio: $precio\nLink: $u");
                                          }
                                        }, icon: Icon(Icons.share,color: colorDominante,)),
                                      ),
                                    ),
                                  ),
                                 Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: IconButton(onPressed: (){
                                          addProductPost(_list[index].nombre,int.parse(_list[index].id_producto));
                                        }, icon: Icon(Icons.add_shopping_cart,color: colorDominante,)),
                                      ),
                                    ),
                                  ),
                                ],
                              )

                            ],
                          ),
                        )
                      ],

                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  getListViewProductRefresh(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 10,
        padding: const EdgeInsets.only(top: 8),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {

          return InkWell(
            onTap: (){

            },
            child: Container(
              margin: EdgeInsets.only(right: 30.0,left: 30.0,top: 10.0,bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.only(topLeft:Radius.circular(25.0),topRight: Radius.circular(25.0),bottomLeft: Radius.circular(25.0),bottomRight:Radius.circular(5.0) ),
                boxShadow: [
                  BoxShadow(
                    color: colorDominante.withOpacity(0.1),
                    blurRadius: 2.5,
                    spreadRadius: 2.5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: colorDominante),
                              borderRadius: BorderRadius.only(topLeft:Radius.circular(25.0),topRight: Radius.circular(25.0),bottomLeft: Radius.circular(25.0),bottomRight:Radius.circular(5.0) )
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft:Radius.circular(25.0),topRight: Radius.circular(25.0),bottomLeft: Radius.circular(25.0) ,bottomRight:Radius.circular(5.0)),
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.29,
                              height: 120,
                              color: Colors.white,
                              child: Center(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0,top: 8.0,bottom: 8.0,left: 20.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.7,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 30, right: 30,bottom: 15),
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  height: 12.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 0.0),
                                child: Divider(
                                  color: colorDominante.withOpacity(0.5),
                                  height: 10,
                                  thickness: 1.5,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: IconButton(onPressed: () async {

                                        }, icon: Icon(Icons.source_outlined,color: colorDominante,)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: IconButton(onPressed: () async {/*
                                          String name = '${kits[index].warehousePrefix} - ${kits[index].name}';
                                          String precio = '\$${double.parse(kits[index].price!).toStringAsFixed(2)} ${kits[index].currency!}';
                                          String cantidad = '0';
                                          List<String> imagePaths = [];

                                          try{
                                            final cache = await DefaultCacheManager();
                                            final file = await cache.getSingleFile('${kits[index].thumbnail!}');
                                            imagePaths.add(file.path);
                                            Share.shareFiles(imagePaths,
                                                text: "#alerta\nTienda: $value $Currency\nDepartamento: Combos\nProducto: $name\nPrecio: $precio\nExistencia: $cantidad");
                                          }catch(Unhandled){
                                            Share.share("#alerta\nTienda: $value $Currency\nDepartamento: Combos\nProducto: $name\nPrecio: $precio\nExistencia: $cantidad");
                                          }*/
                                        }, icon: Icon(Icons.share,color: colorDominante,)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: IconButton(onPressed: (){

                                        }, icon: Icon(Icons.add_shopping_cart,color: colorDominante,)),
                                      ),
                                    ),
                                  ),
                                ],
                              )

                            ],
                          ),
                        )
                      ],

                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  addProductPost(String names,int id_product) async{
    try{
      Fluttertoast.showToast(msg: 'Añadiendo producto',backgroundColor:Theme.of(context).primaryColor );
    }catch(d){

    }
    setState(() {

    });
    var data = await TuEnvioDatabase.instance.readSesion(1);
    cookie=data.cookie;
    var customHeaders = {
      'Accept-Encoding'.toLowerCase(): 'deflate'.toLowerCase(),
      'User-Agent'.toLowerCase(): 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.125 Safari/537.36'.toLowerCase(),
      'Cookie'.toLowerCase(): cookie,
      'accept'.toLowerCase(): 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'.toLowerCase(),
      'accept-language'.toLowerCase(): 'es-ES,es;q=0.9'.toLowerCase(),
      'cache-control'.toLowerCase(): 'no-cache'.toLowerCase(),
      'pragma'.toLowerCase(): 'no-cache'.toLowerCase(),
      'sec-ch-ua'.toLowerCase(): '"Chromium";v="92", " Not A;Brand";v="99", "Google Chrome";v="92"'.toLowerCase(),
      'sec-ch-ua-mobile'.toLowerCase(): '?1'.toLowerCase(),
      'sec-fetch-dest'.toLowerCase(): 'document'.toLowerCase(),
      'sec-fetch-mode'.toLowerCase(): 'navigate'.toLowerCase(),
      'sec-fetch-site'.toLowerCase(): 'none'.toLowerCase(),
      'sec-fetch-user'.toLowerCase(): '?1'.toLowerCase(),
      'upgrade-insecure-requests'.toLowerCase():'1'.toLowerCase()
    };
    var dio = Dio()
      ..options.connectTimeout = 900000
      ..options.receiveTimeout = 900000
      ..options.sendTimeout = 900000
      ..options.baseUrl=getUrlStore(value)
      ..options.responseType = ResponseType.plain
      ..options.headers = customHeaders
      ..options.followRedirects=true
      ..options.receiveDataWhenStatusError=false
      ..options.validateStatus = (status) {
        return status! < 504;
      }
      ..interceptors.add(LogInterceptor());
    var datas={
      'controller':"cart",
      'add':"1",
      'ajax':"true",
      'qty':"1",
      'id_product':'$id_product',
      'token':static_token.replaceAll("\n", "")
    };
    try{
      Random random = new Random();
      int randomNumber = random.nextInt(1000000);
      var response = await dio.post('/?rand=1674327$randomNumber',data: FormData.fromMap(datas));

      if(response.statusCode==200){
        try {
          var document = parse(response.data);
          var body;
          try{
            body= ErrorJson.fromJson(json.decode(response.data));
            if(document.body!.text.contains("Imposible adicionar el producto al carrito.")){
              Fluttertoast.showToast(
                  backgroundColor: Colors.grey,
                  msg: 'Imposible adicionar el producto al carrito. Por favor, recargue la página.');
            }else if(document.body!.text.contains("Ud no puede volver a")){

              Fluttertoast.showToast(
                  backgroundColor: Colors.grey,
                  msg: body.errors!.first.replaceAll("&iacute;", "í"));
            }else if(document.body!.text.contains("Producto no disponible.")||document.body!.text.contains("No disponible")){
              Fluttertoast.showToast(
                  backgroundColor: Colors.grey,
                  msg: "Producto no disponible");
            }else{
              item++;
              Fluttertoast.showToast(
                  backgroundColor: Colors.grey,
                  msg: "${names.substring(0,10)}... añadido correctamente");
            }
          }catch(e){
            body= productJsonAdd.fromJson(json.decode(response.data));
            item++;
            Fluttertoast.showToast(
                backgroundColor: Colors.grey,
                msg: "${names.substring(0,20)}... añadido correctamente");
          }





          setState(() {

          });


        } catch (e) {
          print(e);
        }

      }


    }catch(Exception){
      msn='Error al establecer cnx';
      print('Error al establecer cnx');
    }

    isLoading=false;
    setState(() {

    });



  }

  Future<void> alertTelegram(String name,String precio,String departamento, String u) async {
    print('Telegram');
      try{
        var dio = Dio()
          ..options.connectTimeout = 50000
          ..options.receiveTimeout = 50000
          ..options.sendTimeout = 50000
          ..options.baseUrl = "https://api.telegram.org/"
          ..options.responseType = ResponseType.json
          ..options.followRedirects = true
          ..options.receiveDataWhenStatusError = false
          ..options.validateStatus = (status) {
            return status! < 504;
          };
        var response= await dio.get('bot6022995899:AAGK2ubWeozD0YOjyvW_v3waATx0KALvrY4/sendMessage?chat_id=@connashop_alertas&text=🏪 Tienda: $value\n📦 Departamento: $departamento\n🛍 Producto: $name\n💰 Precio: \$$precio\n🛒 Link: $u');
        print(response.data);
      }catch(a){}

  }

  String minutos="";
  String time="";


  getUserActive() async {
    var _listLicence = await TuEnvioDatabase.instance.readAllLicencia();
    minutos=_listLicence.first.minutos;
    time='${_listLicence.first.time.split(".")[0]}Z';
    if(int.parse(_listLicence.first.minutos)>100){
      Settings.setValue<bool>('key-active', false);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => AppDesactive()), (route) => false);
    }
    setState(() {
    });
  }



}
