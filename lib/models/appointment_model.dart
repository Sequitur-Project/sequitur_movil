class Appointment{
  DateTime appointmentDate;
  String appointmentTime;
  String appointmentLocation;
  String reason;
  bool accepted;

  Appointment({required this.appointmentDate, required this.appointmentTime, required this.appointmentLocation, required this.reason, required this.accepted});
}