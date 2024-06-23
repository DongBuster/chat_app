import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        color: Colors.black26,
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'loading ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(Icons.circle, size: 8, color: Colors.blue)
                    .animate(
                        delay: 100.milliseconds,
                        onPlay: (controller) => controller.repeat())
                    .moveY(begin: 1, end: -1),
                const SizedBox(width: 2),
                const Icon(Icons.circle, size: 8, color: Colors.blue)
                    .animate(
                        delay: 200.milliseconds,
                        onPlay: (controller) => controller.repeat())
                    .moveY(begin: 2, end: -2),
                const SizedBox(width: 2),
                const Icon(Icons.circle, size: 8, color: Colors.blue)
                    .animate(
                        delay: 300.milliseconds,
                        onPlay: (controller) => controller.repeat())
                    .moveY(begin: 3, end: -3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
