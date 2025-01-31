import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petani_cerdas/resources/style_config.dart';

class ToastService {
  static final GlobalKey<_CustomToastState> _toastKey = GlobalKey<_CustomToastState>();

  static showToast(BuildContext context, String msg, bool isError) {
    _toastKey.currentState?.showToast(msg, isError);
  }

  static Widget buildToast() {
    return CustomToast(key: _toastKey);
  }
}

class CustomToast extends StatefulWidget {
  const CustomToast({super.key});

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> {
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  void showToast(String msg, bool isError) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(
          horizontal: FontList.font16, vertical: FontList.font12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(FontList.font8),
        color: ColorList.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(64, 0, 0, 0),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            alignment: Alignment.topRight,
            isError ? 'assets/icons/ic_exits.svg' : 'assets/icons/ic_check.svg',
            height: FontList.font14,
            width: FontList.font14,
            colorFilter: ColorFilter.mode(
                isError ? ColorList.redColor100 : ColorList.primaryColor,
                BlendMode.srcIn),
          ),
          SizedBox(
            width: FontList.font14,
          ),
          Text(
            msg,
            style: TextStyle(
                fontSize: FontList.font14,
                fontWeight: FontWeight.bold,
                color:
                    isError ? ColorList.redColor100 : ColorList.primaryColor),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Invisible widget but it manages the toast
  }
}