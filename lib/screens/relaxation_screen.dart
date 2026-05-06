import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RelaxationScreen extends StatefulWidget {
  final String type; // breathing, music, meditation

  const RelaxationScreen({super.key, required this.type});

  @override
  State<RelaxationScreen> createState() => _RelaxationScreenState();
}

class _RelaxationScreenState extends State<RelaxationScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isPlaying = false;
  int currentTrackIndex = -1;

  /// 🎵 Music Tracks
  final List<Map<String, String>> musicTracks = [
    {
      "title": "Just Relax",
      "duration": "2:45",
      "path": "audio/music_for_video_just_relax-1157.mp3",
    },
    {
      "title": "Nastelbom Relax",
      "duration": "3:10",
      "path": "audio/nastelbom-relax-463106.mp3",
    },
    {
      "title": "Pretty John Relax",
      "duration": "2:58",
      "path": "audio/prettyjohn1-relax-495674.mp3",
    },
    {
      "title": "Quiet Phase",
      "duration": "4:05",
      "path": "audio/quietphase-instrumental-relax-496352.mp3",
    },
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0.7,
      upperBound: 1.2,
    )..repeat(reverse: true);
  }

  /// 🎵 Play Selected Track
  Future<void> _playSelectedTrack() async {
    await _audioPlayer.stop();

    await _audioPlayer.play(
      AssetSource(musicTracks[currentTrackIndex]["path"]!),
    );

    setState(() {
      isPlaying = true;
    });
  }

  /// ⏹ Stop Audio
  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  /// ⏭ Next Track
  Future<void> _playNext() async {
    if (currentTrackIndex < musicTracks.length - 1) {
      currentTrackIndex++;
      _playSelectedTrack();
    }
  }

  /// ⏮ Previous Track
  Future<void> _playPrevious() async {
    if (currentTrackIndex > 0) {
      currentTrackIndex--;
      _playSelectedTrack();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// 🌬 Breathing UI
    if (widget.type == "breathing") {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Guided Breathing"),
          backgroundColor: const Color(0xFF6C63FF),
        ),
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _controller.value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6C63FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "Breathe",
                      style: TextStyle(
                          color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    /// 🎵 Calm Music UI
    if (widget.type == "music") {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Calm Music"),
          backgroundColor: const Color(0xFF6C63FF),
        ),
        body: Column(
          children: [

            /// Track List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: musicTracks.length,
                itemBuilder: (context, index) {

                  final track = musicTracks[index];

                  return Card(
                    color: currentTrackIndex == index
                        ? const Color(0xFFEDE7F6)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      leading: const Icon(
                        Icons.music_note,
                        color: Color(0xFF6C63FF),
                      ),
                      title: Text(
                        track["title"]!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          "Duration: ${track["duration"]}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {
                          currentTrackIndex = index;
                          _playSelectedTrack();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Bottom Mini Player
            if (currentTrackIndex != -1)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xFF6C63FF),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      musicTracks[currentTrackIndex]["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [

                        /// Previous
                        IconButton(
                          icon: const Icon(Icons.skip_previous,
                              color: Colors.white),
                          onPressed: _playPrevious,
                        ),

                        /// Play / Pause
                        IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (isPlaying) {
                              _stopAudio();
                            } else {
                              _playSelectedTrack();
                            }
                          },
                        ),

                        /// Next
                        IconButton(
                          icon: const Icon(Icons.skip_next,
                              color: Colors.white),
                          onPressed: _playNext,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    /// 🧘 Meditation UI (Simple version)
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meditation Session"),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: const Center(
        child: Text(
          "Meditation content coming soon ",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}