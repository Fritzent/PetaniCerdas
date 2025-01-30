import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/custome_text_field_behavior_bloc.dart';
import '../resources/style_config.dart';

class CustomeOtpItemField extends StatefulWidget {
  final TextInputType keypadType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onBackspace;
  final VoidCallback? onComplete;
  final int index;

  const CustomeOtpItemField({
    required this.keypadType,
    this.onChanged,
    this.validator,
    this.textInputAction = TextInputAction.next,
    required this.controller,
    required this.focusNode,
    this.onBackspace,
    this.onComplete,
    required this.index,
    super.key,
  });

  @override
  State<CustomeOtpItemField> createState() => _CustomeOtpItemFieldState();
}

class _CustomeOtpItemFieldState extends State<CustomeOtpItemField> {
  bool isFocused = false;

  @override
  void dispose() {
    widget.focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode.onKeyEvent = (node, event) {
      debugPrint("Key pressed: ${event.logicalKey}");
      if (event.logicalKey == LogicalKeyboardKey.backspace &&
          event is KeyDownEvent &&
          widget.controller.text.isEmpty &&
          widget.index > 0) {
        widget.onBackspace?.call();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomeTextFieldBehaviorBloc(),
      child: BlocBuilder<CustomeTextFieldBehaviorBloc,
          CustomeTextFieldBehaviorState>(
        builder: (context, state) {
          final textFieldBloc = context.read<CustomeTextFieldBehaviorBloc>();

          widget.focusNode.addListener(() {
            textFieldBloc
                .add(OnCustomeTextFieldFocusChange(widget.focusNode.hasFocus));
          });

          widget.controller.addListener(() {
            textFieldBloc.add(
                OnCustomeTextFieldTextChange(widget.controller.text.isEmpty));
          });

          return TextFormField(
            maxLength: 1,
            keyboardType: widget.keypadType,
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }

              if (value.isNotEmpty &&
                  widget.index == 5 &&
                  widget.textInputAction == TextInputAction.done) {
                widget.onComplete?.call();
              }
            },
            validator: widget.validator,
            textAlign: TextAlign.center,
            buildCounter: (context,
                {required int currentLength,
                required bool isFocused,
                required int? maxLength}) {
              return null;
            },
            style: TextStyle(
              color: ColorList.blackColor,
              fontSize: FontList.font24,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorList.whiteColor,
              errorStyle: TextStyle(
                  color: ColorList.redColor,
                  fontSize: FontList.font24,
                  fontWeight: FontWeight.bold),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(FontList.font16),
                borderSide: BorderSide(
                  color: state.isFocused
                      ? ColorList.primaryColor
                      : ColorList.grayColor100,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(FontList.font16),
                borderSide: BorderSide(
                  color: ColorList.primaryColor,
                  width: 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(FontList.font16),
                borderSide: BorderSide(
                  color: ColorList.redColor,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(FontList.font16),
                borderSide: BorderSide(
                  color: ColorList.redColor,
                  width: 1.0,
                ),
              ),
            ),
            onFieldSubmitted: (_) {
              debugPrint(
                  'Field submitted with action: ${widget.textInputAction}');
              if (widget.textInputAction == TextInputAction.next) {
                FocusScope.of(context).nextFocus();
              } else if (widget.textInputAction == TextInputAction.done) {
                FocusScope.of(context).unfocus();
              }
            },
          );
        },
      ),
    );
  }
}
