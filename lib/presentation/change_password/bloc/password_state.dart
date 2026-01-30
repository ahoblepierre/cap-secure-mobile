part of 'password_bloc.dart';

sealed class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => [];
}

final class PasswordInitial extends PasswordState {
  const PasswordInitial();
}

final class PasswordLoading extends PasswordState {
  const PasswordLoading();
}

final class PasswordSuccess extends PasswordState {
  final String message;

  const PasswordSuccess({this.message = 'Mot de passe modifié avec succès'});

  @override
  List<Object> get props => [message];
}

final class PasswordError extends PasswordState {
  final String message;

  const PasswordError({required this.message});

  @override
  List<Object> get props => [message];
}

final class PasswordValidationError extends PasswordState {
  final String message;

  const PasswordValidationError({required this.message});

  @override
  List<Object> get props => [message];
}
