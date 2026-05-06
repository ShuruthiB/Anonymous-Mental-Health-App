import 'dart:async';
import 'package:flutter/material.dart';

class BreathingSessionScreen extends StatefulWidget {
  final int inhale;
  final int hold;
  final int exhale;

  const BreathingSessionScreen({
    super.key,
    required this.inhale,
    required this.hold,
    required this.exhale,
  });

  @override
  State<BreathingSessionScreen> createState() =>
      _BreathingSessionScreenState();
}

class _BreathingSessionScreenState extends State<BreathingSessionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String phase = "Inhale";
  bool isNightMode = false;

  int selectedMinutes = 1;
  int totalSeconds = 60;
  int remainingSeconds = 60;

  Timer? countdownTimer;

  List<String> sessionHistory = [];

  @override
  void initState() {
    super.initState();

    totalSeconds = selectedMinutes * 60;
    remainingSeconds = totalSeconds;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.inhale + widget.hold + widget.exhale,
      ),
    )..addListener(() {
      double value = _controller.value;

      double total =
      (widget.inhale + widget.hold + widget.exhale).toDouble();

      double inhaleEnd =
          widget.inhale.toDouble() / total;

      double holdEnd =
          (widget.inhale + widget.hold).toDouble() / total;

      setState(() {
        if (value < inhaleEnd) {
          phase = "Inhale";
        } else if (value < holdEnd) {
          phase = "Hold";
        } else {
          phase = "Exhale";
        }
      });
    });

    _startBreathing();
  }

  void _startBreathing() {
    _controller.repeat();
    _startTimer();
  }

  void _startTimer() {
    countdownTimer?.cancel();

    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
          if (remainingSeconds > 0) {
            setState(() {
              remainingSeconds--;
            });
          } else {
            timer.cancel();
            _controller.stop();
            _saveSession();
          }
        });
  }

  void _saveSession() {
    setState(() {
      sessionHistory.add(
          "${DateTime.now().hour}:${DateTime.now().minute} - ${selectedMinutes} min session");
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Session Completed 💜")),
    );
  }

  void _changeDuration(int minutes) {
    setState(() {
      selectedMinutes = minutes;
      totalSeconds = minutes * 60;
      remainingSeconds = totalSeconds;
    });
    _startBreathing();
  }

  @override
  void dispose() {
    _controller.dispose();
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color background = isNightMode ? Colors.black : const Color(0xFF6C63FF);
    Color textColor = isNightMode ? Colors.white : Colors.white;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Breathing Session"),
        backgroundColor: background,
        actions: [
          IconButton(
            icon: Icon(
              isNightMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              setState(() {
                isNightMode = !isNightMode;
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// Duration Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _durationButton(1),
                _durationButton(3),
                _durationButton(5),
              ],
            ),

            const SizedBox(height: 40),

            /// CENTERED Breathing Circle
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double scale = 1 +
                        (_controller.value *
                            0.5);

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isNightMode
                              ? Colors.deepPurple
                              : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            phase,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isNightMode
                                  ? Colors.white
                                  : const Color(0xFF6C63FF),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// Timer Display
            Text(
              "${(remainingSeconds ~/ 60)}:${(remainingSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: 22,
                color: textColor,
              ),
            ),

            const SizedBox(height: 20),

            /// Session History
            if (sessionHistory.isNotEmpty)
              Container(
                height: 100,
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: sessionHistory.length,
                  itemBuilder: (context, index) {
                    return Text(
                      sessionHistory[index],
                      style: TextStyle(color: textColor),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _durationButton(int minutes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () => _changeDuration(minutes),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedMinutes == minutes
              ? Colors.deepPurple
              : Colors.white,
        ),
        child: Text(
          "$minutes min",
          style: TextStyle(
            color: selectedMinutes == minutes
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}