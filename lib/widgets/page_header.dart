import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/style_config.dart';

class PageHeader extends StatefulWidget {
  final bool hasLeftIcon;
  final bool hasRightIcon;
  final String pageTitle;
  final String? leftIcon;
  final String? rightIcon;
  final VoidCallback? leftIconOnTap;
  final VoidCallback? rightIconOnTap;

  const PageHeader(
      {super.key,
      required this.pageTitle,
      this.hasLeftIcon = false,
      this.hasRightIcon = false,
      this.leftIcon,
      this.rightIcon,
      this.leftIconOnTap,
      this.rightIconOnTap});

  @override
  State<PageHeader> createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: FontList.font16,
      children: [
        if (widget.hasLeftIcon && widget.leftIcon != null)
          GestureDetector(
            onTap: widget.leftIconOnTap,
            child: SvgPicture.asset(
              alignment: Alignment.topRight,
              widget.leftIcon ?? '',
              height: FontList.font24,
              width: FontList.font24,
            ),
          ),
        Expanded(
            child: Text(
          widget.pageTitle,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontList.font32,
              color: ColorList.blackColor),
        )),
        if (widget.hasRightIcon && widget.rightIcon != null)
          GestureDetector(
            onTap: widget.rightIconOnTap,
            child: SvgPicture.asset(
              alignment: Alignment.topRight,
              widget.rightIcon ?? '',
              height: FontList.font24,
              width: FontList.font24,
            ),
          ),
      ],
    );
  }
}
