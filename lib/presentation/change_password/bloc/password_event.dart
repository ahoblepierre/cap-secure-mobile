part of 'password_bloc.dart';

sealed class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}

final class PasswordChangedEvent extends PasswordEvent {
  final String registrationNumber;
  final String newPassword;
  final String confirmPassword;

  const PasswordChangedEvent({
    required this.registrationNumber,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [registrationNumber, newPassword, confirmPassword];
}
