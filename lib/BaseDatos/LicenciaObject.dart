
final String tableLicencia = 'Licencia';

class LicenciaObjectFields{
  static final List<String> values = [code,time,minutos];
  static final String code = '_code';
  static final String time = '_time';
  static final String minutos = '_minutos';
}

class LicenciaObject{
  final String code;
  final String time;
  final String minutos;



  LicenciaObject(
      {
        required this.code,
        required this.time,
        required this.minutos,
      });

  Map<String,Object?> toJson() => {
    LicenciaObjectFields.code: code,
    LicenciaObjectFields.time: time,
    LicenciaObjectFields.minutos: minutos,
  };

  static LicenciaObject fromJson(Map<String,Object?> json) => LicenciaObject(
    code: json[LicenciaObjectFields.code] as String,
    time: json[LicenciaObjectFields.time] as String,
    minutos:  json[LicenciaObjectFields.minutos] as String,

  );
  LicenciaObject copy({
    String? code,
    String? time,
    String? minutos
  })=>LicenciaObject(
      code: code ?? this.code,
      time:  time ?? this.time,
      minutos:  minutos ?? this.minutos
  );

}