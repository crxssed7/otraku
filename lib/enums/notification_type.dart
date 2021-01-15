enum NotificationType {
  FOLLOWING,
  ACTIVITY_MESSAGE,
  ACTIVITY_REPLY,
  ACTIVITY_REPLY_SUBSCRIBED,
  THREAD_COMMENT_REPLY,
  ACTIVITY_MENTION,
  THREAD_COMMENT_MENTION,
  THREAD_SUBSCRIBED,
  ACTIVITY_LIKE,
  ACTIVITY_REPLY_LIKE,
  THREAD_LIKE,
  THREAD_COMMENT_LIKE,
  AIRING,
  RELATED_MEDIA_ADDITION,
}

extension NotificationTypeExtension on NotificationType {
  static const _notificationNames = const {
    NotificationType.FOLLOWING: 'New followers',
    NotificationType.ACTIVITY_MESSAGE: 'New messages',
    NotificationType.ACTIVITY_REPLY: 'Replies to my activities',
    NotificationType.ACTIVITY_REPLY_SUBSCRIBED:
        'Replies to activities I have replied to',
    NotificationType.THREAD_COMMENT_REPLY: 'Replies to my forum comments',
    NotificationType.ACTIVITY_MENTION: 'Activity mentions',
    NotificationType.THREAD_COMMENT_MENTION: 'Forum mentions',
    NotificationType.THREAD_SUBSCRIBED: 'Comments on a subscribed thread',
    NotificationType.ACTIVITY_LIKE: 'Likes on my activities',
    NotificationType.ACTIVITY_REPLY_LIKE: 'Likes on my activity replies',
    NotificationType.THREAD_LIKE: 'Likes on my forum threads',
    NotificationType.THREAD_COMMENT_LIKE: 'Likes on my forum comments',
    NotificationType.AIRING: 'Airings of anime I am watching',
    NotificationType.RELATED_MEDIA_ADDITION: 'New media related to me',
  };

  String get text => _notificationNames[this];
}