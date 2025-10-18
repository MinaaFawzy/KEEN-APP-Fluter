import 'package:flutter/material.dart';

class ViewButtonWidget extends StatelessWidget {
  const ViewButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('View Button Pressed');
      },
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.remove_red_eye_outlined,
          color: Colors.grey,
        ), // Eye icon
      ),
    );
  }
}