import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  final Function func;
  final IconData icon;
  const ButtonIcon({super.key, required this.func, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: IconButton(
          onPressed: () => func(),
          icon: Icon(
            icon,
            size: 22,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
