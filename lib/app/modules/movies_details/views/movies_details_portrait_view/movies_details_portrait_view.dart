import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movs_app/app/modules/movies_home/models/movies_model.dart';
import 'package:movs_app/app/services/database_helper.dart';

import '../../../../../main.dart';

class MovieDetail extends StatefulWidget {
  final data;

  const MovieDetail({Key? key, this.data}) : super(key: key);

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  final Color primaryColor = const Color(0XFF0D0F14);
  bool isAddedToFavorite = false;

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
                    height: MediaQuery.of(context).size.height * .6,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/original/${widget.data['poster_path']}',
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
                    radius: 50,
                    borderRadius: BorderRadius.circular(50),
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
                            cardInfo:
                                widget.data['adult'] == false ? "13 +" : "18 +",
                          ),
                          // card(cardInfo: data['release_date']),
                          card(
                            cardInfo: widget.data['vote_average'],
                            hasStar: true,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () async {
                              if (isAddedToFavorite == true) {
                                setState(() {
                                  isAddedToFavorite = false;
                                });
                                DatabaseHelper.instance
                                    .delete(widget.data['id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: Colors.white,
                                    content: Text(
                                      'Movie has been removed to Favorite!',
                                      style: GoogleFonts.dmSans(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: -.2,
                                      ),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                    ),
                                  ),
                                );
                              } else if (isAddedToFavorite == false) {
                                setState(() {
                                  isAddedToFavorite = true;
                                });
                                await DatabaseHelper.instance.add(
                                  MoviesModel(
                                    image:
                                        'https://image.tmdb.org/t/p/original/${widget.data['poster_path']}',
                                    id: widget.data['id'],
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: Colors.white,
                                    content: Text(
                                      'Movie has been added to Favorite!',
                                      style: GoogleFonts.dmSans(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        letterSpacing: -.2,
                                      ),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: SvgPicture.asset(
                              isAddedToFavorite == true
                                  ? 'assets/svgs/add-square.svg'
                                  : 'assets/svgs/add-square-1.svg',
                              // height: 30,
                              color: isAddedToFavorite == true
                                  ? Colors.pink
                                  : Colors.white,
                            ),
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
                          widget.data['title'] ??
                              widget.data['name'] ??
                              widget.data['original_title'] ??
                              widget.data['original_name'] ??
                              '',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: -.2,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.data['overview'],
                          style: GoogleFonts.dmSans(
                            color: Colors.white70,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            letterSpacing: -.2,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          ('${widget.data['release_date']}'),
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            letterSpacing: -.2,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.start,
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
