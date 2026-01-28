part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginSubmitted extends LoginEvent {
  final String registrationNumber;
  final String password;

  const LoginSubmitted({
    required this.registrationNumber,
    required this.password,
  });

  @override
  List<Object> get props => [registrationNumber, password];
}
