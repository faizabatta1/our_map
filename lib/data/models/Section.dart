class Section {
  final int? id;
  final int floorId;
  final String name;
  final int buildingId;
  String? floorName;

  Section({required this.buildingId,required this.name,required this.floorId, this.id,this.floorName});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      name: json['name'],
      id: json['id'],
      floorId: json['floorId'],
      buildingId: json['buildingId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'floorId':floorId,
      'buildingId':buildingId
    };
  }
}

