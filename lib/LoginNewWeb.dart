
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../Constantes/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'BaseDatos/SessionObject.dart';
import 'BaseDatos/TuEnvioDatabase.dart';



class LoginNewWeb extends StatefulWidget {
   final String urls;

   LoginNewWeb(this.urls);

  @override
  _MyAppState createState() => new _MyAppState(urls);
}

class _MyAppState extends State<LoginNewWeb> {
  final String urls;


  _MyAppState(this.urls);

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,

        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        useShouldInterceptFetchRequest: true,
        mediaPlaybackRequiresUserGesture: false,
        userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36",
      ),
      android: AndroidInAppWebViewOptions(
        saveFormData: true,
        useHybridComposition: true,
        domStorageEnabled: true,
        allowFileAccess: true,
        allowContentAccess: true,
        networkAvailable: true,
        useShouldInterceptRequest: true,
        databaseEnabled: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  double progress = 0;
  String finalUser="";
  late String url="";
  final urlController = TextEditingController();
  final CookieManager cookieManager = CookieManager.instance();
  @override
  void initState() {
    url=urls;
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: colorDominante,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorDominante,
        title: Theme(data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
                selectionHandleColor:Colors.green,
                cursorColor: Colors.green,
                selectionColor: Colors.grey.withOpacity(0.7))),
            child: TextField(

              cursorColor: Colors.amber,
              controller: urlController,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14
              ),
              decoration: new InputDecoration.collapsed(
                  hoverColor: Colors.black26,
                  hintStyle: TextStyle(
                      color: Colors.black26,
                      backgroundColor: Colors.black26
                  ),
                  focusColor: Colors.black26,
                  hintText: ''

              ),
              keyboardType: TextInputType.url,
              onSubmitted: (value) {
                var url = Uri.parse(value);
                if (url.scheme.isEmpty) {
                  url = Uri.parse(urls);
                }
                webViewController?.loadUrl(
                    urlRequest: URLRequest(url: url));
              },
            ),
        ),/*Text(
          "TRDEnzona",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Ubuntu', fontSize: 19),
        ),*/
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.

        actions: <Widget>[
          /*IconButton(
            icon: const Icon(Icons.layers_clear_sharp),
            onPressed:() async {
              await cookieManager.deleteAllCookies();
              webViewController!.clearCache();
              Fluttertoast.showToast(
                  msg: 'Cookies eliminados',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              return;
            },
          ),*/
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed:() async {
              if (await webViewController!.canGoBack()) {
                await webViewController!.goBack();
              } else {
                // ignore: deprecated_member_use
                Scaffold.of(context).showBottomSheet((context) => SnackBar(content: Text("No puede regresar")),
                );
                return;
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () async {
              if (await webViewController!.canGoForward()) {
                await webViewController!.goForward();
              } else {
                // ignore: deprecated_member_use

                Scaffold.of(context).showBottomSheet((context) => SnackBar(content: Text("No hay donde ir")),);
                return;
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: () async{
              webViewController!.evaluateJavascript(source: 'window.location.reload( true )');
              //webViewController!.reload();
            },
          ),
        ],
      ),
          body: SafeArea(
            child: Column(
              children: [
                /*TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search)
                  ),
                  controller: urlController,
                  keyboardType: TextInputType.url,
                  onSubmitted: (value) {
                    var url = Uri.parse(value);
                    if (url.scheme.isEmpty) {
                      url = Uri.parse(urls);
                    }
                    webViewController?.loadUrl(
                        urlRequest: URLRequest(url: url));
                  },
                ),*/
                Expanded(
                  child: Stack(
                    children: [

                      InAppWebView(
                        initialUrlRequest:
                        URLRequest(url: Uri.parse(urls)),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,

                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onReceivedServerTrustAuthRequest: (controller, challenge) async {
                          print(challenge);
                          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                        },

                        androidOnPermissionRequest: (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading: (controller, navigationAction) async {
                          print(navigationAction.request.method);
                          print(navigationAction.toMap());
                          return NavigationActionPolicy.ALLOW;
                        },
                        shouldInterceptFetchRequest: (controller, fetchRequest) async {
                          /*print('noseee');
                                print(fetchRequest.body);
                                assert(fetchRequest.body);*/
                          return fetchRequest;
                        },

                        onLoadStop: (controller, url) async {
                          final _cookieManager = WebviewCookieManager();
                          String path="";
                          path=url!.path;
                          final gotCookies = await _cookieManager.getCookies(url.toString());
                          addSesion(gotCookies.toString());
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onLoadError: (controller, url, code, message) {
                          pullToRefreshController.endRefreshing();
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                            urlController.text = this.url;
                          });
                        },
                        onUpdateVisitedHistory: (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },

                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage.message);
                        },
                      ),
                      progress < 1.0
                          ? LinearProgressIndicator(value: progress)
                          : Container(),
                    ],
                  ),
                ),
              ],

            ),
          ),

    );

  }
  Future addSesion(String cookie) async {
    var list=cookie.replaceAll("]", "").replaceAll("[", "").split(' ');
    String final_cookie="";
    String ses="";
    String _pk_ses="";
    String _pk_id="";
    String PrestaShop="";
    for(int i = 0 ;i< list.length;i++){
      if(list[i].contains('_pk_id.')){
        _pk_id=list[i].replaceAll("[", "");
      }
      if(list[i].contains('PrestaShop')){
        PrestaShop=list[i].replaceAll("Path=/, ", "");
      }
      if(list[i].contains('_pk_ses')){
        _pk_ses=list[i].replaceAll("Path=/, ", "");
      }


    }
    final_cookie ="${_pk_id} ${PrestaShop} ${_pk_ses}";


    final sessionObject;
    if(urls.contains("lacte")){
      sessionObject= SessionObject(id: 1, usuario: 'usuario', cookie: final_cookie.replaceAll("[", "").replaceAll("]", ""));
    }else if(urls.contains("reina")){
    final_cookie ="${_pk_id} ${_pk_ses} ${PrestaShop}";
      sessionObject= SessionObject(id: 1, usuario: 'usuario', cookie: final_cookie
      );
    }else {
      sessionObject= SessionObject(id: 1, usuario: 'usuario', cookie: final_cookie
      );
    }


    await TuEnvioDatabase.instance.delete(1);

    await TuEnvioDatabase.instance.createSession(sessionObject);



  }


}

