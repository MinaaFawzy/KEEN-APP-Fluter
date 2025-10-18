import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/menu_drawer.dart';
import 'package:keen_official_app/data/thems/app_colors.dart';

class MenuItemWidget extends ConsumerWidget {
  const MenuItemWidget({
    super.key,
    required this.scrollController,
    required this.fontSize,
    required this.title,
    this.enableRightIcon = false,
    required this.fontWeight,
    required this.screenTitle
  });

  final ScrollController scrollController;
  final double fontSize;
  final String title;
  final bool enableRightIcon;
  final FontWeight fontWeight;
  final String screenTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          title: Text(title,style: TextStyle(fontSize: fontSize, fontWeight: fontWeight)),
          onTap: () {
            pressMenuTitle(
              title: screenTitle,
              scrollController: scrollController,
              ref: ref,
              context: context,
            );
          },
          trailing: enableRightIcon? Icon(Icons.arrow_forward_ios, size: 16,) : null,
        ),
        Divider(color: AppColors.dividerColor),
      ],
    );
  }
}