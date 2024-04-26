enum NotificationType {
  like('like'),
  reply('reply'),
  follow('follow'),
  repost('repost');

  final String type;
  const NotificationType(this.type);
}

extension ConvertPost on String {
  NotificationType toNotificationTypeEnum() {
    switch (this) {
      case 'repost':
        return NotificationType.repost;
      case 'follow':
        return NotificationType.follow;
      case 'reply':
        return NotificationType.reply;
      default:
        return NotificationType.like;
    }
  }
}
