part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeFailed extends HomeState {}

class HomeRadarActive extends HomeState {}

class HomeAddStationActive extends HomeState {}
