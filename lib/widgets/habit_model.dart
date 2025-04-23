class Habit {
  final int id;
  final String name;
  final String trackingUnit;
  final double duration;

  Habit({
    required this.id,
    required this.name,
    required this.trackingUnit,
    required this.duration,
  });

  // Convert data from the database
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      trackingUnit: map['tracking_unit'],
      duration: map['duration'].toDouble(),
    );
  }

  // Convert object to map for inserting to DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'tracking_unit': trackingUnit,
      'duration': duration,
    };
  }
}
