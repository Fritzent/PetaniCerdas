import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/style_config.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({super.key, required this.onTap, required this.buttonText});
  final VoidCallback onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    

    return Material(
      borderRadius: BorderRadius.circular(8),
      color:  ColorList.primaryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: FontList.font48,
          child: Center(
            child: Text(
              buttonText,
              style: GoogleFonts.inriaSans(
                fontSize: FontList.font20,
                fontWeight: FontWeight.bold,
                color: ColorList.whiteColor
              ),
              textAlign: TextAlign.center,
            ),
          )
        ),
      ),
    );
  }
}