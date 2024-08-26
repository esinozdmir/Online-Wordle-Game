import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final Function onCompleted;

  const CountdownTimer({Key? key, required this.duration, required this.onCompleted}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onCompleted();
        }
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            CircularProgressIndicator(
              value: _animation.value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 8.0, // İlerleme çubuğunun kalınlığı
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            Text(
              _formatDuration(Duration(seconds: (_animation.value * widget.duration.inSeconds).round())),
              style: TextStyle(fontSize: 20),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
