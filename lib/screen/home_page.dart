import 'package:alines/model/provider_from_rtdb.dart';
import 'package:alines/screen/add_func.dart';
import 'package:alines/screen/ble_page.dart';
import 'package:alines/screen/event_home.dart';
import 'package:alines/widget/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _db = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                    ),
                    Text(' Evento')
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                    ),
                    Text(' Sobre')
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.bluetooth,
                    ),
                    Text(' ParearDisp')
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                    ),
                    Text(' Sair')
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          _addFunc(),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<DataProvider>(
              builder: (context, data, child) {
                return Expanded(
                  child: ListView(
                    children: [
                      ...data.listFuntions.map(
                        (listFuntion) => NeuButton(
                          isRGBOn: listFuntion.isRGBOn,
                          isDimmerOn: listFuntion.isDimmerIsOn,
                          onChanged: !listFuntion.rele
                              ? null
                              : (value) {
                                  _db
                                      .child('Dispo1080')
                                      .child('Saida${listFuntion.saida}')
                                      .update({'dimmerValue': value});
                                },
                          onLongPress: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddDFunc(
                                  editable: false,
                                  nome: listFuntion.nome,
                                  saida: listFuntion.saida,
                                  programarHora: listFuntion.programarHora,
                                  listaDeHoraInicio: listFuntion.listaDeHorasInicio,
                                ),
                              ),
                            );
                          },
                          onTap: () {
                            debugPrint(listFuntion.saida.toString());
                            _db
                                .child('Dispo1080')
                                .child('Saida${listFuntion.saida}')
                                .update({'rele': !listFuntion.rele});
                            HapticFeedback.heavyImpact();
                          },
                          isEnable: true,
                          eventStatus: listFuntion.programarHora,
                          isButtonPressed: listFuntion.rele,
                          title: listFuntion.nome,
                          cupertinoIcon: const IconData(63365,
                              fontFamily: CupertinoIcons.iconFont,
                              fontPackage: CupertinoIcons.iconFontPackage),
                          dimmerValue: listFuntion.dimmerValue.toDouble(),
                          isCCTOn: listFuntion.isCCTOn,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const EventPage(),
          ),
        );
        break;

      case 2:
        if (!context.mounted) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BlePage(),
          ),
        );
        break;
      case 3:
        FirebaseAuth.instance.signOut();
        break;
    }
  }
}

Route _addFunc() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddDFunc(
      editable: true,
      nome: '',
      saida: '1',
      programarHora: false, listaDeHoraInicio: '',
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
