class Appointment {
  final int id;
  final int psychologistId;
  DateTime appointmentDate;
  String appointmentTime;
  String appointmentLocation;
  String reason;
  bool accepted;

  Appointment({
    required this.id,
    required this.psychologistId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentLocation,
    required this.reason,
    required this.accepted,
  });
}
