part of 'room_bloc.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();
}

class LoadRoomsEvent extends RoomEvent{
  final int buildingId;
  const LoadRoomsEvent({required this.buildingId});

  @override
  List<Object?> get props => [buildingId];
}


class RoomsCreateEvent extends RoomEvent{
  final String name;
  final int buildingId;
  final int sectionId;
  final int floorId;

  const RoomsCreateEvent({required this.name,required this.buildingId,required this.sectionId, required this.floorId});

  @override
  List<Object?> get props => [name,buildingId,sectionId,floorId];
}

class RoomsRemoveEvent extends RoomEvent{
  final Room room;
  const RoomsRemoveEvent({required this.room});
  @override
  List<Object?> get props => [room];

}

class RoomAddNote extends RoomEvent{
  final String note;
  final int roomId;
  final int buildingId;

  const RoomAddNote({required this.note,required this.roomId,required this.buildingId});
  @override
  // TODO: implement props
  List<Object?> get props => [note,roomId,buildingId];

}