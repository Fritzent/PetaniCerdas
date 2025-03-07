import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/bloc/general_custome_text_field_bloc.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import 'package:flutter_datetime_picker_plus/src/datetime_picker_theme.dart'
    as picker_theme;

class CustomeTextFieldWithTitleCalendar extends StatefulWidget {
  final String textHint;
  final String textTitle;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keypadType;
  final String? errorText;
  final bool isError;
  final String formSection;
  final bool isDateSection;
  final bool isDateHourSection;

  const CustomeTextFieldWithTitleCalendar({
    super.key,
    required this.textHint,
    required this.textTitle,
    required this.keypadType,
    this.onChanged,
    this.validator,
    this.errorText,
    this.isError = false,
    required this.formSection,
    this.isDateSection = false,
    this.isDateHourSection = false,
  });

  @override
  State<CustomeTextFieldWithTitleCalendar> createState() =>
      _CustomeTextFieldWithTitleStateCalendar();
}

class _CustomeTextFieldWithTitleStateCalendar
    extends State<CustomeTextFieldWithTitleCalendar> {
  bool isFocused = false;
  bool isEmpty = true;
  bool isListenerAdded = false;
  bool isFocusListenerAdded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GeneralCustomeTextFieldBloc(),
        child: BlocBuilder<GeneralCustomeTextFieldBloc,
            GeneralCustomeTextFieldState>(builder: (context, state) {
          var bloc = context.read<GeneralCustomeTextFieldBloc>();
          if (state.focusNode != null && !isFocusListenerAdded) {
            isFocusListenerAdded = true;
            state.focusNode?.addListener(() {
              bloc.add(OnFocusChange(state.focusNode!.hasFocus));
            });
          }

          if (state.controller != null &&
              !isListenerAdded &&
              state.focusNode!.hasFocus) {
            isListenerAdded = true;
            state.controller?.addListener(() {
              bloc.add(OnTextChange(
                  state.controller!.text.isEmpty, state.controller!.text));
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FontList.font8,
            children: [
              Text(
                widget.textTitle,
                style: TextStyle(
                  color: ColorList.blackColor,
                  fontSize: FontList.font20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              if (widget.isDateSection)
                GestureDetector(
                  onTap: () async {
                    if (widget.isDateSection) {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        helpText: 'Pilih tanggal transaksi',
                        cancelText: 'Tutup',
                        confirmText: 'Pilih',
                        fieldLabelText: 'Masukkan tanggal transaksi',
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                  primary: ColorList.primaryColor),
                              datePickerTheme: const DatePickerThemeData(
                                backgroundColor: ColorList.whiteColor,
                                dividerColor: ColorList.whiteColor,
                                headerBackgroundColor: ColorList.primaryColor,
                                headerForegroundColor: ColorList.whiteColor,
                                confirmButtonStyle: ButtonStyle(
                                  foregroundColor: WidgetStatePropertyAll(
                                      ColorList.primaryColor),
                                ),
                                cancelButtonStyle: ButtonStyle(
                                  foregroundColor: WidgetStatePropertyAll(
                                      ColorList.grayColor200),
                                ),
                                yearForegroundColor: WidgetStatePropertyAll(
                                    ColorList.blackColor),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat("dd-MM-yyyy").format(pickedDate);
                        if (widget.onChanged != null) {
                          widget.onChanged!(formattedDate);
                          bloc.add(OnUpdateField(formattedDate));
                        }
                      }
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      keyboardType: widget.keypadType,
                      focusNode: state.focusNode,
                      controller: state.controller,
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
                            fontWeight: FontWeight.normal),
                        errorStyle: TextStyle(
                            color: ColorList.redColor,
                            fontSize: FontList.font16,
                            fontWeight: FontWeight.normal),
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
                        errorText: state.errorMessage.isNotEmpty
                            ? state.errorMessage
                            : null,
                      ),
                    ),
                  ),
                ),
              if (widget.isDateHourSection)
                GestureDetector(
                  onTap: () async {
                    DatePicker.showTimePicker(context,
                        showSecondsColumn: false,
                        theme: picker_theme.DatePickerTheme(
                          doneStyle: TextStyle(color: ColorList.primaryColor, fontSize: FontList.font18),
                          cancelStyle: TextStyle(color: ColorList.grayColor200, fontSize: FontList.font18),
                          itemStyle: TextStyle(color: ColorList.blackColor, fontSize: FontList.font18),
                        ),
                        onConfirm: (time) {
                      String formattedDate = DateFormat('HH:mm').format(time);
                      if (widget.onChanged != null) {
                        widget.onChanged!(formattedDate);
                        bloc.add(OnUpdateField(formattedDate));
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      keyboardType: widget.keypadType,
                      focusNode: state.focusNode,
                      controller: state.controller,
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
                            fontWeight: FontWeight.normal),
                        errorStyle: TextStyle(
                            color: ColorList.redColor,
                            fontSize: FontList.font16,
                            fontWeight: FontWeight.normal),
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
                        errorText: state.errorMessage.isNotEmpty
                            ? state.errorMessage
                            : null,
                      ),
                    ),
                  ),
                ),
              if (!widget.isDateSection && !widget.isDateHourSection)
                GestureDetector(
                  onTap: () {
                    state.focusNode!.requestFocus();
                  },
                  child: TextFormField(
                    keyboardType: widget.keypadType,
                    focusNode: state.focusNode,
                    controller: state.controller,
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
                          fontWeight: FontWeight.normal),
                      errorStyle: TextStyle(
                          color: ColorList.redColor,
                          fontSize: FontList.font16,
                          fontWeight: FontWeight.normal),
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
                      errorText: state.errorMessage.isNotEmpty
                          ? state.errorMessage
                          : null,
                    ),
                  ),
                )
            ],
          );
        }));
  }
}
