import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petani_cerdas/bloc/add_calendar_bloc.dart';
import 'package:petani_cerdas/resources/style_config.dart';

class CustomeTextFieldWithTitleCalendar extends StatefulWidget {
  final String textHint;
  final String textTitle;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keypadType;
  final String? errorText;
  final bool isError;
  final String formSection;
  final AddCalendarBloc textFieldBloc;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDateSection;

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
    required this.textFieldBloc,
    required this.controller,
    required this.focusNode,
    this.isDateSection = false,
  });

  @override
  State<CustomeTextFieldWithTitleCalendar> createState() =>
      _CustomeTextFieldWithTitleStateCalendar();
}

class _CustomeTextFieldWithTitleStateCalendar extends State<CustomeTextFieldWithTitleCalendar> {
  bool isFocused = false;
  bool isEmpty = true;

  @override
  void dispose() {
    widget.focusNode.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCalendarBloc, AddCalendarState>(
        bloc: widget.textFieldBloc,
        builder: (context, state) {
          if (state.focusNode != null) {
            state.focusNode?.addListener(() {
              // widget.textFieldBloc
              //     .add(OnFocusChange(state.focusNode!.hasFocus));
            });
          }

          state.controller.addListener(() {
            // widget.textFieldBloc
            //     .add(OnTextChange(state.controller.text.isEmpty));
          });

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

                      String formattedDate =
                          DateFormat("yyyy-MM-dd").format(pickedDate!);
                      if (widget.onChanged != null) {
                        widget.onChanged!(formattedDate);
                      }
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      keyboardType: widget.keypadType,
                      controller: state.controller,
                      focusNode: state.focusNode,
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
                        errorText:
                            state.errorText.isNotEmpty ? state.errorText : null,
                      ),
                    ),
                  ),
                ),
              if (!widget.isDateSection)
                GestureDetector(
                  onTap: () {},
                  child: TextFormField(
                    keyboardType: widget.keypadType,
                    controller: state.controller,
                    focusNode: state.focusNode,
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
                      errorText:
                          state.errorText.isNotEmpty ? state.errorText : null,
                    ),
                  ),
                )
            ],
          );
        });
  }
}
