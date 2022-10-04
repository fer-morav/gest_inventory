import 'package:flutter/material.dart';

class ImageComponent extends StatelessWidget {
  final Color color;
  final String photoURL;
  final double size;

  const ImageComponent({
    Key? key,
    required this.color,
    required this.photoURL,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundColor: color,
        radius: size,
        child: CircleAvatar(
          radius: size * 0.925,
          backgroundImage: NetworkImage(photoURL),
        ),
      ),
    );
  }
}
