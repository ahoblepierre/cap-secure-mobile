part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final bool isFirstLogin;
  final String resgistrationNumber;

  const LoginSuccess({
    required this.isFirstLogin,
    required this.resgistrationNumber,
  });

  @override
  List<Object> get props => [isFirstLogin, resgistrationNumber];
}

final class LoginFailure extends LoginState {
  final String message;

  const LoginFailure({required this.message});

  @override
  List<Object> get props => [message];
}
