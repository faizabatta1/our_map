part of 'section_bloc.dart';

abstract class SectionEvent extends Equatable {
  const SectionEvent();
}

class LoadSectionsEvent extends SectionEvent{
  final int buildingId;
  const LoadSectionsEvent({required this.buildingId});

  @override
  List<Object?> get props => [buildingId];
}


class SectionCreateEvent extends SectionEvent{
  final String name;
  final int floorId;
  final int buildingId;

  const SectionCreateEvent({required this.name,required this.floorId,required this.buildingId});

  @override
  List<Object?> get props => [name,floorId,buildingId];
}

class SectionRemoveEvent extends SectionEvent{
  final Section section;
  const SectionRemoveEvent({required this.section});
  @override
  List<Object?> get props => [section];

}