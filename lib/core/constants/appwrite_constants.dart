//! IT CONTAINS APPWRITE THINGS LIKE DATABASE ID AND PROJECT ID THEY ARE COMING FROM APPWRITE
class AppwriteConstants {
  static const String databaseId = 'yourdatabaseid';
  static const String projectId = 'yourprojectid';
  static const String endPoint = 'http://YOUR_IP/v1';
  static const String usersCollection = 'youruserscollectionid';
  static const String postCollection = 'yourpostcollectionid';
  static const String imagesBucket = 'yourimagebucketid';
  static const String kooginstreamdb = 'yourstreamdbid';
  static const String notificationsCollection = 'yournotificationcollectionid';

  static String imageUrl(String imageId) {
    return '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
  }
}
