class ParkingSlot {
  final String id;          // Firestore document ID
  final int slotNumber;
  final String status;      // 'available' or 'occupied'
  final String occupantName;

  ParkingSlot({
    required this.id,
    required this.slotNumber,
    required this.status,
    required this.occupantName,
  });

  bool get isOccupied => status == 'occupied';
  String get occupiedBy => occupantName;

  factory ParkingSlot.fromMap(Map<String, dynamic> data, [String? docId]) {
    return ParkingSlot(
      id: docId ?? '',
      slotNumber: data['slotNumber'] ?? 0,
      status: data['status'] ?? 'available',
      occupantName: data['occupantName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'slotNumber': slotNumber,
      'status': status,
      'occupantName': occupantName,
    };
  }
}
