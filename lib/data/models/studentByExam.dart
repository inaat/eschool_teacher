class StudentByExam {
  StudentByExam({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.rollNumber,
    required this.theoryMark,
    required this.vivaMark,
    required this.totalMark,
    required totalTheoryMark,
    required totalVivaMark,
  });
  late final int id;

  late final String firstName;
  late final String lastName;
  late final String rollNumber;
  late final int totalMark;
  late final int theoryMark;
  late final int vivaMark;
  late final int totalTheoryMark;
  late final int totalVivaMark;
  StudentByExam.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;

    lastName = json['last_name'] ?? "";
    firstName = json['first_name'] ?? "";
    rollNumber = json['roll_number'] ?? "";

    totalMark = json['total_mark'] ?? 0;
    theoryMark = json['theory_mark'] ?? 0;
    vivaMark = json['viva_mark'] ?? 0;
    totalTheoryMark = json['total_theory_mark'] ?? 0;
    totalVivaMark = json['total_viva_mark'] ?? 0;
  }

  String getFullName() {
    return "$firstName $lastName";
  }
}
