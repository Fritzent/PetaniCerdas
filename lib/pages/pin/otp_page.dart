import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petani_cerdas/bloc/auth_user_bloc.dart';
import 'package:petani_cerdas/resources/style_config.dart';
import '../../widgets/custome_otp_item_field.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = ModalRoute.of(context)!.settings.arguments as AuthUserBloc;

    return BlocProvider.value(
      value: authBloc,
      child: Scaffold(
        backgroundColor: ColorList.whiteColor,
        body: BlocConsumer<AuthUserBloc, AuthUserState>(
          listener: (context, state) {
            // dont forget to replace to main dashboard
            if (state.isAuthenticated && state.viewedPage == 'RegisterPage') {
              Navigator.pushReplacementNamed(context, '/create_pin');
            }
            else {
              Navigator.pushReplacementNamed(context, '/login_pin');
            }
          },
          builder: (context, state) {
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
                  child:
                      Image.asset('assets/images/login_top_palm_oil_image.png'),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(FontList.font24,
                              FontList.font64, FontList.font24, 0),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(39, 15, 0, 0),
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
                                  top: FontList.font16,
                                  left: FontList.font16,
                                  right: FontList.font16,
                                ),
                                child: Text(
                                  'Rasakan cara baru mengelola perkebunan yang lebih pintar dan terstruktur!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inriaSans(
                                      fontSize: FontList.font16,
                                      fontWeight: FontWeight.normal,
                                      color: ColorList.grayColor400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 55),
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: ColorList.whiteColor,
                                      border: Border.all(
                                        color: ColorList.whiteColor100,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(64, 0, 0, 0),
                                          spreadRadius: 0,
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: FontList.font16,
                                      ),
                                      child: Column(
                                        spacing: 4,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Gap(28),
                                          Center(
                                            child: Text(
                                              'Verifikasi OTP',
                                              style: GoogleFonts.inriaSans(
                                                  fontSize: FontList.font24,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorList.blackColor),
                                            ),
                                          ),
                                          Gap(12),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'Kode verifikasi sudah dikirim! ',
                                                    style:
                                                        GoogleFonts.inriaSans(
                                                      fontSize: FontList.font16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColorList
                                                          .grayColor400,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        'Masukkan kode Anda untuk melanjutkan',
                                                    style:
                                                        GoogleFonts.inriaSans(
                                                      fontSize: FontList.font16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ColorList
                                                          .grayColor400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Gap(12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            spacing: FontList.font16,
                                            children: controllers
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                              int index = entry.key;
                                              TextEditingController
                                                  controllerItem = entry.value;
                                              return SizedBox(
                                                width: FontList.font38,
                                                height: FontList.font80,
                                                child: CustomeOtpItemField(
                                                  index: index,
                                                  keypadType:
                                                      TextInputType.number,
                                                  controller: controllerItem,
                                                  focusNode: focusNodes[index],
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
                                                          .requestFocus(
                                                              focusNodes[
                                                                  index + 1]);
                                                    }
                                                  },
                                                  onBackspace: index > 0
                                                      ? () {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  focusNodes[
                                                                      index -
                                                                          1]);
                                                          controllers[index]
                                                              .clear();
                                                        }
                                                      : null,
                                                  onComplete: index ==
                                                          controllers.length - 1
                                                      ? () {
                                                          String otp =
                                                              controllers
                                                                  .map((c) =>
                                                                      c.text)
                                                                  .join();
                                                          authBloc.add(
                                                              OnVerifyOtp(otp));
                                                        }
                                                      : null,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'Butuh kode baru? Klik untuk \n',
                                                    style:
                                                        GoogleFonts.inriaSans(
                                                      fontSize: FontList.font16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: ColorList
                                                          .grayColor400,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: 'Coba Lagi',
                                                      style:
                                                          GoogleFonts.inriaSans(
                                                        fontSize:
                                                            FontList.font16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ColorList
                                                            .primaryColor,
                                                      ),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              //Dont forget to call the method resend otp
                                                              Navigator
                                                                  .pushReplacementNamed(
                                                                      context,
                                                                      '/pin');
                                                            }),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Gap(28)
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Gap(FontList.font46),
                        Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Image.asset(
                              'assets/images/login_bottom_tomatto_image.png'),
                        ),
                        Center(
                          child: Text(
                            'V.1.0.0',
                            style: GoogleFonts.inriaSans(
                                fontSize: FontList.font12,
                                fontWeight: FontWeight.bold,
                                color: ColorList.grayColor200),
                          ),
                        ),
                        Gap(FontList.font24),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
