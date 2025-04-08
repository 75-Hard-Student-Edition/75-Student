import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MindfulnessPage extends StatefulWidget {
  @override
  _MindfulnessPageState createState() => _MindfulnessPageState();
}

class _MindfulnessPageState extends State<MindfulnessPage> {
  late VideoPlayerController _controller;
  Duration duration = Duration(minutes: 30);
  Timer? _timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/vid2.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
      });
  }

  void startSession() {
    if (!_controller.value.isPlaying) {
      _controller.play();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (duration.inSeconds > 0) {
          duration = duration - Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _controller.pause();
        }
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void stopSession() {
    _controller.pause();
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void restartSession() {
    _controller.seekTo(Duration.zero);
    _controller.play();
    _timer?.cancel();
    setState(() {
      duration = Duration(minutes: 30);
      isRunning = true;
    });
    startSession();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F7F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              "Mindfulness",
              style: TextStyle(
                fontFamily: "kdamThmorPro",
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 23, 212, 190),
              ),
            ),
            SizedBox(height: 20),

            // Breathing Video
            _controller.value.isInitialized
                ? SizedBox(
                    width: 500, // You can adjust this width as needed
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : CircularProgressIndicator(),

            SizedBox(height: 5),

            Icon(
              Icons.play_arrow,
              size: 40,
              color: const Color.fromARGB(255, 23, 212, 190),
            ),
            SizedBox(height: 10),

            // Timer
            Text(
              formatTime(duration),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 5),
            Text(
              "breathe in, breathe out",
              style: TextStyle(
                fontFamily: "kdamThmorPro",
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            SizedBox(height: 30),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // START
                ElevatedButton(
                  onPressed: isRunning ? null : startSession,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: Colors.green[300],
                    shadowColor: Colors.grey,
                    elevation: 4,
                  ),
                  child: Text(
                    "START",
                    style: TextStyle(fontFamily: "kdamThmorPro"),
                  ),
                ),
                SizedBox(width: 90),

                // STOP
                ElevatedButton(
                  onPressed: isRunning ? stopSession : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: Colors.red[300],
                    shadowColor: Colors.grey,
                    elevation: 4,
                  ),
                  child: Text(
                    "STOP",
                    style: TextStyle(fontFamily: "kdamThmorPro"),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // RESTART
            ElevatedButton(
              onPressed: restartSession,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: Colors.teal[300],
                shadowColor: Colors.grey,
                elevation: 4,
              ),
              child: Text(
                "RESTART",
                style: TextStyle(fontFamily: "kdamThmorPro"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
