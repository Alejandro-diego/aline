import 'package:alines/screen/login_page.dart';
import 'package:alines/screen/sing_up.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:outlined_text/outlined_text.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  double fontSize1 = 50;
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
              Colors.orange,
              Color.fromARGB(255, 224, 88, 9),
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(223, 127, 197, 243)),
                child: OutlinedText(
                  text: Text(
                    'Alines',
                    style: TextStyle(
                        fontFamily: 'ArialBlack',
                        color: Colors.white,
                        fontSize: fontSize1),
                  ),
                  strokes: [
                    OutlinedTextStroke(
                        color: const Color(0xff1528ff), width: 8),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  'Quer ter uma conta para \n controlar sua Casa?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 60,
                width: size.width * 0.60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const SingUp(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 44, 85, 119),
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'Criar Conta ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Ja tem conta?'),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Fazer Login',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 44, 85, 119)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
