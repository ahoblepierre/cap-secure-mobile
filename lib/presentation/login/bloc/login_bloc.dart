import 'package:bloc/bloc.dart';
import 'package:cap_secure_mobile/repository/login_repository.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;

  LoginBloc({LoginRepository? loginRepository})
    : _loginRepository = loginRepository ?? LoginRepository(),
      super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await _loginRepository.login(
        registrationNumber: event.registrationNumber,
        password: event.password,
      );

      if (response.status) {
        emit(
          LoginSuccess(
            isFirstLogin: response.isFirstLogin,
            resgistrationNumber: event.registrationNumber,
          ),
        );
      } else {
        emit(const LoginFailure(message: 'Connexion échouée'));
      }
    } catch (e) {
      emit(LoginFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
