import 'package:Simple_Podcast_Player/src/rating_widget.dart';
import 'package:Simple_Podcast_Player/src/sliver_single_podcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:podcast_search/podcast_search.dart';

import '../config.dart';

class PodcastItemCard extends StatefulWidget {
  final Podcast podcast;

  const PodcastItemCard({Key key, this.podcast}) : super(key: key);
  @override
  _PodcastItemCardState createState() => _PodcastItemCardState();
}

class _PodcastItemCardState extends State<PodcastItemCard> {
  int _podcastRate = 4;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SliverPodcastScreen(
                    podcast: widget.podcast,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 10, left: 10, top: 10),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: neumDarkShadow(),
              gradient: neumStandardGradient()),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Hero(
                          tag: widget.podcast.link ?? widget.podcast.image,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.podcast.image),
                              ),
                            ),
                          ),
                        ),
                        RatingWidget(widget.podcast.title),
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(children: [
                        Text(
                          widget.podcast.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        Divider(),
                        Container(
                          height: 110,
                          child: Html(
                            data: widget.podcast.description,
                          ),
                        ),
                      ]),
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
}
