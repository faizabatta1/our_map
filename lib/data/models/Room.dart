class Room {
  final int? id;
  final String name;
  final int sectionId;
  String? sectionName = "";
  String? floorName = "";
  final int buildingId;
  final int floorId;
  String? note = "";
  Room({this.note,required this.name, this.id,required this.sectionId,this.sectionName,required this.buildingId,this.floorName,required this.floorId});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'],
      id: json['id'],
      sectionId: json['sectionId'],
        buildingId:json['buildingId'],
        floorId: json['floorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sectionId':sectionId,
      'buildingId':buildingId,
      'floorId':floorId
    };
  }
}

