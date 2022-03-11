import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movs_app/app/services/database_helper.dart';

import '../../../movies_home/models/movies_model.dart';

class SavedMoviesPortraitView extends StatefulWidget {
  const SavedMoviesPortraitView({Key? key}) : super(key: key);

  @override
  State<SavedMoviesPortraitView> createState() =>
      _SavedMoviesPortraitViewState();
}

class _SavedMoviesPortraitViewState extends State<SavedMoviesPortraitView> {
  final Color primaryColor = const Color(0XFF0D0F14);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: primaryColor,
      body: FutureBuilder<List<MoviesModel>>(
        future: DatabaseHelper.instance.getSavedMovies(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MoviesModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Loading...',
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
            );
          }
          return snapshot.data!.isEmpty
              ? Center(
                  child: Text(
                    'No Saved Movies',
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
              : GridView.count(
                  childAspectRatio: (itemWidth / itemHeight),
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  children: snapshot.data!.map(
                    (savedMovie) {
                      return GestureDetector(
                        onLongPress: () {
                          customAlertDialog(
                            context,
                            id: savedMovie.id,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 8,
                            top: 8,
                          ),
                          height: MediaQuery.of(context).size.height * .222,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white12,
                            image: DecorationImage(
                              image: NetworkImage(
                                savedMovie.image,
                              ),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                          // child: Image.asset(image),
                        ),
                      );
                    },
                  ).toList(),
                );
        },
      ),
    );
  }

  customAlertDialog(BuildContext context, {id}) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: GoogleFonts.dmSans(
          color: Colors.grey,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          letterSpacing: -.2,
        ),
        textAlign: TextAlign.start,
        maxLines: 2,
      ),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: Text(
        "Remove",
        style: GoogleFonts.dmSans(
          color: Colors.red,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          letterSpacing: -.2,
        ),
        textAlign: TextAlign.start,
        maxLines: 2,
      ),
      onPressed: () {
        DatabaseHelper.instance.delete(id);
        setState(() {});
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      content: Text(
        "Remove from my list?",
        style: GoogleFonts.dmSans(
          color: Colors.black87,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          letterSpacing: -.2,
        ),
        textAlign: TextAlign.start,
        maxLines: 2,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
