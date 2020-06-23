import 'package:flutter/cupertino.dart';
import 'package:podcast_search/podcast_search.dart';

Future<List<Podcast>> fetchAllPods(List<String> podcastNames) async {
  final List<Podcast> allPodcasts = List();
  for (int i = 0; i < podcastNames.length; i++) {
    allPodcasts.add(await getThePodcast(podcastNames[i]));
  }
  debugPrint('list of all podcasts : ${allPodcasts}');
  return allPodcasts;
}

Future<Podcast> getThePodcast(String podcastName) async {
  var search = Search();

  /// Search for the "It's a Widget" podcast.
  var results =
      await search.search(podcastName, country: Country.UNITED_STATES);

  /// List the name of each podcast found.
  results.items?.forEach((result) {
    print('Found podcast: ${result}');
  });
  var podcast = await Podcast.loadFeed(url: results.items[0].feedUrl);
  debugPrint(results.items[0].feedUrl);

  /// Display episode titles.
  podcast.episodes?.forEach((episode) {
//    print('Episode title: ${episode.title}');
  });
  return podcast;
}

//
//Future<Podcast> getChawg() async {
//  var search = Search();
//
//  /// Search for the "It's a Widget" podcast.
//  var results = await search.search('chawg', country: Country.UNITED_STATES);
//
//  /// List the name of each podcast found.
//  results.items?.forEach((result) {
//    print('Found podcast: ${result}');
//  });
//
//  /// Parse the first podcast.
//  var podcast = await Podcast.loadFeed(url: results.items[0].feedUrl);
//  debugPrint(results.items[0].feedUrl);
//
//  /// Display episode titles.
//  podcast.episodes?.forEach((episode) {
//    print('Episode title: ${episode.title}');
//  });
//
//  /// Find the top 10 podcasts in the UK.
//  var charts = await search.charts(limit: 10, country: Country.UNITED_STATES);
//
//  /// List the name of each podcast found.
//  charts.items?.forEach((result) {
//    print('Found podcast: ${result.trackName}');
//  });
//  return podcast;
//}
