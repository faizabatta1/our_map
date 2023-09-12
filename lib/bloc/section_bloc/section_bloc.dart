import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/Floor.dart';
import '../../data/models/Section.dart';
import '../../data/repositories/BuildingRepositoryImpl.dart';

part 'section_event.dart';
part 'section_state.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  BuildingRepositoryImpl buildingRepositoryImpl = BuildingRepositoryImpl();
  List<Section> sections = [];

  SectionBloc() : super(SectionInitial()) {
    on<SectionEvent>((event, emit) async {
      if(event is LoadSectionsEvent){
        emit(SectionLoading());
        sections = await buildingRepositoryImpl.getFloorSections(event.buildingId);
        print(sections);
        if(sections.isEmpty){
          emit(SectionsAreEmpty(message: "you have not added any sections yet"));
        }else{
          for(var section in sections){
            Floor? floor = await buildingRepositoryImpl.getFloorById(section.floorId);
            if(floor != null){
              section.floorName = floor.name;
            }else{
              section.floorName = 'removed';
            }
          }

          print(sections[0].floorName);
          emit(SectionLoadingSuccess(sections: sections));
        }
      }else if(event is SectionCreateEvent){
        bool sectionInserted = await buildingRepositoryImpl.insertNewSection(
          Section(
              buildingId: event.buildingId,
              name: event.name,
              floorId: event.floorId,
          )
        );

        if(sectionInserted){
          add(LoadSectionsEvent(buildingId: event.buildingId));
        }else{
          emit(SectionLoadingFailure(message: "could not add a new section"));
        }
      }else if(event is SectionRemoveEvent){
        bool sectionRemoved = await buildingRepositoryImpl.removeSection(event.section);

        if(sectionRemoved){
          add(LoadSectionsEvent(buildingId: event.section.buildingId));
        }else{
          emit(SectionRemovingFailure(message: 'something went wrong'));
        }
      }
    });
  }
}
