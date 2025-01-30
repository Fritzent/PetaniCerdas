import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../resources/style_config.dart';

class DropDownSort extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?)? onChanged;

  const DropDownSort({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  State<DropDownSort> createState() => _DropDownSortState();
}

class _DropDownSortState extends State<DropDownSort> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: FontList.font16, vertical: FontList.font8),
      decoration: BoxDecoration(
        border: Border.all(color: ColorList.whiteColor100, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<String>(
        value: widget.value,
        isExpanded: true,
        icon: SvgPicture.asset(
          'assets/icons/ic_down.svg',
          width: 24,
          height: 24,
        ),
        hint: Text(
          widget.hintText,
          style: TextStyle(
              color: ColorList.grayColor200, fontSize: FontList.font16),
        ),
        style:
            TextStyle(color: ColorList.blackColor, fontSize: FontList.font16),
        dropdownColor: ColorList.whiteColor,
        underline: SizedBox(),
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: widget.onChanged,
      ),
    );
  }
}
