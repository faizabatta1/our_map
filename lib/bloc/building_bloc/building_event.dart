part of 'building_bloc.dart';

abstract class BuildingEvent extends Equatable {
  const BuildingEvent();
}
class BuildingLoadInformation extends BuildingEvent{
  final int id;
  const BuildingLoadInformation({required this.id});

  @override
  List<Object?> get props => [id];
}

class BuildingInitialize extends BuildingEvent{
  final String name;
  final int id;
  const BuildingInitialize({required this.id,required this.name});

  @override
  List<Object?> get props => [id,name];
}

