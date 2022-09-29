class Response {

  String? message;
  String? email;
  DateTime? date;

  Response({this.message,this.email,this.date});

  Map<String, dynamic> toJson() =>
      {
        'message': message,
        'email':email,
        'date':date
      };
}