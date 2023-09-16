import 'package:sqflite/sqflite.dart';

class ReminderModel{
  ReminderModel({this.name,this.time,this.id});

  String? name;
  DateTime? time;
  int? id;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "title": name,
      "time": time.toString() ,
    };
    if (id != null) {
      map["_id"] = id;
    }
    return map;
  }

  ReminderModel.fromMap(map) {
    id = map["_id"];
    name = map["title"];
    time = DateTime.parse(map["time"]);
  }
}

const String tableReminder = 'reminder';

/// id column name
const String columnId = '_id';

/// title column name
const String columnTitle = 'title';

/// done column name
const String columnTime = 'time';

class ReminderProvider {
  late Database db;
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
create table $tableReminder ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnTime integer not null)
''');
        });
  }

  Future<ReminderModel> insert(ReminderModel reminder) async {
    reminder.id = await db.insert(tableReminder, reminder.toMap());
    return reminder;
  }

  Future<ReminderModel?> getReminder(int id) async {
    List<Map> maps = await db.query("reminder",
        columns: [columnId, columnTime, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ReminderModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ReminderModel>?> getAll() async {
    List<Map> maps = await db.query("reminder",
        columns: [columnId, columnTime, columnTitle],
    );
    if (maps.length > 0) {
      List<ReminderModel> res =[];
      maps.forEach((element) {
        res.add(ReminderModel.fromMap(element));
      });
      return res;
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableReminder, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(ReminderModel reminder) async {
    return await db.update(tableReminder, reminder.toMap(),
        where: '$columnId = ?', whereArgs: [reminder.id]);
  }

  Future close() async => db.close();
}