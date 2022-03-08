import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'dart:convert';

void main() {
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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Color primaryColor = const Color(0XFF0D0F14);
  // int _currentTrendingMovieIndex = 0;
  late Timer _timer;
  bool isIncrementing = true;
  List trendingMovies = [];
  List topRated = [];
  final String apiKey = 'eba28ba66161c0c71a3d57eb9e73b53f',
      accessToken =
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYmEyOGJhNjYxNjFjMGM3MWEzZDU3ZWI5ZTczYjUzZiIsInN1YiI6IjYyMjcxNzRkMDllZDhmMDA1ZTVhNzdlNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yHNNLZHPvkmNJePtg3ZUNHCqlrkV13w1p9_-KzK_VOI';
  PageController pageController = PageController(
    viewportFraction: .58,
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    loadTrendingMovies();
    // _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
    //   if (_currentTrendingMovieIndex < (trendingMovies.length - 1) &&
    //       isIncrementing == true) {
    //     _currentTrendingMovieIndex++;
    //     if (_currentTrendingMovieIndex == trendingMovies.length - 1) {
    //       isIncrementing = false;
    //     }
    //   } else if (_currentTrendingMovieIndex > 0 && isIncrementing == false) {
    //     _currentTrendingMovieIndex--;
    //     if (_currentTrendingMovieIndex == 0) {
    //       isIncrementing = true;
    //     }
    //   }
    //   pageController.animateToPage(
    //     _currentTrendingMovieIndex,
    //     duration: const Duration(milliseconds: 350),
    //     curve: Curves.easeIn,
    //   );
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  loadTrendingMovies() async {
    TMDB tmdb = TMDB(
      ApiKeys(apiKey, accessToken),
      logConfig: const ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    Map trendingMoviesResult = (await tmdb.v3.trending.getTrending());
    Map topRatedResult = (await tmdb.v3.tv.getTopRated());
    setState(() {
      trendingMovies = trendingMoviesResult['results'];
      topRated = topRatedResult['results'];
    });
    if (kDebugMode) {
      print(trendingMovies);
      print(topRated);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 18.0),
              //       child: Text(
              //         'Top Rated',
              //         style: GoogleFonts.dmSans(
              //           fontSize: 24,
              //           fontWeight: FontWeight.normal,
              //           letterSpacing: -.2,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //     const SizedBox(height: 18),
              //     SizedBox(
              //       height: MediaQuery.of(context).size.height * .350,
              //       child: PageView.builder(
              //         itemCount: topRated.length,
              //         controller: pageController,
              //         allowImplicitScrolling: true,
              //         itemBuilder: (BuildContext context, int index) {
              //           return trendingMoviesCard(
              //               image: topRated[index]['backdrop_path'] ?? '',
              //               title: topRated[index]['title'] ??
              //                   topRated[index]['name'] ??
              //                   topRated[index]['original_title'] ??
              //                   topRated[index]['original_name'] ??
              //                   '',
              //               ageRange: topRated[index]['adult'] == false
              //                   ? "13 +"
              //                   : "18 +",
              //               movieType: 'Action',
              //               rating: topRated[index]['vote_average']);
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      'Trending Now',
                      style: GoogleFonts.dmSans(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        letterSpacing: -.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .555,
                    child: ListView.builder(
                      itemCount: trendingMovies.length,
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      // allowImplicitScrolling: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetail(
                                data: trendingMovies[index],
                              ),
                            ),
                          ),
                          child: trendingMoviesCard(
                              image: trendingMovies[index]['poster_path'],
                              title: trendingMovies[index]['title'] ??
                                  trendingMovies[index]['name'] ??
                                  trendingMovies[index]['original_title'] ??
                                  trendingMovies[index]['original_name'] ??
                                  '',
                              ageRange: trendingMovies[index]['adult'] == false
                                  ? "13 +"
                                  : "18 +",
                              movieType: 'Action',
                              rating: trendingMovies[index]['vote_average']),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget trendingMoviesCard({
    required String image,
    title,
    ageRange,
    movieType,
    rating,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: MediaQuery.of(context).size.width * .566,
      height: MediaQuery.of(context).size.height * .255,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: MediaQuery.of(context).size.height * .363,
            width: MediaQuery.of(context).size.width * .512,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white12,
              image: DecorationImage(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/original/$image',
                ),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            // child: Image.asset(image),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              card(
                cardInfo: ageRange,
              ),
              card(cardInfo: movieType),
              card(
                cardInfo: rating,
                hasStar: true,
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .444,
            child: Text(
              title.toString(),
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 18,
                letterSpacing: -.2,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class MovieDetail extends StatelessWidget {
  final data;
  final Color primaryColor = const Color(0XFF0D0F14);
  const MovieDetail({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withOpacity(1.0),
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.0),
                      ],
                      stops: const [.0, .4, .8, 1.0],
                    ).createShader(
                      Rect.fromLTRB(
                        0,
                        0,
                        rect.width,
                        rect.height,
                      ),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    height: MediaQuery.of(context).size.height * .65,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/original/${data['poster_path']}',
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    // child: Image.asset(image),
                  ),
                ),
                Positioned(
                  top: 48,
                  left: 18,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white12,
                      ),
                      child: SvgPicture.asset(
                        'assets/svgs/arrow-left.svg',
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          card(
                            cardInfo: data['adult'] == false ? "13 +" : "18 +",
                          ),
                          card(cardInfo: 'Action'),
                          card(
                            cardInfo: data['vote_average'],
                            hasStar: true,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/close-square.svg',
                            height: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 24),
                          SvgPicture.asset(
                            'assets/svgs/send-2.svg',
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      top: 20,
                      bottom: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'] ??
                              data['name'] ??
                              data['original_title'] ??
                              data['original_name'] ??
                              '',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 24,
                            letterSpacing: -.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          data['overview'],
                          style: GoogleFonts.dmSans(
                            color: Colors.white70,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            letterSpacing: -.2,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.start,
                          // maxLines: 4,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        hasStar ? SvgPicture.asset('assets/svgs/star.svg') : const SizedBox(),
        hasStar ? const SizedBox(width: 4) : const SizedBox(),
        Text(
          cardInfo.toString(),
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: .2,
          ),
        ),
      ],
    ),
  );
}
