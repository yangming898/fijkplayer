import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';
// import 'custom_ui.dart';

class VideoScreen extends StatefulWidget {
  final String url;

  VideoScreen({required this.url});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();

  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
    player.setOption(FijkOption.playerCategory, "mediacodec-all-videos", 1);

    startPlay();
  }

  void startPlay() async {
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.playerCategory, "mediacodec", 0);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 0);
    await player.setOption(FijkOption.formatCategory, "rtsp_transport", "tcp");
    await player.setOption(
        FijkOption.formatCategory, "rtsp_flags", "prefer_tcp");
    await player.setOption(FijkOption.formatCategory, "packet-buffering", 0);
    await player.setOption(
        FijkOption.playerCategory, "enable-accurate-seek", 1);
    // await player.setOption(FijkOption.formatCategory, "flush_packets", 1);
    // await player.setOption(FijkOption.formatCategory, "probesize", 1);
    // await player.setOption(FijkOption.formatCategory, "analyzeduration", 10);

    await player.setDataSource(widget.url, autoPlay: true).catchError((e) {
      print("setDataSource error: $e");
    });

    player.setVolume(100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FijkAppBar.defaultSetting(title: "Video"),
      body: Container(
        child: Center(
          child: FijkView(
            player: player,
            panelBuilder: fijkPanel2Builder(snapShot: true),
            fsFit: FijkFit.fill,
            // panelBuilder: simplestUI,
            // panelBuilder: (FijkPlayer player, BuildContext context,
            //     Size viewSize, Rect texturePos) {
            //   return CustomFijkPanel(
            //       player: player,
            //       buildContext: context,
            //       viewSize: viewSize,
            //       texturePos: texturePos);
            // },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
