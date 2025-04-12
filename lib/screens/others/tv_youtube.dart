import 'package:astrobandhan/widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerPage extends StatefulWidget {
  final String videoId;

  const YouTubePlayerPage({super.key, required this.videoId});

  @override
  _YouTubePlayerPageState createState() => _YouTubePlayerPageState();
}

class _YouTubePlayerPageState extends State<YouTubePlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(initialVideoId: widget.videoId, flags: const YoutubePlayerFlags(autoPlay: true, mute: false));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool value, data) async {
        _controller.dispose();
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        return Future.value(value);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'Astro Video', textAlignCenter: true),
        body: YoutubePlayer(controller: _controller, showVideoProgressIndicator: true),
      ),
    );
  }
}
