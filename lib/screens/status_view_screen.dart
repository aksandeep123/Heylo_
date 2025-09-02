import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:whatsapp_ui/models/status.dart';
import 'package:whatsapp_ui/colors.dart';

class StatusViewScreen extends StatefulWidget {
  final Status status;
  
  const StatusViewScreen({Key? key, required this.status}) : super(key: key);

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  VideoPlayerController? videoController;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.status.mediaType == 'video' && !kIsWeb) {
      videoController = VideoPlayerController.file(File(widget.status.mediaPath))
        ..initialize().then((_) {
          setState(() {});
          videoController!.play();
        });
    }
    
    if (widget.status.musicPath != null && !kIsWeb) {
      audioPlayer = AudioPlayer();
      playMusic();
    }
  }

  void playMusic() async {
    if (widget.status.musicPath != null && audioPlayer != null && !kIsWeb) {
      await audioPlayer!.play(DeviceFileSource(widget.status.musicPath!));
      setState(() => isPlaying = true);
    }
  }

  void pauseMusic() async {
    if (audioPlayer != null) {
      await audioPlayer!.pause();
      setState(() => isPlaying = false);
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.status.userImage),
              radius: 16,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.status.userName,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  '${DateTime.now().difference(widget.status.timestamp).inHours}h ago',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: widget.status.mediaType == 'image'
                ? kIsWeb
                    ? Image.network(
                        widget.status.mediaPath,
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        File(widget.status.mediaPath),
                        fit: BoxFit.contain,
                      )
                : kIsWeb
                    ? const Center(
                        child: Text(
                          'Video playback not supported on web',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : videoController != null && videoController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: videoController!.value.aspectRatio,
                            child: VideoPlayer(videoController!),
                          )
                        : const CircularProgressIndicator(),
          ),
          if (widget.status.musicPath != null && !kIsWeb)
            Positioned(
              bottom: 100,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: tabColor,
                onPressed: isPlaying ? pauseMusic : playMusic,
                child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              ),
            ),
        ],
      ),
    );
  }
}