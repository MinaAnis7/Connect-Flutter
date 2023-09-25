import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/user_model.dart';

class CommentModel
{
  late String comment;
  UserModel? user;

  CommentModel({required this.comment, required this.user});

  CommentModel.fromJson(Map<String, dynamic> comment, UserModel user_)
  {
    this.comment = comment['comment'];
    this.user = user_;
  }

  Map<String, dynamic> toMap()
  {
    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(this.user?.id);
    return {
      'comment' : this.comment,
      'user' : userDoc,
    };
  }
}