import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petani_cerdas/bloc/auth_user_bloc.dart';
import 'package:petani_cerdas/widgets/button_primary.dart';

import '../../bloc/custome_text_field_behavior_bloc.dart';
import '../../resources/style_config.dart';
import '../../widgets/custome_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNumber = '';
  String errorMessagePhone = '';

  sendOtpLogin(AuthUserBloc authUserBloc) {
    authUserBloc.add(OnSendOtp(phoneNumber, '', 'LoginPage'));
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CustomeTextFieldBehaviorBloc(),
        ),
        BlocProvider(
          create: (context) => AuthUserBloc(),
        ),
      ],
      child: BlocConsumer<AuthUserBloc, AuthUserState>(
        listener: (context, state) {
          if (state.verificationId.isNotEmpty) {
            Navigator.pushNamed(context, '/otp',
                arguments: BlocProvider.of<AuthUserBloc>(context));
          }
        },
        builder: (context, state) {
          final authUserBloc = context.read<AuthUserBloc>();
          return Scaffold(
            backgroundColor: ColorList.whiteColor,
            body: Stack(
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
                          padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
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
                                  top: 16,
                                  left: 16,
                                  right: 16,
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
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        spacing: 4,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Masuk',
                                            style: GoogleFonts.inriaSans(
                                                fontSize: FontList.font32,
                                                fontWeight: FontWeight.bold,
                                                color: ColorList.blackColor),
                                          ),
                                          Text(
                                            'Yuk, pastikan nomor telepon yang Anda masuk kan sudah benar, ya!',
                                            style: GoogleFonts.inriaSans(
                                                fontSize: FontList.font16,
                                                fontWeight: FontWeight.normal,
                                                color: ColorList.grayColor400),
                                          ),
                                          BlocBuilder<
                                              CustomeTextFieldBehaviorBloc,
                                              CustomeTextFieldBehaviorState>(
                                            builder: (context, state) {
                                              final textFieldBloc = context.read<
                                                  CustomeTextFieldBehaviorBloc>();
                                              return Form(
                                                key: formKey,
                                                child: Column(
                                                  children: [
                                                    CustomTextField(
                                                      textHint: 'Nomor telepon',
                                                      icon:
                                                          'assets/icons/ic_phone.svg',
                                                      keypadType:
                                                          TextInputType.phone,
                                                      onChanged: (value) {
                                                        phoneNumber = value;
                                                      },
                                                      isError: state
                                                              .errorMessagePhone
                                                              .isNotEmpty &&
                                                          state.isError,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          errorMessagePhone =
                                                              'nomor telepon pengguna kosong';
                                                          return errorMessagePhone;
                                                        }
                                                        errorMessagePhone = '';
                                                        return null;
                                                      },
                                                    ),
                                                    Gap(20),
                                                    ButtonPrimary(
                                                        onTap: () {
                                                          if (formKey
                                                              .currentState!
                                                              .validate()) {
                                                            // Form is valid, proceed
                                                            sendOtpLogin(
                                                                authUserBloc);
                                                          } else {
                                                            textFieldBloc.add(
                                                                OnCustomeTextFieldTextError(
                                                                    true,
                                                                    '',
                                                                    errorMessagePhone));
                                                          }
                                                        },
                                                        buttonText:
                                                            'Selanjutnya')
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 48,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Belum punya akun? ',
                                      style: GoogleFonts.inriaSans(
                                          fontSize: FontList.font16,
                                          fontWeight: FontWeight.normal,
                                          color: ColorList.blackColor),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/register');
                                      },
                                      child: Text(
                                        'Yuk, buat akun',
                                        style: GoogleFonts.inriaSans(
                                            fontSize: FontList.font16,
                                            fontWeight: FontWeight.normal,
                                            color: ColorList.primaryColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(46),
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
                        Gap(24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
