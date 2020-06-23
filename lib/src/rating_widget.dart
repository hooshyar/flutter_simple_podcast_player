import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingWidget extends StatefulWidget {
  RatingWidget(this.ratingRecordName, {this.iconSize});
  final String ratingRecordName;
  double iconSize = 36.0;
  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _podcastRate = 4;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          FittedBox(
            child: SmoothStarRating(
                allowHalfRating: false,
                onRated: (v) {
                  setState(() {
                    _podcastRate = v.floor();
                  });
                },
                starCount: 5,
                rating: _podcastRate.toDouble(),
                size: widget.iconSize,
                isReadOnly: false,
                color: Colors.amber,
                borderColor: Colors.amber.withOpacity(0.5),
                spacing: 0.0),
          ),
          Text('votes: 214'),
        ],
      ),
    );
  }
}
