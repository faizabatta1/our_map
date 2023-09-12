part of 'floor_bloc.dart';

abstract class FloorState extends Equatable {
  const FloorState();
}

class FloorLoading extends FloorState {
  @override
  List<Object> get props => [];
}

class FloorLoadingSuccess extends FloorState {
  final List<Floor> floors;
  const FloorLoadingSuccess({required this.floors});
  @override
  List<Object> get props => [floors];
}

class FloorLoadingFailure extends FloorState {
  final String message;
  const FloorLoadingFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class FloorRemovingFailure extends FloorState {
  final String message;
  const FloorRemovingFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class FloorMaxNumberReached extends FloorState {
  final String message;
  const FloorMaxNumberReached({required this.message});

  @override
  List<Object> get props => [message];
}

class FloorsAreEmpty extends FloorState{
  final String message;
  const FloorsAreEmpty({required this.message});

  @override
  List<Object?> get props => [];
}
