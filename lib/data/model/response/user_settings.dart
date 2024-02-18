class UserSettings{
  SettingItem? calendarTrigger;
  SettingItem? isReceiverNotificationCommunity;
  SettingItem? isReceiverNotificationNewComment;
  SettingItem? isReceiverNotificationRecentClasses;
  SettingItem? isReceiverNotificationTrainingCalendar;

  UserSettings.fromJson(json){
    calendarTrigger = SettingItem.fromJson(json, 'calendar_trigger');
    isReceiverNotificationCommunity = SettingItem.fromJson(json, 'is_receiver_notification_community');
    isReceiverNotificationNewComment = SettingItem.fromJson(json, 'is_receiver_notification_new_comment');
    isReceiverNotificationRecentClasses = SettingItem.fromJson(json, 'is_receiver_notification_recent_classes');
    isReceiverNotificationTrainingCalendar = SettingItem.fromJson(json, 'is_receiver_notification_training_calendar');
  }

  List<SettingItem?>? itemsSetting(){
    return [
      calendarTrigger,
      isReceiverNotificationCommunity,
      isReceiverNotificationNewComment,
      isReceiverNotificationRecentClasses,
      isReceiverNotificationTrainingCalendar
    ];
  }

}

class SettingItem{
  dynamic value;
  String? trigger, key;

  SettingItem.fromJson(json, this.key){
    value = json[key]['value'];
    trigger = json[key]['trigger'];
  }

  void setValue(String value) {
    this.value = value;
  }
}