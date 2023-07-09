class StudentByRoutine{
  StudentByRoutine({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.rollNumber,
    required this.theoryMark,
    required this.totalMark,
   
  });
  late final int id;

  late final String firstName;
  late final String lastName;
  late final String rollNumber;
  late final int totalMark;
  late final int theoryMark;
  
  StudentByRoutine.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;

    lastName = json['last_name'] ?? "";
    firstName = json['first_name'] ?? "";
    rollNumber = json['roll_number'] ?? "";

    totalMark = json['total_mark'] ?? 0;
    theoryMark = json['obtain_mark'] ?? 0;
  
  }

  String getFullName() {
    return "$firstName $lastName";
  }
}
