import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/modules/movies_home/views/mobile_portrait_view/movies_home_portrait_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Widget card({
  cardInfo,
  hasStar = false,
}) {
  return Container(
    margin: const EdgeInsets.only(
      bottom: 12,
      left: 6,
      right: 6,
      top: 8,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white.withOpacity(.08),
    ),
    child: Row(
      children: [
        hasStar
            ? SvgPicture.asset(
                'assets/svgs/star.svg',
                height: 16,
              )
            : const SizedBox(),
        hasStar ? const SizedBox(width: 4) : const SizedBox(),
        Text(
          cardInfo.toString(),
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.normal,
            letterSpacing: .2,
          ),
        ),
      ],
    ),
  );
}
