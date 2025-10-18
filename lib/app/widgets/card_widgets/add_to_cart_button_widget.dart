import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity, // Button takes full width
      child: TextButton(
        onPressed: () {
          print('Quick Add Button Pressed');
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
        ),
        child:  Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}