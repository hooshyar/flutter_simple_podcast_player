import 'dart:math' as math;

import 'package:Simple_Podcast_Player/src/just_audio_player.dart';
import 'package:Simple_Podcast_Player/src/rating_widget.dart';
import 'package:Simple_Podcast_Player/src/widgets/standard_btns.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class SliverPodcastScreen extends StatelessWidget {
  final Podcast podcast;

  const SliverPodcastScreen({Key key, this.podcast}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildPodcastScreen(podcast),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(top: 40, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Container(
                      height: 65,
                      width: 65,
                      margin: EdgeInsets.only(left: 5),
//                      decoration: BoxDecoration(
//                          boxShadow: neumDarkShadow(blurRadius: 6.0, offset: 4),
//                          gradient: neumStandardGradient(),
//                          borderRadius: BorderRadius.circular(10)),
                      child: circleBtnDark(
                        iconSize: 26,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icons.close,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Container(
                      height: 65,
                      width: 65,
                      margin: EdgeInsets.only(left: 5),
//                      decoration: BoxDecoration(
//                          boxShadow: neumDarkShadow(blurRadius: 6.0, offset: 4),
//                          gradient: neumStandardGradient(),
//                          borderRadius: BorderRadius.circular(10)),
                      child: circleBtnDark(
                        icon: Icons.open_in_browser,
                        onPressed: () {
                          launch(podcast.link);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SingleChildPodcastScreen extends StatelessWidget {
  SingleChildPodcastScreen(this.podcast);
  final Podcast podcast;

  SliverPersistentHeader makeHeader() {
    return SliverPersistentHeader(
      pinned: false,
      delegate: _SliverAppBarDelegate(
        minHeight: 200.0,
        maxHeight: 400.0,
        child: Container(
          color: Colors.grey[800],
          child: Stack(
            children: [
              Hero(
                tag: podcast.link ?? podcast.image,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(podcast.image),
                  )),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  children: [
                    Expanded(flex: 2, child: Container()),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.grey[900].withOpacity(0.9),
                            child: Container(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Html(
                                          data: podcast.description,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    RatingWidget(podcast.title, iconSize: 28),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        makeHeader(),
        SliverFixedExtentList(
          itemExtent: 120.0,
          delegate: SliverChildListDelegate(
            buildChildren(context),
          ),
        ),
      ],
    );
  }

  buildChildren(context) {
    final List<Widget> _widgets = List();
    for (int i = 0; i < podcast.episodes.length; i++) {
      _widgets.add(
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AudioServiceWidget(
                child: TheJustAudioPlayer(
                  episode: podcast.episodes[i],
                ),
              ),
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  boxShadow: neumDarkShadow(),
                  gradient: neumStandardGradient(),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        podcast.episodes[i].title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
//              Text(podcast.episodes[i].description),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return _widgets;
  }
}
