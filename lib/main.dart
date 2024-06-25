import 'package:alines/model/provider_from_rtdb.dart';
import 'package:alines/screen/home_page.dart';
import 'package:alines/screen/intro_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataProvider(),
        ),
      ],
      child: const Miapp(),
    ),
  );
}

class Miapp extends StatelessWidget {
  const Miapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alines',
      theme: ThemeData(
        //colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      home: const Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: Colors.black,
      duration: 1000,
      splash: Row(
        children: [
          Lottie.asset('assets/bolas1.json'),
          Text(
            'IOT',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              textStyle: const TextStyle(color: Colors.red, fontSize: 60),
            ),
          ),
          Text(
            'ech',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(color: Colors.white, fontSize: 50),
            ),
          ),
        ],
      ),
      nextScreen: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (snapshot.hasError) {
            const Center(
              child: Text('Error'),
            );
          } else if (snapshot.hasData) {
            return const HomePage();
          }
          return const IntroPage();
        },
      ),
    );
  }
}
