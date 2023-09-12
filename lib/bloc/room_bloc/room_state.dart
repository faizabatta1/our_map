part of 'room_bloc.dart';

abstract class RoomState extends Equatable {
  const RoomState();
}

class RoomInitial extends RoomState {
  @override
  List<Object> get props => [];
}

class RoomLoading extends RoomState {
  @override
  List<Object> get props => [];
}

class RoomLoadingSuccess extends RoomState{
  final List<Room> rooms;
  const RoomLoadingSuccess({required this.rooms});
  @override
  List<Object?> get props => [rooms];
}

class RoomLoadingFailure extends RoomState{
  final String message;
  const RoomLoadingFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class RoomsAreEmpty extends RoomState{
  final String message;
  const RoomsAreEmpty({required this.message});

  @override
  List<Object?> get props => [message];
}

class RoomRemovingFailure extends RoomState{
  final String message;
  const RoomRemovingFailure({required this.message});

  @override
  List<Object?> get props => [message];

}