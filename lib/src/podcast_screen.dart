// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Simple_Podcast_Player/config.dart';
import 'package:Simple_Podcast_Player/src/podcast_item_card.dart';
import 'package:Simple_Podcast_Player/src/search_podcast.dart';
import 'package:Simple_Podcast_Player/src/widgets/standard_btns.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastPage extends StatefulWidget {
  @override
  _PodcastPageState createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Container(
          padding: EdgeInsets.only(
            top: 130,
          ),
          child: Container(
            height: 65,
            width: 65,
            child: circleBtnDark(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icons.close,
                iconSize: 20),
          ),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: FutureBuilder<List<Podcast>>(
                future: fetchAllPods(podcastList),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LinearProgressIndicator();
                  }
                  List<Podcast> podcasts = snapshot.data;
                  return ListView.builder(
                    itemCount: podcasts.length,
                    itemBuilder: (context, i) {
                      return PodcastItemCard(
                        podcast: podcasts[i],
                      );
                    },
                  );
                }),
          ),
        ));
  }

//  List<Widget> _makeTheChildren(List<Podcast> podcasts) {
//    List<Widget> _items = List();
//    for (int i = 0; i < podcasts.length; i++) {
//      _items.add(
//    }
//    return _items;
//  }
}
