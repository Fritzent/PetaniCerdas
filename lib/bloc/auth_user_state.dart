part of 'auth_user_bloc.dart';

class AuthUserState {
  final String userName;
  final String verificationId;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;
  final String? viewedPage;

  AuthUserState(
      {this.isLoading = false,
      this.errorMessage,
      this.verificationId = '',
      this.isAuthenticated = false,
      this.userName = '',
      this.viewedPage = ''});

  AuthUserState copyWith({
    String? verificationId,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
    String? userName,
    String? viewedPage,
  }) {
    return AuthUserState(
      verificationId: verificationId ?? this.verificationId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      viewedPage: viewedPage ?? this.viewedPage,
    );
  }
}
