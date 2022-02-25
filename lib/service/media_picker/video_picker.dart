import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class VideoPicker extends StatelessWidget {
  VideoPicker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: DottedBorder(
        dashPattern: const [10, 10],
        color: Colors.grey,
        radius: const Radius.circular(20),
        borderType: BorderType.RRect,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          height: 130,
          width: 100,
          child: const Center(
            child: 
            Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
