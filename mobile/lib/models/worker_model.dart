class WorkerModel {
  final int id;
  final String referenceNo;
  final String name;
  final String phone;
  final String village;
  final List<String> skills;
  final String status;
  final String createdAt;

  WorkerModel({
    required this.id,
    required this.referenceNo,
    required this.name,
    required this.phone,
    required this.village,
    required this.skills,
    required this.status,
    required this.createdAt,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['id'] ?? 0,
      referenceNo: json['reference_no'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      village: json['village'] ?? '',
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      status: json['status'] ?? 'Registered',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'village': village,
      'skills': skills,
    };
  }
}
