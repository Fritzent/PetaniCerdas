import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petani_cerdas/bloc/pin_input_behavior_bloc.dart';

import '../bloc/custome_text_field_behavior_bloc.dart';
import '../resources/style_config.dart';

class CustomePinItemField extends StatefulWidget {
  final TextInputType keypadType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onBackspace;
  final int index;
  final obscureText;
  final int value;
  final bool isError;

  const CustomePinItemField({
    super.key,
    required this.keypadType,
    this.onChanged,
    this.validator,
    this.textInputAction = TextInputAction.next,
    required this.controller,
    required this.focusNode,
    this.onBackspace,
    required this.index,
    this.obscureText,
    this.value = 0,
    this.isError = false,
  });

  @override
  State<CustomePinItemField> createState() => _CustomePinItemFieldState();
}

class _CustomePinItemFieldState extends State<CustomePinItemField> {
  bool isFocused = false;

  @override
  void dispose() {
    widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CustomeTextFieldBehaviorBloc>(
          create: (context) => CustomeTextFieldBehaviorBloc(
            pinInputBehaviorBloc:
                BlocProvider.of<PinInputBehaviorBloc>(context),
            index: widget.index,
          ),
        ),
      ],
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
            canRequestFocus: false,
            readOnly: true,
            keyboardType: widget.keypadType,
            controller: widget.controller,
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            validator: widget.validator,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            obscureText: widget.obscureText,
            obscuringCharacter: '*',
            buildCounter: (context,
                {required int currentLength,
                required bool isFocused,
                required int? maxLength}) {
              return null;
            },
            style: TextStyle(
              color: widget.isError ? ColorList.redColor: ColorList.primaryColor,
              fontSize: FontList.font24,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorList.whiteColor,
              contentPadding: EdgeInsets.symmetric(
                  vertical: FontList.font16, horizontal: FontList.font16),
              errorStyle: TextStyle(
                  height: 0,),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(FontList.font16),
                borderSide: BorderSide(
                  color: state.isFocused
                      ? ColorList.primaryColor
                      : ColorList.grayColor100,
                  width: 1.0,
                ),
              ),
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
              errorText: widget.isError ? '' : null,
            ),
            onFieldSubmitted: (_) {
              debugPrint(
                  'Field submitted with action: //${widget.textInputAction}');
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
