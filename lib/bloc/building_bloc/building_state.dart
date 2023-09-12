part of 'building_bloc.dart';

abstract class BuildingState extends Equatable {
  const BuildingState();
}

class BuildingLoading extends BuildingState {
  @override
  List<Object> get props => [];
}

class BuildingLoadingSuccess extends BuildingState {
  final Map data;
  const BuildingLoadingSuccess({required this.data});
  @override
  List<Object> get props => [data];
}

class BuildingLoadingFailure extends BuildingState {
  final String message;
  const BuildingLoadingFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class BuildingNotFound extends BuildingState{
  @override
  List<Object?> get props => [];
}