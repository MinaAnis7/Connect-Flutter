import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostModel
{
  late String uid;
  String? postId;
  late String name;
  late String profilePicture;
  late String text;
  String? postImage;
  List tags = [];
  String? dateTime;
  int numOfLikes = 0;
  int numOfComments = 0;

  PostModel({
    required this.uid,
    required this.name,
    required this.profilePicture,
    required this.text,
    this.postImage,
    this.dateTime,
});

  PostModel.fromJson(Map<String, dynamic> post)
   {
    this.uid = post["uid"];
    this.postId = post["postId"];
    this.name = post["name"];
    this.profilePicture = post["profilePicture"];
    this.text = post["text"];
    this.postImage = post["postImage"];
    this.tags = post["tags"];
    this.dateTime = getTime(post["dateTime"]);
    this.numOfLikes = post["numOfLikes"];
    this.numOfComments = post["numOfComments"];
  }

  String getTime(Timestamp serverTime)
  {
    return DateFormat('MMM d, yyyy hh:mm a')
        .format(serverTime.toDate().toLocal());
  }

  Map<String, dynamic> toMap()
  {
    return {
      'uid' : this.uid,
      'postId' : this.postId,
      'text' : this.text,
      'postImage' : this.postImage,
      'tags' : this.tags,
      'dateTime' : FieldValue.serverTimestamp(),
      'profilePicture' : this.profilePicture,
      'name' : this.name,
      'numOfLikes' : this.numOfLikes,
      'numOfComments' : this.numOfComments,
    };
  }

}