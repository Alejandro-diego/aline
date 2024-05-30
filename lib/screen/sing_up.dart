import 'package:alines/widget/form_sing_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final _db = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance.authStateChanges();

  final _formKey = GlobalKey<FormState>();
  final usuario = TextEditingController();
  final senha = TextEditingController();
  final email = TextEditingController();
  final disp = TextEditingController();
  final cep = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue,
              Color.fromARGB(255, 20, 74, 167),
            ],
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              Positioned(
                width: size.width * 0.88,
                height: size.height,
                left: size.width * 0.10,
                top: size.height * 0.15,
                child: const Text(
                  'Criar Conta',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
                ),
              ),
              Positioned(
                width: size.width * 0.88,
                height: size.height,
                left: size.width * 0.05,
                top: size.height * 0.05,
                child: FormSigIn(
                  keyvalidator: _formKey,
                  cepController: cep,
                  passcontroller: senha,
                  emailcontroller: email,
                  dispController: disp,
                  nameController: usuario,
                  isSingUP: true,
                ),
              ),
              Positioned(
                left: size.width * 0.2,
                top: size.height * 0.70,
                child: SizedBox(
                  height: 60,
                  width: size.width * 0.60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        siginUp();

                        colocarCredenciales();

                        createDataBase();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 44, 85, 119),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: size.width * 0.01,
                top: size.height * 0.95,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Power By',
                      style: GoogleFonts.cedarvilleCursive(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Text(
                      'IOT',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        textStyle:
                            const TextStyle(color: Colors.red, fontSize: 30),
                      ),
                    ),
                    Text(
                      'ech',
                      style: GoogleFonts.roboto(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future siginUp() async {
    late String error = "erro";
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: senha.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        error = "O endereço de e-mail já está sendo usado por outra conta.";
      } else if (e.code == 'invalid-email') {
        error = "O endereço de e-mail está mal formatado";
      } else if (e.code == 'too-many-requests') {
        error = "Sua conta foi bloqueda temporariaramente";
      } else if (e.code == 'erro') {
        error = "Verifique sua red";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              error,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  Future<void> colocarCredenciales() async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    preference.setString('email', email.text);
    preference.setString('password', senha.text);
    preference.setString('nome', usuario.text);
    preference.setString('disp', disp.text);
    preference.setString('cep', cep.text);
  }

  void createDataBase() async {
    _auth.listen((User? user) {
      if (user == null) {
        debugPrint("logOut");
      } else {
        debugPrint('logIN');

        _db.child('disp${disp.text}').set({
          'disp': disp.text,
        });

        Navigator.of(context).pop();
      }
    });
  }
}
