


import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'LicenciaObject.dart';
import 'SessionObject.dart';


class TuEnvioDatabase {
  static final TuEnvioDatabase instance = TuEnvioDatabase._init();

  static Database? _database;

  TuEnvioDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tuenvio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY';
    final usuarioType = 'TEXT NOT NULL';
    final cookieType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE $tableSesion (
    ${SessionObjectFields.id} $idType,
    ${SessionObjectFields.usuario} $usuarioType,
    ${SessionObjectFields.cookie} $cookieType
    );
    ''');

    await db.execute('''
    CREATE TABLE $tableLicencia (
    ${LicenciaObjectFields.code} $usuarioType,
    ${LicenciaObjectFields.time} $cookieType,
    ${LicenciaObjectFields.minutos} $cookieType
    );
    ''');



  }

  Future<SessionObject> createSession(SessionObject session) async {
    final db = await instance.database;
    /* final json = session.toJson();
    final columns = '${SessionObjectFields.usuario}, ${SessionObjectFields.cookie}';
    final values = '${json[SessionObjectFields.usuario]}, ${json[SessionObjectFields.cookie]}';
    final id = await db.rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');*/
    final id = await db.insert(tableSesion, session.toJson());
    return session.copy(id: id);
  }


  Future<List<LicenciaObject>> readAllLicencia() async {
    final db = await instance.database;
    final result = await db.query(tableLicencia);
    return result.map((json) => LicenciaObject.fromJson(json)).toList();
  }


  Future<SessionObject> readSesion(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableSesion,
      columns: SessionObjectFields.values,
      where: '${SessionObjectFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return SessionObject.fromJson(maps.first);
    } else {
      print('ID $id not found');
      SessionObject ss = new SessionObject(id: 0, usuario: "usuario", cookie: "cookie");
      return ss;


    }
  }





  Future<List<SessionObject>> readAllSesion() async {
    final db = await instance.database;
    final result = await db.query(tableSesion);
    return result.map((json) => SessionObject.fromJson(json)).toList();
  }



  Future<int> update(SessionObject session) async {
    final db = await instance.database;
    return db.update(
      tableSesion,
      session.toJson(),
      where: '${SessionObjectFields.id} = ?',
      whereArgs: [session.id],
    );
  }

  Future<LicenciaObject> createLicencia(LicenciaObject session) async {
    final db = await instance.database;
    final id = await db.insert(tableLicencia, session.toJson());
    return session.copy(code: session.code);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableSesion,
      where: '${SessionObjectFields.id} = ?',
      whereArgs: [id],
    );
  }
  Future<int> deleteLicencia(String code) async {
    final db = await instance.database;
    return await db.delete(
      tableLicencia,
      where: '${LicenciaObjectFields.code} = ?',
      whereArgs: [code],
    );
  }
  Future<int> deleteLicencias() async {
    final db = await instance.database;
    return await db.delete(
      tableLicencia,
    );
  }




  Future close() async {
    final db = await instance.database;
    db.close();
  }

}
