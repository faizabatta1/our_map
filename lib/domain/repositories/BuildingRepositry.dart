import 'package:our_map/data/models/Section.dart';

import '../../data/models/Building.dart';
import '../../data/models/Floor.dart';
import '../../data/models/Room.dart';

abstract class BuildingRepository{
  Future<Building?> getBuildingById(int id);
  Future<Floor?> getFloorById(int id);
  Future<Section?> getSectionById(int id);
  Future<bool> insertNewBuilding(Building building);
  Future<List<Floor>> getBuildingFloors(int buildingId);
  Future<List<Section>> getFloorSections(int buildingId);
  Future<List<Room>> getSectionRooms(int buildingId);
  Future<bool> insertNewFloor(Floor floor);
  Future<bool> insertNewSection(Section section);
  Future<bool> insertNewRoom(Room room);
  Future<bool> removeFloor(Floor floor);
  Future<bool> removeSection(Section section);
  Future<bool> removeRoom(Room room);
  Future<bool> addNoteToRoom(int roomId,String note);

  // void updateBuildingInformation(Building building);
  //
  // void addFloorToBuilding(int id,Floor floor);
  //
  // void addRoomToBuilding(int floorId,Room room);
}