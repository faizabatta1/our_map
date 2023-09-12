part of 'floor_bloc.dart';

abstract class FloorEvent extends Equatable {
  const FloorEvent();
}

class FloorCreating extends FloorEvent{
  final Floor floor;
  const FloorCreating({required this.floor});
  @override
  List<Object?> get props => [];
}

class LoadBuildingFloors extends FloorEvent{
  final int buildingId;
  const LoadBuildingFloors({required this.buildingId});

  @override
  List<Object?> get props => [buildingId];
}

class RemoveFloorEvent extends FloorEvent{
  final Floor floor;
  const RemoveFloorEvent({required this.floor});

  @override
  List<Object?> get props => [floor];
}