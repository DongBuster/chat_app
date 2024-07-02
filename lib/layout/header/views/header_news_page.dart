import 'package:flutter/material.dart';

class HeaderNewsPage extends StatelessWidget {
  const HeaderNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tin',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
