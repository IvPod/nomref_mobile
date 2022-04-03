import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user/user.dart';
import '../repository/user_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationStatus> {
  final UserRepository userRepository;

  AuthenticationCubit({@required this.userRepository})
      : super(AuthenticationStatus.unknown);

  Future<void> appStarted() async {
    try {
      final hasInfo = await userRepository.hasInfo();
      if (hasInfo) {
        await userRepository.getUserStations();
        emit(AuthenticationStatus.authenticated);
      } else {
        emit(AuthenticationStatus.unauthenticated);
      }
    } catch (error) {
      await userRepository.deleteInfo();
      emit(AuthenticationStatus.unauthenticated);
    }
  }

  Future<void> loggedIn(User user) async {
    try {
      await userRepository.persistInfo(user);
      emit(AuthenticationStatus.authenticated);
    } catch (error) {}
  }

  Future<void> loggedOut() async {
    try {
      await userRepository.deleteInfo();
      emit(AuthenticationStatus.unauthenticated);
    } catch (error) {}
  }
}
