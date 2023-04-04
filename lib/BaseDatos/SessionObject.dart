
final String tableSesion = 'Sesion';

class SessionObjectFields{
  static final List<String> values = [id, usuario,cookie];
  static final String id = '_id';
  static final String usuario = '_usuario';
  static final String cookie = '_cookie';
}

class SessionObject{
  final int? id;
  final String usuario;
  final String cookie;

  SessionObject(
      {
        required this.id,
        required this.usuario,
        required this.cookie,
      });

  Map<String,Object?> toJson() => {
    SessionObjectFields.id: id,
    SessionObjectFields.usuario: usuario,
    SessionObjectFields.cookie: cookie,
  };

  static SessionObject fromJson(Map<String,Object?> json) => SessionObject(
    id: json[SessionObjectFields.id] as int?,
    usuario: json[SessionObjectFields.usuario] as String,
    cookie: json[SessionObjectFields.cookie] as String,
  );
  SessionObject copy({
    int? id,
    String? usuario,
    String? cookie
  })=>SessionObject(
    id: id ?? this.id,
    usuario: usuario ?? this.usuario,
    cookie:  cookie ?? this.cookie,
  );

}