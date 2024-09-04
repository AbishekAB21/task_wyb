import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  int _currentIndex = 0;
  bool _isTransitioning = false;

  final List<String> _videoPaths = [
    'assets/video0.mp4',
    'assets/video1.mp4',
    'assets/video2.mp4',
    'assets/video3.mp4',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAndPlay(_currentIndex);
  }

  void _initializeAndPlay(int index) async {
    setState(() {
      _isTransitioning = true;
    });

    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
    }

    _controller = VideoPlayerController.asset(_videoPaths[index])
      ..initialize().then((_) {
        setState(() {
          _isTransitioning = false;
        });
        _controller?.play();
      });
  }

  void _onProfileTapped(int index) {
    if (_currentIndex != index && !_isTransitioning) {
      setState(() {
        _currentIndex = index;
      });
      _initializeAndPlay(_currentIndex);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_controller?.value.isInitialized ?? false)
            AnimatedOpacity(
              opacity: _isTransitioning ? 0.0 : 1.0,
              duration: Duration(milliseconds: 500),
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),
            )
          else
            Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_videoPaths.length, (index) {
                  return GestureDetector(
                    onTap: () => _onProfileTapped(index),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _currentIndex == index ? 80.0 : 60.0,
                      height: _currentIndex == index ? 80.0 : 60.0,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/profile$index.jpg'),
                        child: _currentIndex == index
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
