class ActiveJson {
  String? licenciaActivada;
  String? minutos;

  ActiveJson({this.licenciaActivada, this.minutos});

  ActiveJson.fromJson(Map<String, dynamic> json) {
    licenciaActivada = json['Licencia Activada'];
    minutos = json['minutos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['licenciaActivada'] = this.licenciaActivada;
    data['minutos'] = this.minutos;
    return data;
  }
}

class LicenciaActivada {
  String? date;
  int? timezoneType;
  String? timezone;

  LicenciaActivada({this.date, this.timezoneType, this.timezone});

  LicenciaActivada.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = json['timezone_type'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['timezone_type'] = this.timezoneType;
    data['timezone'] = this.timezone;
    return data;
  }
}
