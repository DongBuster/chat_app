import 'package:flutter/widgets.dart';

class ImageUserDefault extends StatelessWidget {
  final double height;
  final double width;
  const ImageUserDefault({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/user_default.jpg',
      width: width,
      height: height,
    );
  }
}
