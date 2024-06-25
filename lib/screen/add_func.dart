import 'package:alines/widget/day_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AddDFunc extends StatefulWidget {
  AddDFunc(
      {super.key,
      required this.editable,
      required this.nome,
      required this.saida});

  bool editable;
  String nome;
  String saida;

  @override
  State<AddDFunc> createState() => _AddDFuncState();
}

class _AddDFuncState extends State<AddDFunc> {
  bool programarHora = false;
  final List<DateTime> _horaDeInicio = [];
  final List<String> dias = ["D", "S", "T", "Q", "Q", "S", "S"];
  final List<bool> diasAcitvos = [
    false,
    false,
    true,
    false,
    false,
    false,
    false
  ];
  late Map<int, String> diasMap = dias.asMap();

  DateTime time = DateTime(2024, 5, 10, 22, 35);

  bool isRGBOn = false;
  bool isDimmerIsOn = false;
  bool isCCTOn = false;
  int selectedItemIndex = 0;

  List<String> items = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '7',
    '6',
    '8',
    'Dimmer1',
    'Dimmer2',
    'CCT1',
    'CCT2',
    'RGB'
  ];

  TextEditingController nome = TextEditingController();
  final _db = FirebaseDatabase.instance.ref();

  final _formKey = GlobalKey<FormState>();
  late String saida = '1';
  late String disp = "1000";
  late int numeroDeDia = 3;

  @override
  void dispose() {
    nome.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (!widget.editable) {
      debugPrint('colocar nombre');
      nome.text = widget.nome;
      saida = widget.saida;
    }

    _obtenerCredenciales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Func'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: nome,
                cursorColor: Colors.cyan,
                // style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: Padding(
                    padding: EdgeInsetsDirectional.only(start: 2),
                    child: Icon(
                      Icons.article_outlined,
                      size: 35,
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.cyan),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  const Text('Saida'),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: widget.editable
                        ? SizedBox(
                            width: 150,
                            child: CupertinoPicker(
                              itemExtent: 40.0,
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  selectedItemIndex = index;
                                  saida = items[index];
                                  if ((items[index] == "Dimmer1") |
                                      (items[index] == "Dimmer2")) {
                                    isDimmerIsOn = true;
                                  } else {
                                    isDimmerIsOn = false;
                                  }
                                  if ((items[index] == 'CCT1') |
                                      (items[index] == 'CCT2')) {
                                    isCCTOn = true;
                                  } else {
                                    isCCTOn = false;
                                  }
                                  if ((items[index] == 'RGB')) {
                                    isRGBOn = true;
                                  } else {
                                    isRGBOn = false;
                                  }
                                });
                              },
                              children: List<Widget>.generate(items.length,
                                  (int index) {
                                return Center(
                                  child: Text(
                                    items[index],
                                  ),
                                );
                              }),
                            ),
                          )
                        : Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            child: Center(
                              child: Text(
                                widget.saida,
                                style: const TextStyle(fontSize: 25.0),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              //   const Spacer(),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'Programar de hora',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: Colors.cyan,
                        value: programarHora,
                        onChanged: (v) {
                          setState(() {
                            programarHora = v;
                          });
                        })
                  ],
                ),
              ),
              programarHora
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Container(
                                width: size.width * .403,
                                height: 20,
                                decoration:
                                    const BoxDecoration(color: Colors.cyan),
                                child: const Center(
                                  child: Text(
                                    'Ligar',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * .4,
                                height: 180,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: Colors.cyan),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: -1,
                                      right: -1,
                                      child: IconButton(
                                        icon: const Icon(
                                            Icons.access_time_filled_outlined),
                                        onPressed: () {
                                          _showDialog(
                                            CupertinoDatePicker(
                                              initialDateTime: time,
                                              mode:
                                                  CupertinoDatePickerMode.time,
                                              use24hFormat: true,
                                              // This is called when the user changes the time.
                                              onDateTimeChanged:
                                                  (DateTime newTime) {
                                                setState(() => time = newTime);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 10,
                                      child: Container(
                                        width: 100,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 69, 67, 67)),
                                        ),
                                        child: ListView.builder(
                                            itemCount: _horaDeInicio.length,
                                            itemBuilder: (context, index) {
                                              return TextButton(
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero),
                                                onPressed: () {},
                                                onLongPress: () {
                                                  setState(
                                                    () {
                                                      _horaDeInicio.remove(
                                                          _horaDeInicio[index]);
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  '${_horaDeInicio[index].hour}:${_horaDeInicio[index].minute}',
                                                  style: const TextStyle(
                                                      fontSize: 22.0,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            width: size.width * .3,
                            height: 200,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: Colors.cyan)),
                          ),
                        )
                      ],
                    )
                  : const Text(''),
              ///////

              const Spacer(),
              widget.editable
                  ? ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _db.child('Dispo$disp').child("Saida$saida").update({
                            'nome': nome.text,
                            'saida': saida,
                            'isDimmerIsOn': isDimmerIsOn,
                            'isCCTOn': isCCTOn,
                            'isRGBOn': isRGBOn,
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _db
                                  .child('Dispo$disp')
                                  .child("Saida$saida")
                                  .update({
                                'nome': nome.text,
                                'saida': saida,
                                'isDimmerIsOn': isDimmerIsOn,
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            "Update",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _db
                                  .child('Dispo$disp')
                                  .child("Saida$saida")
                                  .remove();
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            "Apagar",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _obtenerCredenciales() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      disp = preference.getString('disp') ?? '';
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      // _horaDeInicio.add(time);
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            const Spacer(),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                
              ),
              child:Row(
                children: [
                    Text(
                      'Todos os Dias',
                      style: TextStyle(fontSize: 15)
                    ),
              
                 const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10 ),
                    child: CupertinoCheckbox(
                      activeColor: Colors.cyan ,
                      inactiveColor: Colors.cyan,
                      value: true, onChanged: (value){}),
                  ),
                ],
              )
            ),
            Row(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * .5,
                  decoration: BoxDecoration(
                    color:
                        CupertinoColors.systemBackground.resolveFrom(context),
                  ),
                  padding: const EdgeInsets.only(top: 6.0),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SafeArea(
                    top: false,
                    child: child,
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * .5,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBackground
                            .resolveFrom(context),
                      ),
                      child: SafeArea(
                        top: false,
                        child: CupertinoPicker(
                            itemExtent: 64,
                            onSelectedItemChanged: (int value) {},
                            children: diasMap
                                .map((i, dia) => MapEntry(
                                      i,
                                      DayButton(
                                        isButtonPress: diasAcitvos[i],
                                        dia: dia,
                                        onClicked: () {
                                          debugPrint('$i');
                                          setState(() {
                                            diasAcitvos[i] = !diasAcitvos[i];
                                          });
                                        },
                                      ),
                                    ))
                                .values
                                .toList()),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: IconButton(
                        onPressed: () {
                          _refresh();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        );
      }),
    );
  }

  void _refresh() {
    _horaDeInicio.add(time);
    setState(() {
      debugPrint(_horaDeInicio.toString());
      debugPrint('unix time : ${time.millisecondsSinceEpoch}');
    });
  }
}
