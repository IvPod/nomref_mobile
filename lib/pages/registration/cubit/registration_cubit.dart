import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/authentication.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final AuthenticationCubit authenticationCubit;
  RegistrationCubit(this.authenticationCubit)
      : super(RegistrationInitial());

  Future<void> signUp(Map<String, dynamic> data) async {
    emit(RegistrationLoading());
    try {
      final user =
          await authenticationCubit.userRepository.signUp(data);
      await authenticationCubit.loggedIn(user);
      emit(RegistrationSuccess());
    } catch (e) {
      emit(RegistrationFailed());
    }
  }
}
