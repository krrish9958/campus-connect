class StudentModel {
  final String uid;
  final String name;
  final String rollNo;
  final String branch;
  final int year;
  final String email;
  final String role;

  StudentModel({
    required this.uid,
    required this.name,
    required this.rollNo,
    required this.branch,
    required this.year,
    required this.email,
    required this.role,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map, String id) {
    return StudentModel(
      uid: id,
      name: map['name'],
      rollNo: map['rollNo'],
      branch: map['branch'],
      year: map['year'],
      email: map['email'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rollNo': rollNo,
      'branch': branch,
      'year': year,
      'email': email,
      'role': role,
    };
  }
}
