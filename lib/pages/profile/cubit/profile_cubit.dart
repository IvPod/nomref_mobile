import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomref_mob/authentication/authentication.dart';
import 'package:nomref_mob/services/api/requests/user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthenticationCubit authenticationCubit;
  ProfileCubit(this.authenticationCubit) : super(ProfileInitial());

  Future<void> updateInfo(Map<String, dynamic> data) async {
    emit(ProfileLoading());
    try {
      final user = await UserAPI.updateInfo(data);
      authenticationCubit.userRepository.persistInfo(
          authenticationCubit.userRepository.user.copyWith(
        name: user.name,
        location: user.location,
      ));
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileFailed());
    }
  }

  Future<void> deleteMyProfile() async {
    emit(ProfileLoading());
    try {
      await UserAPI.deleteMyProfile();
      await authenticationCubit.loggedOut();
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileFailed());
    }
  }

  Future<void> uploadAvatar(String avatarPath) async {
    emit(ProfileLoading());
    try {
      final image = await UserAPI.uploadAvatar(avatarPath);
      final tempUser = authenticationCubit.userRepository.user
          .copyWith(image: image);
      await authenticationCubit.userRepository.persistInfo(tempUser);
      emit(ProfileSuccess());
    } catch (error) {
      emit(ProfileFailed());
    }
  }
}
