import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/providers/product_details/product_details_provider.dart';

class ScreensTopBarWidget extends ConsumerWidget {
  const ScreensTopBarWidget({super.key, required this.title, required this.space});

  final String title;
  final double space;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),

      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
               Navigator.pop(context);
              },
              icon: Icon(CupertinoIcons.back, size: 26, color: Colors.black),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * space),
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
