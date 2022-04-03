part of 'station_cubit.dart';

abstract class StationState extends Equatable {
  @override
  List<Object> get props => [];
}

class StationInitial extends StationState {}

class StationLoading extends StationState {}

class StationSuccess extends StationState {}

class StationDeleted extends StationState {}

class StationFailed extends StationState {}
