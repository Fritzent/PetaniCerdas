import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/pin_input_behavior_bloc.dart';
import '../../resources/keypad_item.dart';
import '../../resources/style_config.dart';
import '../../widgets/custome_pin_item_field.dart';

class LoginPinPage extends StatefulWidget {
  const LoginPinPage({super.key});

  @override
  State<LoginPinPage> createState() => _LoginPinPageState();
}

class _LoginPinPageState extends State<LoginPinPage> {
  final List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  final item = keypadItems;
  int currentField = 0;
  String initMessage = 'Masukkan PIN Anda sekarang';

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinInputBehaviorBloc(4),
      child: Scaffold(
        backgroundColor: ColorList.whiteColor,
        body: BlocConsumer<PinInputBehaviorBloc, PinInputBehaviorState>(
          listener: (context, state) {
            if (state.progress == 'LoginSuccess') {
              //Dont Forget To Handle BackAction
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          },
          builder: (context, state) {
            return BlocBuilder<PinInputBehaviorBloc, PinInputBehaviorState>(
              builder: (context, state) {
                final bloc = context.read<PinInputBehaviorBloc>();
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      left: -110,
                      child: Transform.flip(
                        flipX: true,
                        child: Image.asset(
                            height: 240,
                            fit: BoxFit.fitHeight,
                            'assets/images/login_top_palm_oil_image.png'),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset(
                          'assets/images/login_top_palm_oil_image.png'),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  FontList.font24,
                                  FontList.font64,
                                  FontList.font24,
                                  0),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Text(
                                        'PeTani',
                                        style: GoogleFonts.inriaSans(
                                            fontSize: FontList.font24,
                                            fontWeight: FontWeight.bold,
                                            color: ColorList.blackColor),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            39, 15, 0, 0),
                                        child: Text(
                                          'Cerdas',
                                          style: GoogleFonts.inriaSans(
                                              fontSize: FontList.font64,
                                              fontWeight: FontWeight.bold,
                                              color: ColorList.blackColor),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: FontList.font28,
                                      left: FontList.font16,
                                      right: FontList.font16,
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          if (state.errorMessage != null &&
                                              state.errorMessage ==
                                                  "⚠️ PIN yang Anda masukkan tidak tepat. Coba lagi, ya!")
                                            TextSpan(
                                              text:
                                                  "⚠️ PIN yang Anda masukkan tidak tepat",
                                              style: GoogleFonts.inriaSans(
                                                  fontSize: FontList.font16,
                                                  fontWeight: FontWeight.bold,
                                                  color: state.errorMessage !=
                                                              null &&
                                                          state.errorMessage!
                                                              .isNotEmpty
                                                      ? ColorList.redColor
                                                      : ColorList.grayColor400),
                                            ),
                                          if (state.errorMessage != null &&
                                              state.errorMessage ==
                                                  "⚠️ PIN yang Anda masukkan tidak tepat. Coba lagi, ya!")
                                            TextSpan(
                                              text: " . Coba lagi, ya!",
                                              style: GoogleFonts.inriaSans(
                                                  fontSize: FontList.font16,
                                                  fontWeight: FontWeight.normal,
                                                  color:
                                                      ColorList.grayColor400),
                                            ),
                                          if (state.errorMessage != null &&
                                              state.errorMessage !=
                                                  "⚠️ PIN yang Anda masukkan tidak tepat. Coba lagi, ya!")
                                            TextSpan(
                                              text: state.errorMessage,
                                              style: GoogleFonts.inriaSans(
                                                  fontSize: FontList.font16,
                                                  fontWeight: FontWeight.normal,
                                                  color: ColorList.redColor),
                                            ),
                                          if (state.errorMessage == null ||
                                              state.errorMessage!.isEmpty)
                                            TextSpan(
                                              text: initMessage,
                                              style: GoogleFonts.inriaSans(
                                                  fontSize: FontList.font16,
                                                  fontWeight: FontWeight.normal,
                                                  color:
                                                      ColorList.grayColor400),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: FontList.font38),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        spacing: FontList.font16,
                                        children: controllers
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          TextEditingController controllerItem =
                                              entry.value;
                                          return SizedBox(
                                            width: FontList.font50,
                                            child: CustomePinItemField(
                                              index: index,
                                              value: 0,
                                              keypadType: TextInputType.number,
                                              controller: controllerItem
                                                ..text = state.pinValues[index],
                                              focusNode: focusNodes[index],
                                              obscureText: true,
                                              isError:
                                                  state.errorMessage != null &&
                                                          state.errorMessage!
                                                              .isNotEmpty
                                                      ? true
                                                      : false,
                                              textInputAction: index ==
                                                      controllers.length - 1
                                                  ? TextInputAction.done
                                                  : TextInputAction.next,
                                              onChanged: (value) {
                                                if (value.isNotEmpty &&
                                                    index <
                                                        controllers.length -
                                                            1) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focusNodes[
                                                          index + 1]);
                                                }
                                              },
                                              onBackspace: index > 0
                                                  ? () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              focusNodes[
                                                                  index - 1]);
                                                      controllers[index]
                                                          .clear();
                                                    }
                                                  : null,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  Gap(26),
                                  Center(
                                    child: SizedBox(
                                      height: 392,
                                      child: GridView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: FontList.font64),
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: FontList.font24,
                                          mainAxisSpacing: FontList.font24,
                                          childAspectRatio: 0.8,
                                        ),
                                        itemCount: keypadItems.length,
                                        itemBuilder: (context, index) {
                                          final item = keypadItems[index];
                                          if (item == '') {
                                            return SizedBox.shrink();
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              switch (index) {
                                                case 11:
                                                  bloc.add(
                                                      OnPinInputRemoveBehavior());
                                                  break;
                                                case 9:
                                                  break;
                                                default:
                                                  bloc.add(
                                                      OnPinInputAddBehavior(
                                                          item));
                                                  if (state.currentIndex == 3) {
                                                    bloc.add(OnPinInputSaved(
                                                        'LoginPin'));
                                                  }
                                                  break;
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorList.whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        FontList.font12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                        64, 0, 0, 0),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item,
                                                  style: GoogleFonts.inriaSans(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorList.blackColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: Image.asset(
                                  'assets/images/login_bottom_tomatto_image.png'),
                            ),
                            Gap(FontList.font20),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
