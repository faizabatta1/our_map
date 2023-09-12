class Floor {
  int? id;
  final String name;
  final int buildingId;

  Floor({required this.buildingId,required this.name,this.id});

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      name: json['name'],
      buildingId: json['buildingId'],
      id:json['id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'buildingId': buildingId
    };
  }
}

