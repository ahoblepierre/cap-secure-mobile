import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  void _onSplashStarted(SplashStarted event, Emitter<SplashState> emit) async {
    final box = GetStorage();
    final isLoggedIn = box.read('token');

    await Future.delayed(const Duration(seconds: 2));

    if (isLoggedIn != null && isLoggedIn.isNotEmpty) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}
