import 'package:Simple_Podcast_Player/src/widgets/platform_ready_widgets.dart';
import 'package:Simple_Podcast_Player/src/widgets/standard_btns.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart' as intl;
import 'package:just_audio/just_audio.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

class TheJustAudioPlayer extends StatefulWidget {
  final Episode episode;

  const TheJustAudioPlayer({Key key, this.episode}) : super(key: key);

  @override
  The_JustAudioPlayerState createState() => The_JustAudioPlayerState();
}

class The_JustAudioPlayerState extends State<TheJustAudioPlayer> {
  final _volumeSubject = BehaviorSubject.seeded(1.0);
  final _speedSubject = BehaviorSubject.seeded(1.0);
  AudioPlayer _player;
  String _playerTxt = '00:00:00';

  @override
  void initState() {
    super.initState();
    AudioPlayer.setIosCategory(IosCategory.playback);
    _player = AudioPlayer();
    _player.setUrl(widget.episode.contentUrl).catchError((error) {
      // catch audio error ex: 404 url, wrong url ...
      print(error);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Container(
        padding: EdgeInsets.only(
          top: 130,
        ),
        child: SafeArea(
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
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(right: 10, left: 10, top: 50),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.black38,
                              Colors.black12,
                              Colors.transparent
                            ]),
                            borderRadius: BorderRadius.circular(10)),
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Html(
                              data: widget.episode.description,
                              onLinkTap: (url) => launch(url),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: StreamBuilder<FullAudioPlaybackState>(
                      stream: _player.fullPlaybackStateStream,
                      builder: (context, snapshot) {
                        final fullState = snapshot.data;
                        final state = fullState?.state;
                        final buffering = fullState?.buffering;
                        return Column(
                          children: [
                            if (state == AudioPlaybackState.connecting)
                              Container(height: 50, child: whichSmallLoading())
                            else
                              Container(
                                height: 50,
                              ),
                            StreamBuilder<Duration>(
                              stream: _player.durationStream,
                              builder: (context, snapshot) {
                                final duration = snapshot.data ?? Duration.zero;
                                return StreamBuilder<Duration>(
                                  stream: _player.getPositionStream(),
                                  builder: (context, snapshot) {
                                    var position =
                                        snapshot.data ?? Duration.zero;
                                    if (position > duration) {
                                      position = duration;
                                    }
                                    DateTime date =
                                        new DateTime.fromMillisecondsSinceEpoch(
                                            position.inMilliseconds,
                                            isUtc: true);
                                    String txt = intl.DateFormat('mm:ss:SS')
                                        .format(date);

                                    this._playerTxt = txt.substring(0, 8);

                                    return Column(
                                      children: [
                                        Divider(
                                          color: Colors.transparent,
                                        ),
                                        Text(
                                          _playerTxt.toString(),
                                          style: TextStyle(
                                              color: Colors.grey[200],
                                              fontSize: 18,
                                              letterSpacing: 4.0),
                                        ),
                                        SeekBar(
                                          duration: duration,
                                          position: position,
                                          onChangeEnd: (newPosition) {
                                            _player.seek(newPosition);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: circleBtnDark(
                                          icon: Icons.fast_rewind,
                                          onPressed: () => _player.seek(
                                              _player.position -
                                                  Duration(seconds: 10))),
                                      height: 80,
                                    ),
                                  ),
                                  if (state == AudioPlaybackState.playing)
                                    Expanded(
                                      child: Container(
                                        height: 210,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: circleBtnDark(
                                                icon: Icons.pause,
                                                iconSize: 42.0,
                                                onPressed: () {
                                                  _player.pause();
                                                  AudioService.pause();
                                                },
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.transparent,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: circleBtnDark(
                                                  icon: Icons.stop,
                                                  iconSize: 34.0,
                                                  onPressed: state ==
                                                              AudioPlaybackState
                                                                  .stopped ||
                                                          state ==
                                                              AudioPlaybackState
                                                                  .none
                                                      ? null
                                                      : () {
                                                          _player.stop();
                                                          AudioService.stop();
                                                        }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    Expanded(
                                      child: Container(
                                        height: 210,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: circleBtnDark(
                                                  icon: Icons.play_arrow,
                                                  iconSize: 44.0,
                                                  onPressed: () {
                                                    _player.play();
                                                    AudioService.play();
                                                  }),
                                            ),
                                            Divider(
                                              color: Colors.transparent,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: circleBtnDark(
                                                    icon: Icons.stop,
                                                    iconSize: 34.0,
                                                    onPressed: state ==
                                                                AudioPlaybackState
                                                                    .stopped ||
                                                            state ==
                                                                AudioPlaybackState
                                                                    .none
                                                        ? null
                                                        : () {
                                                            _player.stop();
                                                            AudioService.stop();
                                                          }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Container(
                                    child: circleBtnDark(
                                      icon: Icons.fast_forward,
                                      onPressed: () => _player.seek(
                                        _player.position +
                                            Duration(seconds: 10),
                                      ),
                                    ),
                                    height: 80,
                                  ),
                                ],
                              ),
                            ),
//                            Container(
//                              alignment: Alignment.center,
//                              margin: EdgeInsets.only(right: 10, left: 10),
//
//                            ),
//                            Divider(
//                              height: 10,
//                              color: Colors.transparent,
//                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Volume",
                            style: TextStyle(color: Colors.grey[200]),
                          ),
                          Container(
                            child: StreamBuilder<double>(
                              stream: _volumeSubject.stream,
                              builder: (context, snapshot) => Slider(
                                divisions: 5,
                                min: 0.0,
                                max: 2.0,
                                value: snapshot.data ?? 1.0,
                                onChanged: (value) {
                                  _volumeSubject.add(value);
                                  _player.setVolume(value);
                                },
                                activeColor: Colors.amber,
                                inactiveColor: Colors.amber.withOpacity(0.5),
                              ),
                            ),
                          ),
//                        Container(
//                          padding: EdgeInsets.all(10),
//                          decoration: BoxDecoration(
//                              shape: BoxShape.circle, color: Colors.black26),
//                          child: Icon(
//                            FontAwesomeIcons.plus,
//                            size: 10,
//                            color: Colors.grey[600],
//                          ),
//                        ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Speed",
                            style: TextStyle(color: Colors.grey[200]),
                          ),
                          StreamBuilder<double>(
                            stream: _speedSubject.stream,
                            builder: (context, snapshot) => Slider(
                              divisions: 5,
                              min: 0.5,
                              max: 1.5,
                              value: snapshot.data ?? 1.0,
                              onChanged: (value) {
                                _speedSubject.add(value);
                                _player.setSpeed(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

//  @override
//  Widget build(BuildContext context) {
//    return SleekCircularSlider(
////      activeColor: Colors.amber,
////      inactiveColor: Colors.black26,
//      min: 0.0,
//      max: widget.duration.inMilliseconds.toDouble(),
////      value: _dragValue ?? widget.position.inMilliseconds.toDouble(),
//      onChange: (value) {
//        setState(() {
//          _dragValue = value;
//        });
//        if (widget.onChanged != null) {
//          widget.onChanged(Duration(milliseconds: value.round()));
//        }
//      },
//      onChangeEnd: (value) {
//        _dragValue = null;
//        if (widget.onChangeEnd != null) {
//          widget.onChangeEnd(Duration(milliseconds: value.round()));
//        }
//      },
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      activeColor: Colors.amber,
      inactiveColor: Colors.black26,
      min: 0.0,
      max: widget.duration.inMilliseconds.toDouble(),
      value: _dragValue ?? widget.position.inMilliseconds.toDouble(),
      onChanged: (value) {
        setState(() {
          _dragValue = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged(Duration(milliseconds: value.round()));
        }
      },
      onChangeEnd: (value) {
        _dragValue = null;
        if (widget.onChangeEnd != null) {
          widget.onChangeEnd(Duration(milliseconds: value.round()));
        }
      },
    );
  }
}
