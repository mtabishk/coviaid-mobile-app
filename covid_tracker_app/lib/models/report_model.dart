class ReportModel {
  ReportModel({
    this.email,
    this.title,
    this.description,
    this.location,
    this.attachment1,
    this.attachment2,
    this.attachment3,
  });

  final email;
  final title;
  final description;
  final location;
  final attachment1;
  final attachment2;
  final attachment3;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'title': title,
      'description': description,
      'location': location,
      'attachment1': attachment1,
      'attachment2': attachment2,
      'attachment3': attachment3,
    };
  }
}
