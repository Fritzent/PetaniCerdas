part of 'auth_user_bloc.dart';

abstract class AuthUserEvent {}

class OnSendOtp extends AuthUserEvent {
  final String phoneNumber;
  final String userName;
  final String viewedPage;
  OnSendOtp(this.phoneNumber, this.userName, this.viewedPage);
}

class OtpVerified extends AuthUserEvent {
  final PhoneAuthCredential credential;
  OtpVerified(this.credential);
}

class VerificationFailed extends AuthUserEvent {
  final String? message;
  VerificationFailed(this.message);
}

class CodeSent extends AuthUserEvent {
  final String verificationId;
  CodeSent(this.verificationId);
}

class OnVerifyOtp extends AuthUserEvent {
  final String otp;

  OnVerifyOtp(this.otp);
}