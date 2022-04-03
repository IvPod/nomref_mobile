part of 'registration_cubit.dart';

abstract class RegistrationState extends Equatable {
  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationFailed extends RegistrationState {}
