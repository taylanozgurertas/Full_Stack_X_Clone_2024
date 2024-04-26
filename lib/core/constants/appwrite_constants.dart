//! IT CONTAINS APPWRITE THINGS LIKE DATABASE ID AND PROJECT ID THEY ARE COMING FROM APPWRITE
class AppwriteConstants {
  static const String databaseId = '660d9df1002a01611a51';
  static const String projectId = '660d9a00000dfb6cd2d3';
  static const String endPoint = 'http://YOUR_IP/v1';
  static const String usersCollection = '660eb11800255d708e2a';
  static const String postCollection = '66100fdd00037bc121f7';
  static const String imagesBucket = '66102a00001bc11d8d03';
  static const String kooginstreamdb = '6611a824003e03509b9c';
  static const String notificationsCollection = '66291f6e0020f0376713';

  static String imageUrl(String imageId) {
    return '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
  }
}
