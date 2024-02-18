import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/data/model/response/notification_model.dart';

class NotificationDatabase{
  final String _id = 'id';
  final String _table = 'notifications';
  final String _notificationID = 'notification_id';
  final String _title = 'title';
  final String _body = 'body';
  final String _image = 'image';
  final String _link = 'link';
  final String _itemID = 'item_id';
  final String _read = 'read';
  final String _notificationType = 'notification_type';
  final String _createdAt = 'created_at';

  static NotificationDatabase? _historiesDatabase;
  NotificationDatabase.createInstance();
  Database? _database;

  factory NotificationDatabase(){
    _historiesDatabase ??= NotificationDatabase.createInstance();
    return _historiesDatabase!;
  }

  Future<Database?> get database async {
    _database ??= await startDatabase();
    return _database;
  }

  Future<Database> startDatabase() async {
    Directory directory = Directory(await getDatabasesPath());
    String path = '${directory.path}/NotificationsApp.db';
    var db = await openDatabase(path, version: 1, onCreate: _createDb);
    return db;
  }

  void _createDb(Database db, int version) {
    db.execute('CREATE TABLE $_table($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_notificationID TEXT, $_title TEXT, $_body TEXT, $_image TEXT, $_link TEXT, $_itemID TEXT, $_notificationType TEXT, $_read TEXT, $_createdAt TEXT)');
  }

  Future<List<NotificationModel>> loadingNotifications()async{
    var db = await database;
    var notifications = await db!.query(_table, orderBy: '$_createdAt DESC');


    List<NotificationModel> list = notifications.map((e) {
      return NotificationModel.fromJson(e);
    }).toList();

    List<NotificationModel> listIfExist = [];
    for (var notification in list) {
      if(listIfExist.where((element) => notification.notificationID == element.notificationID).isEmpty){
        listIfExist.add(notification);
      }else{
        await delete(notification);
      }
    }

    return list;
  }

  Future<bool> add(NotificationModel notificationModel) async{
    var db = await database;
    var result = await db!.query(_table, where: '$_notificationID = ?', whereArgs: [notificationModel.notificationID]);


    if(result.isEmpty){
      try{
        var result = await db.insert(_table, notificationModel.toJson());
        return result == 1;
      }catch(e){
        return false;
      }
    }
    return false;
  }

  Future<bool> delete(NotificationModel notification) async{
    var db = await database;
    var result = await db!.delete(_table, where: 'id = ?', whereArgs: [notification.id]);
    return result == 1;
  }

  Future<bool> clear() async{
    var db = await database;
    var result = await db!.delete(_table);
    return result == 1;
  }

  Future<bool> updated(String notificationID, Map<String, Object?> map) async{
    var db = await database;
    try{
      var result = await db!.update(_table, map, where: '$_notificationID = ?', whereArgs: [notificationID]);
      return result == 1;
    }catch(e){
      return false;
    }
  }

  Future<bool> cleanReadNotifications() async{
    var db = await database;
    try{
      var result = await db!.update(_table, {'read':true});
      return result == 1;
    }catch(e){
      return false;
    }
  }
}