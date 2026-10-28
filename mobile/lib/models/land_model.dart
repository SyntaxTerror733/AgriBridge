class LandModel {
  final int id;
  final String referenceNo;
  final String name;
  final String phone;
  final String city;
  final String state;
  final String district;
  final String village;
  final double size;
  final String unit;
  final String waterSource;
  final String? notes;
  final String status;
  final String createdAt;

  LandModel({
    required this.id,
    required this.referenceNo,
    required this.name,
    required this.phone,
    required this.city,
    required this.state,
    required this.district,
    required this.village,
    required this.size,
    required this.unit,
    required this.waterSource,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  factory LandModel.fromJson(Map<String, dynamic> json) {
    return LandModel(
      id: json['id'] ?? 0,
      referenceNo: json['reference_no'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      village: json['village'] ?? '',
      size: (json['size'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? 'Acre',
      waterSource: json['water_source'] ?? 'Borewell',
      notes: json['notes'],
      status: json['status'] ?? 'Details submitted',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'city': city,
      'state': state,
      'district': district,
      'village': village,
      'size': size,
      'unit': unit,
      'water_source': waterSource,
      'notes': notes ?? '',
    };
  }
}
