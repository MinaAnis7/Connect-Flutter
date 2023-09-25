class PostModel
{
  late String uid;
  String? postId;
  late String name;
  late String profilePicture;
  late String text;
  String? postImage;
  List tags = [];
  late String dateTime;
  int numOfLikes = 0;
  int numOfComments = 0;

  PostModel({
    required this.uid,
    required this.name,
    required this.profilePicture,
    required this.text,
    this.postImage,
    required this.dateTime,
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
    this.dateTime = post["dateTime"];
    this.numOfLikes = post["numOfLikes"];
    this.numOfComments = post["numOfComments"];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'uid' : this.uid,
      'postId' : this.postId,
      'text' : this.text,
      'postImage' : this.postImage,
      'tags' : this.tags,
      'dateTime' : this.dateTime,
      'profilePicture' : this.profilePicture,
      'name' : this.name,
      'numOfLikes' : this.numOfLikes,
      'numOfComments' : this.numOfComments,
    };
  }

}