import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/Floor.dart';
import '../../data/repositories/BuildingRepositoryImpl.dart';

part 'floor_event.dart';
part 'floor_state.dart';

class FloorBloc extends Bloc<FloorEvent, FloorState> {
  BuildingRepositoryImpl buildingRepositoryImpl = BuildingRepositoryImpl();

  List<Floor>? floors = [];

  FloorBloc() : super(FloorLoading()) {
    on<FloorEvent>((event, emit) async {
      if(event is FloorCreating){
        Floor floor = event.floor;
        bool floorAdded = await buildingRepositoryImpl.insertNewFloor(floor);

        if(floorAdded){
          add(LoadBuildingFloors(buildingId: event.floor.buildingId));
        }
      }else if(event is LoadBuildingFloors){
        emit(FloorLoading());

        floors = await buildingRepositoryImpl.getBuildingFloors(event.buildingId);
        if(floors!.isEmpty){
          emit(FloorsAreEmpty(message: "you have not created any floors yet"));
        }else{
          emit(FloorLoadingSuccess(floors: floors!));
        }
      }else if(event is RemoveFloorEvent){
        bool floorRemoved = await buildingRepositoryImpl.removeFloor(event.floor);
        
        if(floorRemoved){
          add(LoadBuildingFloors(buildingId: event.floor.buildingId));
        }else{
          emit(FloorRemovingFailure(message: 'something went wrong'));
          
          await Future.delayed(const Duration(seconds: 3)).whenComplete(() => {
            add(LoadBuildingFloors(buildingId: event.floor.buildingId))
          });
        }
      }
    });
  }
}

