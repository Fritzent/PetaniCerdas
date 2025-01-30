import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import 'package:petani_cerdas/bloc/custome_text_field_behavior_bloc.dart';

class CustomTextField extends StatefulWidget {
  final String textHint;
  final String icon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keypadType;
  final String? errorText;
  final bool isError;

  const CustomTextField({
    super.key,
    required this.textHint,
    required this.icon,
    required this.keypadType,
    this.onChanged,
    this.validator,
    this.errorText,
    this.isError = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  bool isFocused = false;
  bool isEmpty = true;

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomeTextFieldBehaviorBloc(),
      child: BlocBuilder<CustomeTextFieldBehaviorBloc,
          CustomeTextFieldBehaviorState>(
        builder: (context, state) {
          final textFieldBloc = context.read<CustomeTextFieldBehaviorBloc>();

          focusNode.addListener(() {
            textFieldBloc
                .add(OnCustomeTextFieldFocusChange(focusNode.hasFocus));
          });

          controller.addListener(() {
            textFieldBloc
                .add(OnCustomeTextFieldTextChange(controller.text.isEmpty));
          });

          return GestureDetector(
            child: TextFormField(
              keyboardType: widget.keypadType,
              controller: controller,
              focusNode: focusNode,
              onChanged: widget.onChanged,
              validator: widget.validator,
              style: TextStyle(
                  color: ColorList.blackColor,
                  fontSize: FontList.font18,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: widget.textHint,
                hintStyle: TextStyle(
                    color: ColorList.grayColor200,
                    fontSize: FontList.font18,
                    fontWeight: FontWeight.bold),
                errorStyle: TextStyle(
                    color: ColorList.redColor,
                    fontSize: FontList.font16,
                    fontWeight: FontWeight.normal),
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                  child: SvgPicture.asset(
                    widget.icon,
                    colorFilter: ColorFilter.mode(
                        state.isFocused
                            ? ColorList.primaryColor
                            : widget.isError
                                ? ColorList.redColor
                                : state.isEmpty
                                    ? ColorList.grayColor300
                                    : ColorList.primaryColor,
                        BlendMode.srcIn),
                  ),
                ),
                filled: true,
                fillColor: ColorList.whiteColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FontList.font8),
                  borderSide: BorderSide(
                    color: state.isFocused
                        ? ColorList.primaryColor
                        : ColorList.grayColor100,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FontList.font8),
                  borderSide: BorderSide(
                    color: ColorList.primaryColor,
                    width: 1.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FontList.font8),
                  borderSide: BorderSide(
                    color: ColorList.redColor,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FontList.font8),
                  borderSide: BorderSide(
                    color: ColorList.redColor,
                    width: 1.0,
                  ),
                ),
                errorText: widget.isError ? widget.errorText : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
