
class ErrorJson {
  bool? hasError;
  List<String>? errors;

  ErrorJson({this.hasError, this.errors});

  ErrorJson.fromJson(Map<String, dynamic> json) {
    hasError = json['hasError'];
    errors = json['errors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hasError'] = this.hasError;
    data['errors'] = this.errors;
    return data;
  }
}
