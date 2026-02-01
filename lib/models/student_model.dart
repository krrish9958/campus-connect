class StudentModel {
  final String uid;
  final String name;
  final String email;
  final String rollNo;
  final String branch;
  final int year;
  final String? assignedTeacherId;

  StudentModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.rollNo,
    required this.branch,
    required this.year,
    this.assignedTeacherId,
  });

  factory StudentModel.fromMap(Map<String, dynamic> data, String id) {
    return StudentModel(
      uid: id,
      name: data['name'],
      email: data['email'],
      rollNo: data['rollNo'] ?? 'N/A',
      branch: data['branch'],
      year: data['year'],
      assignedTeacherId: data['assignedTeacherId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'rollNo': rollNo,
      'branch': branch,
      'year': year,
      'assignedTeacherId': assignedTeacherId,
    };
  }
}
