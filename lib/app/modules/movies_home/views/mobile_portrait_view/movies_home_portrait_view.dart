import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:movs_app/app/modules/saved_movies/views/mobile_portrait_view/saved_movies_portrait_view.dart';

import '../../../../../main.dart';
import '../../../movies_details/views/movies_details_portrait_view/movies_details_portrait_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final Color primaryColor = const Color(0XFF0D0F14);
  int _currentTrendingMovieIndex = 0;
  late Timer _timer;
  bool isIncrementing = true;
  List trendingMovies = [];
  List upcomingMovies = [];
  late final TabController _tabController;

  final String apiKey = 'eba28ba66161c0c71a3d57eb9e73b53f',
      urlTrendingMovies =
          'https://api.themoviedb.org/3/trending/all/day?api_key=eba28ba66161c0c71a3d57eb9e73b53f',
      urlUpcomingMovies =
          'https://api.themoviedb.org/3/movie/upcoming?api_key=eba28ba66161c0c71a3d57eb9e73b53f&language=en-US&page=1',
      accessToken =
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlYmEyOGJhNjYxNjFjMGM3MWEzZDU3ZWI5ZTczYjUzZiIsInN1YiI6IjYyMjcxNzRkMDllZDhmMDA1ZTVhNzdlNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yHNNLZHPvkmNJePtg3ZUNHCqlrkV13w1p9_-KzK_VOI';
  PageController pageController = PageController(
    viewportFraction: .58,
    initialPage: 0,
  );

  PageController pageController2 = PageController(
    viewportFraction: 1,
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    loadTrendingMoviesUsingHTTP();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_currentTrendingMovieIndex < (trendingMovies.length - 1) &&
          isIncrementing == true) {
        _currentTrendingMovieIndex++;
      } else {
        _currentTrendingMovieIndex = 0;
      }
      if (pageController2.hasClients) {
        pageController2.animateToPage(
          _currentTrendingMovieIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void loadTrendingMoviesUsingHTTP() async {
    try {
      final trendingMoviesResponse = await get(Uri.parse(urlTrendingMovies));
      final upcomingMoviesResponse = await get(Uri.parse(urlUpcomingMovies));
      final trendingMoviesJsonData =
          jsonDecode(trendingMoviesResponse.body) as Map;
      final upcomingMoviesJsonData =
          jsonDecode(upcomingMoviesResponse.body) as Map;
      setState(() {
        trendingMovies = trendingMoviesJsonData['results'];
        upcomingMovies = upcomingMoviesJsonData['results'];
      });
      // if (kDebugMode) {
      //   print(trendingMovies.toString());
      //   print(upcomingMovies);
      // }
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0.0,
            ),
            child: Theme(
              data: ThemeData().copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                labelColor: Colors.orange,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                automaticIndicatorColorAdjustment: true,
                unselectedLabelColor: Colors.white.withOpacity(.85),
                controller: _tabController,
                labelPadding: const EdgeInsets.symmetric(vertical: 16),
                indicatorColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(
                  Colors.transparent,
                ),
                tabs: [
                  Text(
                    'Movies',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      letterSpacing: -.2,
                    ),
                  ),
                  Text(
                    'My List',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      letterSpacing: -.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: TabBarView(
        controller: _tabController,
        children: [
          Scaffold(
            backgroundColor: primaryColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          'Coming Soon',
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .232,
                        child: PageView.builder(
                          itemCount: upcomingMovies.length,
                          controller: pageController2,
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
                                    data: upcomingMovies[index],
                                  ),
                                ),
                              ),
                              child: comingSoon(
                                  image: upcomingMovies[index]['backdrop_path'],
                                  title: upcomingMovies[index]['title'] ??
                                      upcomingMovies[index]['name'] ??
                                      upcomingMovies[index]['original_title'] ??
                                      upcomingMovies[index]['original_name'] ??
                                      '',
                                  ageRange:
                                      upcomingMovies[index]['adult'] == false
                                          ? "13 +"
                                          : "18 +",
                                  // movieType: topRated[index]['release_date'],
                                  rating: upcomingMovies[index]
                                      ['vote_average']),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          'Trending Now',
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .525,
                        child: ListView.builder(
                          itemCount: trendingMovies.length,
                          controller: pageController,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
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
                                  ageRange:
                                      trendingMovies[index]['adult'] == false
                                          ? "13 +"
                                          : "18 +",
                                  // movieType: trendingMovies[index]['release_date'],
                                  rating: trendingMovies[index]
                                      ['vote_average']),
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
          const SavedMoviesPortraitView(),
        ],
      )),
    );
  }

  Widget comingSoon({
    required String image,
    title,
    ageRange,
    movieType,
    rating,
  }) {
    return SizedBox(
      // width: MediaQuery.of(context).size.width * .566,
      height: MediaQuery.of(context).size.height * .255,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            height: MediaQuery.of(context).size.height * .222,
            width: MediaQuery.of(context).size.width,
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
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            height: MediaQuery.of(context).size.height * .222,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black26,
            ),
            // child: Image.asset(image),
          ),
          Positioned(
            top: 18,
            left: 38,
            right: 38,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text(
                    title.toString(),
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      letterSpacing: -.2,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SvgPicture.asset(
                  'assets/svgs/send-2.svg',
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
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
    return SizedBox(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: MediaQuery.of(context).size.height * .293,
            width: MediaQuery.of(context).size.width * .388,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
              // card(cardInfo: movieType),
              card(
                cardInfo: rating,
                hasStar: true,
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .414,
            child: Text(
              title.toString(),
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                letterSpacing: -.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
