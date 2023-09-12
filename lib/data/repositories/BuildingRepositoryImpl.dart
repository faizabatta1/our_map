import 'package:our_map/data/models/Building.dart';
import 'package:our_map/data/models/Floor.dart';
import 'package:our_map/data/models/Room.dart';
import 'package:our_map/data/models/Section.dart';

import '../../domain/repositories/BuildingRepositry.dart';
import '../../helpers/SqlLiteHelper.dart';

class BuildingRepositoryImpl implements BuildingRepository{
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Future<Building?> getBuildingById(int id) async{
    List results = await ((await databaseHelper.db).query('Building',where: 'id = ?', whereArgs: [id],));

    return results.length > 0 ? Building.fromJson(results.first) : null;
  }

  @override
  Future<bool> insertNewBuilding(Building building) async{
    return (await (await databaseHelper.db).insert('Building', building.toJson())) > 0;
  }

  @override
  Future<List<Floor>> getBuildingFloors(int buildingId) async{
    List results = await ((await databaseHelper.db).query('Floor',where: 'buildingId = ?', whereArgs: [buildingId],));
        return results.isNotEmpty ?
        results.map((result) {
          return Floor(name: result['name'],buildingId: result['buildingId'],id: result['id']); // return a new Person object with the updated hobbies list
        }).toList() : [];

  }

  @override
  Future<List<Section>> getFloorSections(int buildingId) async{
    List results = await ((await databaseHelper.db).query('Section',where: 'buildingId = ?', whereArgs: [buildingId],));
    return results.isNotEmpty ?
    results.map((result) {
      return Section(id:result['id'],name: result['name'], floorId: result['floorId'], buildingId: result['buildingId']); // return a new Person object with the updated hobbies list
    }).toList() : [];
  }

  @override
  Future<List<Room>> getSectionRooms(int buildingId) async{
    List results = await ((await databaseHelper.db).query('Room',where: 'buildingId = ?', whereArgs: [buildingId],));
    return results.isNotEmpty ?
    results.map((result) {
      return Room(note:result['note'],name: result['name'], id: result['id'], sectionId: result['sectionId'], buildingId: result['buildingId'], floorId: result['floorId']); // return a new Person object with the updated hobbies list
    }).toList() : [];
  }

  @override
  Future<bool> insertNewFloor(Floor floor) async{
    Building? buildExist = await getBuildingById(floor.buildingId);

    if(buildExist == null){
      return false;
    }else{
      List<Floor> buildingExistingFloors = await getBuildingFloors(floor.buildingId);
      if(buildingExistingFloors.length < 10){
        return (await (await databaseHelper.db).insert('Floor', floor.toJson())) > 0;
      }else{
        return false;
      }
    }
  }

  @override
  Future<bool> removeFloor(Floor floor) async{
    return (await (await databaseHelper.db).delete('Floor',where: 'id = ?',whereArgs: [floor.id])) > 0;
  }

  @override
  Future<bool> insertNewSection(Section section) async {
    Building? buildExist = await getBuildingById(section.buildingId);

    if(buildExist == null){
      return false;
    }else{
      List<Section> buildingExistingFloors = await getFloorSections(section.floorId);
      if(buildingExistingFloors.length < 10){
        return (await (await databaseHelper.db).insert('Section', section.toJson())) > 0;
      }else{
        return false;
      }
    }
  }

  @override
  Future<Floor?> getFloorById(int id) async{
    Map data;
    List results = (await (await databaseHelper.db).query('Floor',where: 'id = ?',whereArgs: [id]));
    if(results.isNotEmpty){
      data = results.first as Map;
      return Floor(buildingId: data['buildingId'], name: data['name']);
    }


    return null;
  }

  @override
  Future<bool> removeSection(Section section) async{
    return (await (await databaseHelper.db).delete('Section',where: 'id = ?',whereArgs: [section.id])) > 0;
  }

  @override
  Future<Section?> getSectionById(int id) async{
    var data = (await (await databaseHelper.db).query('Section',where: 'id = ?',whereArgs: [id])).first as Map;

    return Section(buildingId: data['buildingId'], name: data['name'], floorId: data['floorId']);
  }

  @override
  Future<bool> insertNewRoom(Room room) async{
    Building? buildExist = await getBuildingById(room.buildingId);

    if(buildExist == null){
      return false;
    }else{
      List<Room> buildingExistingFloors = await getSectionRooms(room.sectionId);
      if(buildingExistingFloors.length < 20){
        return (await (await databaseHelper.db).insert('Room', room.toJson())) > 0;
      }else{
        return false;
      }
    }
  }

  @override
  Future<bool> removeRoom(Room room) async{
    return (await (await databaseHelper.db).delete('Room',where: 'id = ?',whereArgs: [room.id])) > 0;
  }

  @override
  Future<bool> addNoteToRoom(int roomId, String note) async{
    return (await (await databaseHelper.db).update('Room',{
      'note':note
    }, where: 'id = ?',whereArgs: [roomId])) > 0;
  }
}