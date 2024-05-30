
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FormSigIn extends StatefulWidget {
  const FormSigIn(
      {super.key,
      this.isSingUP = false,
      required this.nameController,
      required this.dispController,
      required this.emailcontroller,
      required this.keyvalidator,
      required this.cepController,
      required this.passcontroller});

  final TextEditingController emailcontroller;
  final TextEditingController passcontroller;
  final TextEditingController nameController;
  final GlobalKey<FormState> keyvalidator;
  final TextEditingController dispController;
  final TextEditingController cepController;
  final bool isSingUP;

  @override
  State<FormSigIn> createState() => _FormSigInState();
}

class _FormSigInState extends State<FormSigIn> {
  bool showPass = false;

  @override
  void initState() {
    _obtenerCredenciales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02),
      child: Form(
        key: widget.keyvalidator,
        child: Column(
          children: [
            const Spacer(),
            widget.isSingUP
                ? TextFormField(
                    keyboardType: TextInputType.name,
                    controller: widget.nameController,
                    cursorColor: Colors.amberAccent,
                    // style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      hintText: 'Nome',
                      prefixIcon: Padding(
                        padding: EdgeInsetsDirectional.only(start: 2),
                        child: Icon(
                          Icons.person_2_outlined,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.amberAccent),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresar Nome';
                      }
                      return null;
                    },
                  )
                : const Text(""),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: widget.emailcontroller,
              cursorColor: Colors.amberAccent,
              // style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                hintText: 'E-mail',
                prefixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(start: 2),
                  child: Icon(
                    Icons.mail_outline,
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
                  return 'Ingresar e-mail';
                }
                return null;
              },
            ),
            TextFormField(
              controller: widget.passcontroller,
              cursorColor: Colors.amberAccent,
              //style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'Senha',
                prefixIcon: const Padding(
                  padding: EdgeInsetsDirectional.only(start: 2),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 35,
                    color: Colors.grey,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () => setState(() {
                    showPass = !showPass;
                  }),
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: showPass ? Colors.amber : Colors.grey,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.amberAccent),
                ),
              ),
              obscureText: !showPass,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Senha';
                }
                return null;
              },
            ),
           
                 TextFormField(
                    keyboardType: TextInputType.number,
                    controller: widget.dispController,
                    cursorColor: Colors.amberAccent,
                    // style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      hintText: 'Dispositivo',
                      prefixIcon: Padding(
                        padding: EdgeInsetsDirectional.only(start: 2),
                        child: Icon(
                          Icons.beach_access,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.amberAccent),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresar Dispositivo';
                      }
                      return null;
                    },
                  )
                ,
            widget.isSingUP
                ? TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CepInputFormatter(),
                    ],

                    keyboardType: TextInputType.number,
                    controller: widget.cepController,
                    cursorColor: Colors.amberAccent,
                    // style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      hintText: 'CEP',
                      prefixIcon: Padding(
                        padding: EdgeInsetsDirectional.only(start: 2),
                        child: Icon(
                          Icons.location_on,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.amberAccent),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresar CEP';
                      }
                      return null;
                    },
                  )
                : const Text(""),
            const Spacer(flex: 2)
          ],
        ),
      ),
    );
  }

  Future<void> _obtenerCredenciales() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      widget.passcontroller.text = preference.getString('password') ?? '';
      widget.emailcontroller.text = preference.getString('email') ?? '';
      widget.dispController.text = preference.getString('disp') ?? '';
      widget.nameController.text = preference.getString('nome') ?? '';
      widget.cepController.text = preference.getString('cep') ?? "";
    });
  }
}
