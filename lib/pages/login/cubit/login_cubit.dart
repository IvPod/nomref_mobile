import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/authentication.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationCubit authenticationCubit;
  LoginCubit(this.authenticationCubit) : super(LoginInitial());

  Future<void> logIn(Map<String, dynamic> data) async {
    emit(LoginLoading());
    try {
      final user =
          await authenticationCubit.userRepository.logIn(data);
      if (user == null) {
        emit(LoginFailed());
      }
      await authenticationCubit.loggedIn(user);
      await authenticationCubit.userRepository.getUserStations();
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailed());
    }
  }
}
