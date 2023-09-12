import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:our_map/data/models/Building.dart';

import '../../data/models/Floor.dart';
import '../../data/models/Room.dart';
import '../../data/repositories/BuildingRepositoryImpl.dart';

part 'building_event.dart';
part 'building_state.dart';

class BuildingBloc extends Bloc<BuildingEvent, BuildingState> {
  BuildingRepositoryImpl buildingRepositoryImpl = BuildingRepositoryImpl();

  List<Floor>? floors;

  BuildingBloc() : super(BuildingLoading()) {
    on<BuildingEvent>((event, emit) async{
      if(event is BuildingLoadInformation){
        emit(BuildingLoading());

        await buildingRepositoryImpl.getBuildingById(event.id).then((building) async => {
          if(building != null){
            emit(BuildingLoadingSuccess(data: building.toJson()))
          }else{
            emit(BuildingNotFound())
          }
        }).catchError((error){
          print(error);
          emit(BuildingLoadingFailure(message: "something went wrong"));
          return Future.error(error);
        });


      }else if(event is BuildingInitialize){
        bool inserted = await buildingRepositoryImpl.insertNewBuilding(Building(name: event.name, id: event.id));
        inserted ? add(BuildingLoadInformation(id: event.id)) : null;
      }
    });
  }
}
