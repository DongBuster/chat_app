import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IconButtonFooter extends StatefulWidget {
  final String icons;
  final String namePage;
  final Color color;
  final AnimationController controller;
  const IconButtonFooter({
    super.key,
    required this.icons,
    required this.namePage,
    required this.color,
    required this.controller,
  });

  @override
  State<IconButtonFooter> createState() => _IconButtonFooterState();
}

class _IconButtonFooterState extends State<IconButtonFooter> {
  // late AnimationController _controller;

  @override
  void initState() {
    if (widget.color == Colors.blue) {
      widget.controller.reset();
      widget.controller.forward();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            widget.color,
            BlendMode.srcATop,
          ),
          child: Lottie.asset(
            widget.icons,
            width: 22,
            height: 22,
            fit: BoxFit.fill,
            controller: widget.controller,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          widget.namePage,
          style: TextStyle(
            fontSize: 12,
            color: widget.color,
          ),
        )
      ],
    );
  }
}
