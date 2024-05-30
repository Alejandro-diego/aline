import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool isDimmerIsOn = false;
  int selectedItemIndex = 0;

  List<String> items = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '8',
    'Dimmer1',
    'Dimmer2',
    'Dimmer3',
    'RGB1',
    'RGB2'
  ];

  TextEditingController nome = TextEditingController();
  final _db = FirebaseDatabase.instance.ref();

  final _formKey = GlobalKey<FormState>();
  late String saida = '1';
  late String disp = "1000";

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
                cursorColor: Colors.amberAccent,
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
                    borderSide: BorderSide(width: 2, color: Colors.amberAccent),
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
                    child: SizedBox(
                      width: 150.0,
                      child: CupertinoPicker(
                        itemExtent: 40.0,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedItemIndex = index;
                            saida = items[index];
                            if ((items[index] == "Dimmer1") |
                                (items[index] == "Dimmer2") |
                                (items[index] == "Dimmer3")) {
                              isDimmerIsOn = true;
                            } else {
                               isDimmerIsOn = false;

                            }
                          });
                        },
                        children:
                            List<Widget>.generate(items.length, (int index) {
                          return Center(
                            child: Text(
                              items[index],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              widget.editable
                  ? ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _db.child('Dispo$disp').child("Saida$saida").update({
                            'nome': nome.text,
                            'saida': saida,
                            'isDimmerIsOn': isDimmerIsOn,
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
}
