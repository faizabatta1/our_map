import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/Floor.dart';
import '../../data/models/Room.dart';
import '../../data/models/Section.dart';
import '../../data/repositories/BuildingRepositoryImpl.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  List<Room> rooms = [];
  BuildingRepositoryImpl buildingRepositoryImpl = BuildingRepositoryImpl();

  RoomBloc() : super(RoomInitial()) {
    on<RoomEvent>((event, emit) async {
      if(event is LoadRoomsEvent){
        emit(RoomLoading());
        rooms = await buildingRepositoryImpl.getSectionRooms(event.buildingId);

        if(rooms.isEmpty){
          emit(RoomsAreEmpty(message: "you have not added any Rooms yet"));
        }else{
          for(var room in rooms){
            Section? section = await buildingRepositoryImpl.getSectionById(room.sectionId);
            Floor? floor = await buildingRepositoryImpl.getFloorById(section!.floorId);
            room.sectionName = section!.name;
            room.floorName = floor!.name;
          }

          emit(RoomLoadingSuccess(rooms: rooms));
        }
      }else if(event is RoomsCreateEvent){
        bool sectionInserted = await buildingRepositoryImpl.insertNewRoom(
            Room(
              buildingId: event.buildingId,
              name: event.name,
              floorId: event.floorId,
              sectionId: event.sectionId,
            )
        );

        if(sectionInserted){
          add(LoadRoomsEvent(buildingId: event.buildingId));
        }else{
          emit(RoomLoadingFailure(message: "could not add a new section"));
        }
      }else if(event is RoomsRemoveEvent){
        bool sectionRemoved = await buildingRepositoryImpl.removeRoom(event.room);

        if(sectionRemoved){
          add(LoadRoomsEvent(buildingId: event.room.buildingId));
        }else{
          emit(RoomRemovingFailure(message: 'something went wrong'));
        }
      }else if(event is RoomAddNote){
        buildingRepositoryImpl.addNoteToRoom(event.roomId,event.note);
        add(LoadRoomsEvent(buildingId: event.buildingId));
      }
    });
  }
}
