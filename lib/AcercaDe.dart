import 'package:cannonshop/Constantes/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CustomIcons.dart';




class AcercaDe extends StatefulWidget {
  const AcercaDe({Key? key}) : super(key: key);

  @override
  State<AcercaDe> createState() => _AcercaDeState();
}

class _AcercaDeState extends State<AcercaDe> {
  bool darkmode =false;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Center(),
        title: Text('Acerca de',style: TextStyle(fontFamily: 'Ubuntu',color: colorDominante,fontWeight: FontWeight.bold),),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image(
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.cover,
                              image: AssetImage('assets/logos.png'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('Conna Shop',style: TextStyle(color: colorDominante,fontWeight: FontWeight.bold,fontSize: 20.0,fontFamily: 'Ubuntu'),),
                              Text('Versión: 1.0.0 Beta',style: TextStyle(color: colorDominante,fontWeight: FontWeight.normal,fontSize: 14.0,fontFamily: 'Ubuntu'),)

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0,bottom: 20.0),
                  child: Divider(
                    color: colorDominante.withOpacity(0.5),
                    height: 20,
                    thickness: 1.5,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),

                Text('Desarrollada por:',style: TextStyle(color: colorDominante,fontWeight: FontWeight.bold,fontSize: 15.0,fontFamily: 'Ubuntu'),),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0,top: 40.0,bottom: 40.0),
                  child: Text('Team WhizzlyShop',style: TextStyle(color: colorDominante,fontWeight: FontWeight.normal,fontSize: 15.0,fontFamily: 'Ubuntu'),),
                ),
                Text('Contacto de soporte:',style: TextStyle(color: colorDominante,fontWeight: FontWeight.bold,fontSize: 15.0,fontFamily: 'Ubuntu'),),

                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0,bottom: 8.0,top: 8.0),
                  child: Text('Email: support@whizzlyshop.com',style: TextStyle(color: colorDominante,fontWeight: FontWeight.normal,fontSize: 15.0,fontFamily: 'Ubuntu'),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 35.0,right: 35.0,bottom: 10.0),
                  child: Divider(
                    color: colorDominante.withOpacity(0.5),
                    height: 20,
                    thickness: 1.5,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text('Redes Sociales:',style: TextStyle(color: colorDominante,fontWeight: FontWeight.bold,fontSize: 15.0,fontFamily: 'Ubuntu'),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0,bottom: 25.0),
                      child: IconButton(onPressed: () async{
                        await launch("https://t.me/connashop");
                      },
                          icon: Icon(CustomIcons.telegram,color: colorDominante, size: 40.0,)),
                    ),

                  ],
                ),
              ]

          )
      ),
    );
  }
}
