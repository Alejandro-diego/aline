
import 'dart:async';

import 'package:alines/model/data_ad.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  DataAd? _rtbd;
  List<DataAd> _listFuntions = [];
  final _db = FirebaseDatabase.instance.ref();

  List<DataAd> get listFuntions => _listFuntions;
  DataAd? get rtbd => _rtbd;

  late StreamSubscription<DatabaseEvent> _listFuntionsStream;
 // late StreamSubscription<DatabaseEvent> _streamSubscription;

  DataProvider() {
    _listenFuntions();
   // _escuchardatos();
  }

  void _listenFuntions() {
    _listFuntionsStream =
        _db.child('Dispo1080').onValue.listen((event) {
      final allFuntions =
          Map<String, dynamic>.from(event.snapshot.value as dynamic);
      _listFuntions = allFuntions.values
          .map(
            (funtionToJson) => DataAd.fromRTDB(
              Map<String, dynamic>.from(funtionToJson),
            ),
          )
          .toList();
      notifyListeners();
    });
  }
/*
  void _escuchardatos() {
    _streamSubscription =
        _db.child('Dispo1080').child('Saida1').onValue.listen((event) {
      final data = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
      _rtbd = DataAd.fromRTDB(data);
      notifyListeners();
    });
  }*/

  @override
  void dispose() {
    _listFuntionsStream.cancel();
   // _streamSubscription.cancel();
    super.dispose();
  }
}
