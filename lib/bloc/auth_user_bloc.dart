import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petani_cerdas/models/users.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthUserBloc() : super(AuthUserState()) {
    on<OnSendOtp>(OnOtpSend);
    on<OnVerifyOtp>(OnOtpVerify);
    on<OtpVerified>(OnOtpVerified);
    on<VerificationFailed>(OnVerificationFailed);
    on<CodeSent>(OnCodeSent);
    on<OnGetUserName>(getUserName);
  }

  Future<void> OnOtpSend(OnSendOtp event, Emitter<AuthUserState> emit) async {
    emit(state.copyWith(
        isLoading: true,
        userName: event.userName,
        viewedPage: event.viewedPage));
    try {
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
      );
      final formattedPhoneNumber = formatPhoneNumber(event.phoneNumber, '+62');
      if (isValidPhoneNumber(formattedPhoneNumber)) {
        await auth.verifyPhoneNumber(
          timeout: const Duration(seconds: 40),
          phoneNumber: formattedPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            add(OtpVerified(credential));
          },
          verificationFailed: (FirebaseAuthException e) {
            add(VerificationFailed(e.message));
          },
          codeSent: (String verificationId, int? resendToken) {
            add(CodeSent(verificationId));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(),
          isLoading: false,
          userName: '',
          viewedPage: ''));
    }
  }

  String formatPhoneNumber(String phoneNumber, String countryCode) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = countryCode + phoneNumber;
    }
    return phoneNumber;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    return regex.hasMatch(phoneNumber);
  }

  Future<void> OnOtpVerified(
      OtpVerified event, Emitter<AuthUserState> emit) async {
    try {
      await auth.signInWithCredential(event.credential);
      emit(state.copyWith(isAuthenticated: true, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  void OnVerificationFailed(
      VerificationFailed event, Emitter<AuthUserState> emit) {
    emit(state.copyWith(errorMessage: event.message, isLoading: false));
  }

  void OnCodeSent(CodeSent event, Emitter<AuthUserState> emit) {
    emit(
        state.copyWith(verificationId: event.verificationId, isLoading: false));
  }

  Future<void> OnOtpVerify(
      OnVerifyOtp event, Emitter<AuthUserState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId,
        smsCode: event.otp,
      );

      await auth.signInWithCredential(credential);
      final user = auth.currentUser;
      if (user != null) {
        if (state.viewedPage == 'RegisterPage') {
          await SaveUserDataToFirestore(user);
        }
        await SavedUserDataToStorage(user.uid);
      }

      emit(state.copyWith(isAuthenticated: true, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> SaveUserDataToFirestore(User user) async {
    try {
      final userCollection = FirebaseFirestore.instance.collection('Users');
      await userCollection.doc(user.uid).set({
        'user_id': user.uid,
        'phone_number': user.phoneNumber,
        'user_pin': '',
        'username': state.userName,
      });
    } catch (e) {
      print('Failed to save user data to Firestore: ${e.toString()}');
    }
  }

  Future<void> SavedUserDataToStorage(String value) async {
    await saveUserData({
      'login_user': value,
      'login_user_name': state.userName,
    });
  }

  Future<void> saveUserData(Map<String, String> datas) async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    for (var data in datas.entries) {
      await secureStorage.write(key: data.key, value: data.value);
    }
  }

  Future<void> getUserName(
      OnGetUserName event, Emitter<AuthUserState> emit) async {
        emit(AuthUserState(isLoading: true));
    try {
      final userCollection = FirebaseFirestore.instance.collection('Users');
      final FlutterSecureStorage secureStorage = FlutterSecureStorage();
      var userId = await secureStorage.read(key: 'login_user');
      QuerySnapshot querySnapshot =
          await userCollection.where('user_id', isEqualTo: userId).get();
      if (querySnapshot.docs.isNotEmpty) {
        Users userData = Users.fromJson(querySnapshot.docs.first.data() as Map<String, dynamic>);
        emit(AuthUserState(isLoading: false, userName:  userData.username));
      } else {
        await secureStorage.write(key: 'login_user_name', value: '');
        emit(AuthUserState(isLoading: false, userName:  ''));
      }
    } catch (e) {
      emit(AuthUserState(isLoading: false, userName:  ''));
    }
  }
}
