import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cap_secure_mobile/repository/login_repository.dart';
import 'package:equatable/equatable.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final LoginRepository _loginRepository;

  PasswordBloc({required LoginRepository loginRepository})
    : _loginRepository = loginRepository,
      super(PasswordInitial()) {
    on<PasswordChangedEvent>(_onPasswordChanged);
  }

  Future<void> _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<PasswordState> emit,
  ) async {
    // Validation des mots de passe
    if (event.newPassword.isEmpty || event.confirmPassword.isEmpty) {
      emit(
        const PasswordValidationError(
          message: 'Veuillez remplir tous les champs',
        ),
      );
      return;
    }

    if (event.newPassword != event.confirmPassword) {
      emit(
        const PasswordValidationError(
          message: 'Les mots de passe ne correspondent pas',
        ),
      );
      return;
    }

    if (event.newPassword.length < 6) {
      emit(
        const PasswordValidationError(
          message: 'Le mot de passe doit contenir au moins 6 caractères',
        ),
      );
      return;
    }

    emit(const PasswordLoading());

    log('Changement du mot de passe pour ${event.registrationNumber}');

    try {
      final result = await _loginRepository.changePassword(
        registrationNumber: event.registrationNumber,
        password: event.newPassword,
      );

      if (result.status) {
        emit(const PasswordSuccess());
      } else {
        emit(
          PasswordError(message: 'Erreur lors du changement de mot de passe'),
        );
      }
    } catch (e) {
      emit(
        PasswordError(message: e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }
}
