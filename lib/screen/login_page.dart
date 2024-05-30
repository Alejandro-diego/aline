import 'package:alines/screen/sing_up.dart';
import 'package:alines/widget/form_sing_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double opacityLevelMail = 0.0;
  double opacityLevelPass = 0.0;
  int tentativasEmail = 1;
  int tentativasPass = 1;

  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final disp = TextEditingController();
  late bool buttonNeedAcountIsEnable = false;
  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _isEnableButtonEmail();
  }

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
                  'LogIn',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
              ),
              Positioned(
                width: size.width * 0.88,
                height: size.height,
                left: size.width * 0.05,
                top: size.height * 0.05,
                child: FormSigIn(
                  nameController: TextEditingController(),
                  dispController: disp,
                  isSingUP: false,
                  keyvalidator: _formKey,
                  passcontroller: senha,
                  emailcontroller: email,
                  cepController: TextEditingController(),
                ),
              ),
              Positioned(
                left: size.width * 0.2,
                top: size.height * 0.64,
                child: SizedBox(
                  height: 60,
                  width: size.width * 0.60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        sigIN();

                        colocarCredenciales();
                        Navigator.of(context).pop();
                      } else {
                        _changeOpacityEmail();
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
                      'Login',
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
              Positioned(
                left: size.width * 0.05,
                top: size.height * 0.53,
                child: AnimatedOpacity(
                  opacity: opacityLevelMail,
                  duration: const Duration(seconds: 2),
                  child: TextButton(
                    onPressed: buttonNeedAcountIsEnable
                        ? () {
                            Navigator.of(context).push(_createRoute());
                          }
                        : () {},
                    child: const Text(
                      'Precisa de uma Conta ?',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: size.width * 0.62,
                top: size.height * 0.53,
                child: AnimatedOpacity(
                  opacity: opacityLevelPass,
                  duration: const Duration(seconds: 2),
                  child: TextButton(
                    child: const Text(
                      'Perdeu sua Senha ?',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future sigIN() async {
    late String error = "erro";
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: senha.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = "E-mail não registrado";
        if (tentativasEmail++ > 2) {
          _changeOpacityEmail();
          buttonNeedAcountIsEnable = true;
        }
      } else if (e.code == 'wrong-password') {
        error = "Senha invalida";

        if (tentativasPass++ > 2) {
          _changeOpacityPass();
        }
      } else if (e.code == 'too-many-requests') {
        error = "Sua conta foi bloqueda temporariaramente";

        if (tentativasPass++ > 2) {
          _changeOpacityPass();
        }
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

    setState(
      () {
        preference.setString('email', email.text);
        preference.setString('password', senha.text);
        preference.setString('disp', disp.text);
      },
    );
  }

  void _changeOpacityEmail() {
    setState(() => opacityLevelMail = opacityLevelMail == 0 ? 1.0 : 0.0);
  }

  void _changeOpacityPass() {
    setState(() => opacityLevelPass = opacityLevelPass == 0 ? 1.0 : 0.0);
  }

  Future<void> _isEnableButtonEmail() async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    var text = preference.getString('email') ?? '';

    if (text.isEmpty) {
      buttonNeedAcountIsEnable = true;
      debugPrint('vacio');
      _changeOpacityEmail();
    }
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const SingUp(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
