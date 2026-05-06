import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MeditationSessionScreen extends StatefulWidget {
  final String category;
  final int durationMinutes;

  const MeditationSessionScreen({
    super.key,
    required this.category,
    required this.durationMinutes,
  });

  @override
  State<MeditationSessionScreen> createState() =>
      _MeditationSessionScreenState();
}

class _MeditationSessionScreenState
    extends State<MeditationSessionScreen>
    with SingleTickerProviderStateMixin {

  late int totalSeconds;
  Timer? timer;
  bool isRunning = true;

  late AnimationController _controller;

  int scriptIndex = 0;
  late List<String> meditationScript;

  final FlutterTts flutterTts = FlutterTts();

  // Different meditation scripts
  List<String> getMeditationScript(String category) {
    switch (category) {

      case "Sleep Meditation":
        return [
          "Lie down comfortably and gently close your eyes.",
          "Take a slow deep breath in... and softly breathe out.",
          "Let your body sink into the surface beneath you.",
          "Release the thoughts of today.",
          "You are safe. You are calm. Drift into peaceful sleep."
        ];

      case "Morning Gratitude":
        return [
          "Take a deep refreshing breath.",
          "Feel grateful for waking up today.",
          "Appreciate your body and your mind.",
          "Set a positive intention for today.",
          "Today is filled with new opportunities."
        ];

      case "Anxiety Relief":
        return [
          "Notice your thoughts without judging them.",
          "Take a slow breath in through your nose.",
          "Breathe out tension slowly.",
          "Your body is calming down.",
          "You are in control. You are safe."
        ];

      case "Body Scan":
        return [
          "Bring awareness to your toes.",
          "Relax your legs and knees.",
          "Release tension in your stomach and chest.",
          "Relax your shoulders and arms.",
          "Soften your face and forehead."
        ];

      case "Mindfulness Practice":
        return [
          "Become aware of your surroundings.",
          "Notice the natural rhythm of your breath.",
          "Observe thoughts like passing clouds.",
          "Stay present in this moment.",
          "You are here. You are aware."
        ];

      default:
        return [
          "Close your eyes gently.",
          "Take a slow breath.",
          "Relax your body."
        ];
    }
  }

  @override
  void initState() {
    super.initState();

    meditationScript = getMeditationScript(widget.category);
    totalSeconds = widget.durationMinutes * 60;

    _initTts();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0.85,
      upperBound: 1.15,
    )..repeat(reverse: true);

    _startTimer();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.38); // smoother
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);

    await flutterTts.awaitSpeakCompletion(true);

    await _speakCurrentScript();
  }

  Future<void> _speakCurrentScript() async {
    if (isRunning) {
      //await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.stop();
      await flutterTts.speak(meditationScript[scriptIndex]);
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (totalSeconds > 0 && isRunning) {
        setState(() => totalSeconds--);

        // Change meditation line every 8 seconds
        if (totalSeconds % 8 == 0) {

          scriptIndex =
              (scriptIndex + 1) % meditationScript.length;

          setState(() {});

          await flutterTts.stop();
          await flutterTts.speak(meditationScript[scriptIndex]);
        }

      } else if (totalSeconds == 0) {
        t.cancel();
        await flutterTts.stop();
        _showCompletionDialog();
      }
    });
  }

  Future<void> _saveSession(String feeling) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history =
        prefs.getStringList("meditation_history") ?? [];

    history.add(
        "${widget.category} - ${widget.durationMinutes} min - $feeling - ${DateTime.now()}");

    await prefs.setStringList("meditation_history", history);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("✨ Session Complete"),
        content: const Text("How do you feel now?"),
        actions: [
          _feelingButton("😊 Calm"),
          _feelingButton("😌 Relaxed"),
          _feelingButton("😐 Neutral"),
          _feelingButton("😔 Still Anxious"),
        ],
      ),
    );
  }

  Widget _feelingButton(String feeling) {
    return TextButton(
      onPressed: () async {
        await _saveSession(feeling);
        if (mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      child: Text(feeling),
    );
  }

  String get timeFormatted {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    flutterTts.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A1A40),
              Color(0xFF0F2027),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [

              Positioned(
                top: 20,
                right: 20,
                child: Text(
                  timeFormatted,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      widget.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 40),

                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.scale(
                          scale: _controller.value,
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.deepPurpleAccent.withOpacity(0.8),
                                  Colors.deepPurple.shade900,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        meditationScript[scriptIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      onPressed: () async {
                        setState(() => isRunning = !isRunning);

                        if (isRunning) {
                          await _speakCurrentScript();
                        } else {
                          await flutterTts.stop();
                        }
                      },
                      child: Text(isRunning ? "Pause" : "Resume"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}