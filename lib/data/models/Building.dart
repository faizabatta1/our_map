class Building {
  final int id;
  final String name;

  Building({required this.name, required this.id});

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}

