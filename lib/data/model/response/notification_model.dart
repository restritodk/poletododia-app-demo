import '../enum/notification_type.dart';

class NotificationModel{
  String? notificationID, title, body, image, link, itemID;
  int? id;
  bool? isRead;
  NotificationType? notificationType;

  NotificationModel({this.notificationID,this.notificationType,this.body,this.title,this.image,this.link,this.id,this.itemID});

  NotificationModel.fromJson(json){
    id = json['id'];
    notificationID = json['notification_id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    link = json['link'];
    itemID = json['item_id'];
    isRead = bool.parse(json['read']);
    notificationType = NotificationType.values.byName(json['notification_type']);
  }

  Map<String, Object?> toJson() {
    return {
      'notification_id':notificationID,
      'title':title,
      'body':body,
      'image':image,
      'link':link,
      'item_id':itemID,
      'read': 'false',
      'notification_type':notificationType!.name,
      'created_at':DateTime.now().toString(),
    };
  }

}