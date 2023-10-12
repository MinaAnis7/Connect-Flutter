import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/notification.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats.dart';
import 'package:social_app/modules/friends.dart';
import 'package:social_app/modules/news_feed.dart';
import 'package:social_app/modules/profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache/cache_helper.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import 'package:social_app/shared/style/icons/my_icons_icons.dart';
import '../../../../models/post_model.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  

  //#region Obscure Text
  bool isObscure = true;
  IconData obscureIcon = Icons.visibility_outlined;

  void changeVisibility() {
    isObscure = !isObscure;
    obscureIcon =
        isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangeVisibility());
  }

  //#endregion

  //#region User Register & Login
  void userRegister(String name, String email, String Password, String phone,
      String img, String bio, String cover, int conn) {
    emit(UserRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: Password,
    )
        .then((value) {
      createUser(
        id: value.user!.uid,
        name: name,
        email: email,
        phone: phone,
        img: img,
        bio: bio,
        cover: cover,
        connects: conn,
      );
      CacheHelper.putString('userId', value.user!.uid)
          .then((value) {
        emit(UserRegisterSuccessState());
        getUserData();
      })
          .catchError((error) {
            errorMsg(error.toString());
      });

      if (kDebugMode) print(value.user!.email);
    }).catchError((error) {
      emit(UserRegisterErrorState());
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  void userLogin(String email, String Password) {
    emit(UserLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: Password,
    )
        .then((value) async {
      emit(UserLoginSuccessState());

      CacheHelper.putString('userId', value.user!.uid)
          .then((value) {
            getUserData();
      })
          .catchError((error) {
        kDebugMode ? print(error.toString()) : null;
      });
      if (kDebugMode) print(value.user!.email);
    }).catchError((error) {
      emit(UserLoginErrorState(error.toString()));
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  // creates user and put him/her in Firestore database
  void createUser({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String img,
    required String bio,
    required String cover,
    required int connects,
  }) {
    UserModel user =
        UserModel(name, email, phone, id, img, bio, cover, connects);

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(user.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
      if (kDebugMode) print(error.toString());
    });
  }

  //#endregion

  //#region Get User Data
  UserModel? userModel;

  void getUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData('userId'))
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(GetUserDataSuccessState());
      getPosts();
      getProfilePosts();
      getAllUsers();
      getConnections();
      getNotifications();
    }).catchError((error) {
      if (kDebugMode) print(error);
      emit(GetUserDataErrorState());
    });

  }

  Future<void> getUserDataRefresh() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData('userId'))
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      if (kDebugMode) print(error);
      emit(GetUserDataErrorState());
    });
  }

  //#endregion

  //#region Update Profile
  File? image;
  File? cover;

  void changeImageState() {
    emit(ChangeImage());
  }

  // Updates User Profile Picture
  void updateProfile() {
    emit(StoreImageLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(image!.path).pathSegments.last}')
        .putFile(image!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        userModel!.image = value;
        FirebaseFirestore.instance
            .collection('users')
            .doc(userModel!.id)
            .update(userModel!.toMap())
            .then((value) {
          Fluttertoast.showToast(
              msg: 'Profile Picture Updated Successfully',
              backgroundColor: Colors.green,
              textColor: Colors.white);
          image = null;
        });
      });
      emit(StoreImageSuccessState());
    }).catchError((error) {
      if (kDebugMode) print(error.toString());

      emit(StoreImageErrorState());
    });
  }

  void updateCover() {
    emit(StoreCoverLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(cover!.path).pathSegments.last}')
        .putFile(cover!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        userModel!.cover = value;
        FirebaseFirestore.instance
            .collection('users')
            .doc(userModel!.id)
            .update(userModel!.toMap())
            .then((value) {
          Fluttertoast.showToast(
              msg: 'Cover Updated Successfully',
              backgroundColor: Colors.green,
              textColor: Colors.white);
          image = null;
        });
      });
      emit(StoreImageSuccessState());
    }).catchError((error) {
      if (kDebugMode) print(error.toString());

      emit(StoreImageErrorState());
    });
  }

  // Updates User Information
  void updateUserProfile({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UpdateUserProfileLoadingState());

    userModel!.name = name;
    userModel!.phone = phone;
    userModel!.bio = bio;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.id)
        .update(userModel!.toMap())
        .then((value) {
      Fluttertoast.showToast(
        msg: 'Updated Successfully',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
      );
      image = null;
      cover = null;

      emit(UpdateUserProfileSuccessState());
    }).catchError((error) {
      if (kDebugMode) print(error.toString());
      Fluttertoast.showToast(
        msg: error.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
      );
      emit(UpdateUserProfileErrorState());
    });
  }

  //#endregion

  //#region Create Post
  File? postImage;

  void addPostImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      postImage = File(value!.path);
      emit(ChangeImage());
    });
  }

  PostModel? postModel;

  void createPost({
    required String text,
    required BuildContext context,
  }) {
    emit(CreatePostLoadingState());
    postModel = PostModel(
      uid: userModel!.id,
      name: userModel!.name,
      text: text,
      profilePicture: userModel!.image,
    );

    if (createdTags.length != 0) {
      postModel?.tags = createdTags;
    }


    if (postImage != null) {
      FirebaseStorage.instance
          .ref()
          .child('postsImage/${Uri.file(postImage!.path).pathSegments.last}')
          .putFile(postImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          postModel?.postImage = value;
          FirebaseFirestore.instance
              .collection('posts')
              .add(postModel!.toMap())
              .then((value) {
                FirebaseFirestore.instance.collection('users').doc(userModel?.id)
                .collection('posts')
                .doc(value.id)
                .set({'post' : value});
            postImage = null;
            postModel?.postId = value.id;

            FirebaseFirestore.instance
                .collection('posts')
                .doc(value.id)
                .update(postModel!.toMap());
            getPosts();
            getProfilePosts();
            Fluttertoast.showToast(
              msg: 'Post Created.',
              backgroundColor: Colors.green,
              fontSize: 14.sp,
            );
            Navigator.pop(context);
            emit(CreatePostSuccessState());
          }).catchError((error) {
            errorMsg(error);
            emit(CreatePostErrorState());
          });
        }).catchError((error) {
          errorMsg(error.toString());
          emit(CreatePostErrorState());
        });
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: error.toString(), backgroundColor: Colors.red);
        emit(CreatePostErrorState());
      });
    }
    else
      {
        FirebaseFirestore.instance
            .collection('posts')
            .add(postModel!.toMap())
            .then((value) {
          FirebaseFirestore.instance.collection('users').doc(userModel?.id)
              .collection('posts')
              .doc(value.id)
              .set({'post' : value});
          postImage = null;
          postModel?.postId = value.id;
          FirebaseFirestore.instance
              .collection('posts')
              .doc(value.id)
              .update(postModel!.toMap()).then((value) {
            getPosts();
            getProfilePosts();
            Fluttertoast.showToast(
              msg: 'Post Created.',
              backgroundColor: Colors.green,
              fontSize: 14.sp,
            );
            Navigator.pop(context);
            emit(CreatePostSuccessState());
          });

        }).catchError((error) {
          errorMsg(error);
          emit(CreatePostErrorState());
        });
      }
  }

  String dateFormat(DateTime date) {
    Map<int, String> months = {
      1: 'Jun',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };
    String period = date.hour < 12 ? 'AM' : 'PM';
    int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    hour++;
    String hour_ = hour.toString();
    String minutes = date.minute.toString();

    if (hour_.length == 1) hour_ = '0' + hour_;

    if (minutes.length == 1) minutes = '0' + minutes;

    return '${months[date.month]} ${date.day}, ${date.year} at ${hour_}:${minutes} ${period}';
  }

  List createdTags = [];

  void addTag(String tag) {
    if (tag.isNotEmpty && tag[0] == '#') tag = tag.substring(1);

    tag = tag.replaceAll(RegExp('[^A-Za-z0-9]'), '_');

    createdTags.add(tag);

    emit(CreateTagState());
  }

  //#endregion

  //#region Bottom Nav Bar Section
  List<BottomNavigationBarItem> navItems = [
    BottomNavigationBarItem(
        icon: FaIcon(
          FontAwesomeIcons.newspaper,
        ),
        label: 'News Feed',
    ),
    BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.chat_bubble_2,
        ),
        label: 'Chats'),
    BottomNavigationBarItem(
        icon: Icon(
          MyIcons.users,
        ),
        label: 'Connections'),
    BottomNavigationBarItem(
        icon: Icon(
          MyIcons.user_1,
        ),
        label: 'Profile'),
  ];

  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeNavIndex());
  }

  List<Widget> screens = [
    NewsFeed(),
    Chats(),
    Connections(),
    Profile(),
  ];
  List<String> titles = [
    'News Feed',
    'Chats',
    'Connections',
    'Profile',
  ];

//#endregion

  //#region Get Posts
  List<PostModel> posts = [];

  void getPosts() {
    emit(GetPostsLoadingState());
    posts = [];
    List<String> connectionIds = [];
    
    FirebaseFirestore.instance.collection('users')
    .doc(CacheHelper.getData('userId'))
    .collection('connections')
    .get()
    .then((value) {
      value.docs.forEach((doc) {
        connectionIds.add(doc.id);
      });

      FirebaseFirestore.instance.collection('posts')
          .orderBy('dateTime', descending: true)
          .get().then((value) {
        value.docs.forEach((doc) {
          if(connectionIds.contains(doc.data()['uid']))
            posts.add(PostModel.fromJson(doc.data()));
        });
        emit(GetPostsSuccessState());
      }).catchError((error) {
        errorMsg(error.toString());
        emit(GetUserDataErrorState());
      });

    });

    
  }

  List<PostModel> profilePosts = [];

  void getProfilePosts() {
    emit(GetProfilePostsLoadingState());

    profilePosts = [];
    FirebaseFirestore.instance
    .collection('users')
    .doc(CacheHelper.getData('userId'))
    .collection('posts')
    .get()
    .then((value) {
      value.docs.forEach((doc) {
       DocumentReference docRef = doc.data()['post'];
       docRef.get().then((value) {
         profilePosts.add(PostModel.fromJson(value.data() as Map<String, dynamic>));
         emit(GetProfilePostsState());
       });
      });
    })
    .catchError((error){
      errorMsg(error.toString());
      emit(GetPostsErrorState());
    });
  }

  List<PostModel> userPosts = [];

  void getUserPosts(UserModel user) {
    emit(GetProfilePostsLoadingState());

    userPosts = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .collection('posts')
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        DocumentReference docRef = doc.data()['post'];
        docRef.get().then((value) {
          userPosts.add(PostModel.fromJson(value.data() as Map<String, dynamic>));
          emit(GetProfilePostsState());
        });
      });
    })
        .catchError((error){
      errorMsg(error.toString());
      emit(GetPostsErrorState());
    }).whenComplete(() {
      emit(GetProfilePostsState());
    });
  }

//#endregion

  //#region Delete a Post

  void deletePost(PostModel post)
  {
    FirebaseFirestore.instance.collection('posts')
        .doc(post.postId)
        .delete().then((value) {
          getProfilePosts();
    });
  }

  //#endregion

  //#region Love a Post
  void love(PostModel post) {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userModel?.id);
    final postDocRef =
        FirebaseFirestore.instance.collection('posts').doc(post.postId);

    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .collection('loves')
        .doc(userModel?.id)
        .set({'user': userDocRef}).then((value) {
      post.numOfLikes++;
      emit(LovePostSuccessState());

      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.postId)
          .update(post.toMap());

      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.id)
          .collection('loves')
          .doc(post.postId)
          .set({'post': postDocRef, 'love' : true});
    }).catchError((error) {
      errorMsg(error.toString());
      emit(LovePostErrorState());
    });
  }

  Future<bool> isLoved(PostModel post) async
  {
    return await FirebaseFirestore.instance.collection('users').doc(userModel?.id)
        .collection('loves')
        .doc(post.postId)
        .get()
        .then((value) {
          return value.data()?['love'] ?? false;
    });

  }


//#endregion

  //#region Love Withdraw

  void loveWithdrawal(PostModel post) {
    post.numOfLikes--;

    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .update(post.toMap()).then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userModel?.id)
              .collection('loves')
              .doc(post.postId).delete().then((value) {
                emit(LoveWithdrawalSuccessState());

                FirebaseFirestore.instance
                .collection('posts')
                .doc(post.postId)
                .collection('loves')
                .doc(userModel?.id).delete();
          });
    }).catchError((error){
      errorMsg(error.toString());
      emit(LoveWithdrawalErrorState());
    });


  }    

  //#endregion

  //#region Post&Get Comments

  void comment(PostModel post, String commentText)
  {
    CommentModel comment = CommentModel(comment: commentText, user: userModel!);
    post.numOfComments++;
    FirebaseFirestore.instance
    .collection('posts')
    .doc(post.postId)
    .update(post.toMap()).then((value) { emit(UpdateNumOfCommentsSuccessState()); })
    .catchError((error){
      errorMsg(error.toString());
      emit(UpdateNumOfCommentsErrorState());
    });

    FirebaseFirestore.instance
    .collection('posts')
    .doc(post.postId)
    .collection('comments')
    .add(comment.toMap())
    .then((value) {
      getComments(post);
      emit(PostCommentSuccessState());
    })
    .catchError((error){
      errorMsg(error.toString());
      emit(PostCommentErrorState());
    });
  }

  List<CommentModel> comments = [];

  getComments(PostModel post) async
  {
    emit(GetCommentsLoadingState());

    comments = [];

    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .collection('comments')
        .get()
        .then((value) {
          value.docs.forEach((doc) async {
            DocumentReference docRef = doc['user'];
            var value = await docRef.get();
            comments.add(CommentModel.fromJson(doc.data(), UserModel.fromJson(value.data() as Map<String, dynamic>)));
            emit(GetCommentsSuccessState());
          });
    })
        .catchError((error){
          errorMsg(error.toString());
          emit(GetCommentsErrorState());
    }).whenComplete(() => emit(GetCommentsLoadingEndState()));
  }

  void changeCommentImageState()
  {
    emit(ChangeCommentImageState());
  }

  //#endregion

  //#region Get All Users

  List<UserModel> allUsers = [];

  //This function get the not connected users.
  void getAllUsers()
  {
    emit(GetAllUsersLoadingState());

    allUsers = [];

    List<String> connectionIds = [];

    FirebaseFirestore.instance.collection('users')
        .doc(CacheHelper.getData('userId'))
        .collection('connections')
        .get()
        .then((value) {
      value.docs.forEach((doc) {
        connectionIds.add(doc.id);
      });

      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((doc) {
          if(! connectionIds.contains(doc.data()['id']) && doc.data()['id'] != CacheHelper.getData('userId'))
            allUsers.add(UserModel.fromJson(doc.data()));
        });
        emit(GetAllUsersSuccessState());
      })
          .catchError((error){
        errorMsg(error.toString());
        emit(GetAllUsersErrorState());
      });

    });



  }

  //#endregion

  //#region Emojis Section

  bool emojiIsNotVisible = true;
  void changeEmojiVisibility()
  {
    emojiIsNotVisible = !emojiIsNotVisible;
    emit(ChangeEmojiVisibility());
  }

  //#endregion

  //#region Messages Section

  void sendMessage(String message, String receiverId)
  {
    String userId = CacheHelper.getData('userId');
    DocumentReference sender = FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentReference receiver = FirebaseFirestore.instance.collection('users').doc(receiverId);
    final now = FieldValue.serverTimestamp();

    sender.collection('connections')
    .doc(receiverId)
    .collection('messages')
    .add({
      'message' : message,
      'senderId' : userId,
      'DateTime': now,
    }).then((value) {
      emit(SendMessageSuccessState());
    })
    .catchError((error){
      errorMsg(error.toString());
      emit(SendMessageErrorState());
    });

    receiver.collection('connections')
    .doc(userId)
    .collection('messages')
    .add({
      'message' : message,
      'senderId' : userId,
      'DateTime': now,
    })
    .then((value) {
      emit(SendMessageSuccessState());
    })
    .catchError((error){
      errorMsg(error.toString());
      emit(SendMessageErrorState());
    });
  }

  List<Message> messages = [];
  void getMessages(String receiverId)
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData('userId'))
        .collection('connections')
        .doc(receiverId)
        .collection('messages')
        .orderBy('DateTime')
        .snapshots()
        .listen((event) {
          messages = [];

          event.docs.forEach((doc) {
            messages.add(Message.fromJson(doc.data()));
          });

          emit(GetMessagesState());
    });
  }

  //#endregion

  //# region Sign out

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    CacheHelper.removeData('userId');
  }

  //#endregion

  //#region Connections & Notifications
  // Check the existence of a connection
  Future<bool> isConnectionExists(UserModel user) async
  {
    final collection = FirebaseFirestore.instance.collection('users')
    .doc(CacheHelper.getData('userId')).collection('connections');
    final documentSnapshot = await collection.doc(user.id).get();

    return documentSnapshot.exists;
  }

  void sendConnectionRequest(UserModel userToConnect)
  {
    NotificationModel notification = NotificationModel(
      type: 'connection_request',
      user: userModel!,
    );
    
    Map<String, dynamic> data = notification.toMap();
    
    FirebaseFirestore.instance.collection('users')
        .doc(userToConnect.id)
        .collection('notifications')
        .add(data).then((value) {
          data.addAll({'id' : value.id});
          FirebaseFirestore.instance.collection('users')
              .doc(userToConnect.id)
              .collection('notifications')
              .doc(value.id)
              .update(data);
    });
  }

  List<NotificationModel> notifications = [];

  void getNotifications()
  {
    emit(GetNotificationsLoadingState());

    FirebaseFirestore.instance.collection('users')
        .doc(userModel?.id)
        .collection('notifications')
        .snapshots()
        .listen((event) {
          notifications = [];
          event.docs.forEach((doc) {
            doc.data()['user'].get().then((value) {
              notifications.add(NotificationModel.fromJson(doc.data(), UserModel.fromJson(value.data())));
              emit(GetNotificationsSuccessState());
            });
          });

    });

  }

  void rejectConnection(NotificationModel notification, int index)
  {
    notifications.removeAt(index);
    emit(RejectNotificationState());

    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.id)
        .collection('notifications')
        .doc(notification.id).delete().then((value) {
          emit(RejectNotificationState());
          errorMsg("Connection Request Was Rejected");
    });
  }

  void markAsRead(NotificationModel notification, int index)
  {
    notifications.removeAt(index);
    FirebaseFirestore.instance.collection('users')
        .doc(CacheHelper.getData('userId'))
        .collection('notifications')
        .doc(notification.id).delete().then((value) {
          emit(RejectNotificationState());
    });

  }
  
  void acceptConnection(NotificationModel notification, int index)
  {
    emit(AcceptConnectionLoadingState());

    // First, add the user who sent the connection to me
    FirebaseFirestore.instance.collection('users')
        .doc(userModel!.id)
        .collection('connections')
        .doc(notification.user?.id)
        .set(
        {'user' : FirebaseFirestore.instance.collection('users')
            .doc(notification.user?.id)}, SetOptions(merge: true))
        .then((value) {
          // Second, add me to the user who sent the connection
          FirebaseFirestore.instance.collection('users')
              .doc(notification.user?.id)
              .collection('connections')
              .doc(userModel!.id)
              .set({'user' : FirebaseFirestore.instance
              .collection('users').doc(userModel!.id)}, SetOptions(merge: true)).then((value) {
                // Third, I need to send a notification to the user
                // To notify him/her that I accepted the request.
                NotificationModel acceptNotification = NotificationModel(
                    type: "connection_accept",
                    user: userModel!,
                );
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(notification.user?.id)
                    .collection('notifications')
                    .add(acceptNotification.toMap()).then((value) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(notification.user?.id)
                          .collection('notifications')
                          .doc(value.id)
                          .update({'id' : value.id}).then((value) {
                            // Now, Lets increment the number of connection
                            // for both of us
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(notification.user?.id)
                                .update({'numOfConnects' : FieldValue.increment(1)})
                                .then((value) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userModel!.id)
                                      .update({'numOfConnects' : FieldValue.increment(1)})
                                      .then((value) {
                                        emit(AcceptConnectionSuccessState());
                                        msg("Now, You Are Friends!");
                                        getConnections();
                                        getAllUsers();
                                        getPosts();
                                        // Finally, the notification
                                        // Needs to be removed
                                        notifications.removeAt(index);
                                        emit(AcceptConnectionSuccessState());

                                        FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userModel!.id)
                                        .collection('notifications')
                                        .doc(notification.id).delete().then((value) {
                                          emit(AcceptConnectionSuccessState());
                                        });
                                  })
                                      .catchError((error){
                                        if (kDebugMode) print("1 " + error.toString());
                                        errorMsg(error.toString());
                                        emit(AcceptConnectionErrorState());
                                  });
                            })
                                .catchError((error) {
                              if (kDebugMode) print("2 " + error.toString());
                                  errorMsg(error.toString());
                                  emit(AcceptConnectionErrorState());
                            });
                      }).catchError((error){
                        if (kDebugMode) print("3 " + error.toString());
                        errorMsg(error.toString());
                        emit(AcceptConnectionErrorState());
                      });
                })
                .catchError((error) {
                  if (kDebugMode) print("4 " + error.toString());
                  errorMsg(error.toString());
                  emit(AcceptConnectionErrorState());
                });
          })
              .catchError((error) {
                if (kDebugMode) print("5 " + error.toString());
                errorMsg(error.toString());
                emit(AcceptConnectionErrorState());
              });
    })
        .catchError((error) {
          if (kDebugMode) print("6 " + error.toString());
          errorMsg(error.toString());
          emit(AcceptConnectionErrorState());
    });

  }
  //#endregion

  //#region Get Connections
  List<UserModel> myConnections = [];
  void getConnections()
  {
    myConnections = [];
    FirebaseFirestore.instance.collection('users')
        .doc(CacheHelper.getData('userId'))
        .collection('connections')
        .get()
        .then((value) {
          value.docs.forEach((doc) {
            doc.data()['user'].get().then((value) {
              myConnections.add(UserModel.fromJson(value.data()));
              emit(GetConnectionsSuccessState());
            });
          });
    })
        .catchError((error) {
          errorMsg(error.toString());
          emit(GetConnectionsErrorState());
    });
  }

  //#endregion

  //#region Dark Mode

  bool isDark = CacheHelper.getData('isDark') ?? false;

  void changeThemeMode(bool modeState) {
    isDark = modeState;
    CacheHelper.putBool('isDark', modeState);
    emit(ChangeThemeMode());
  }

  //#endregion

  //#region Search

  String name = "";

  void changeName(String value)
  {
    name = value;
    emit(OnChangeSearch());
  }

String nameChat = "";

  void changeNameChat(String value)
  {
    nameChat = value;
    emit(OnChangeSearch());
  }


  //#endregion

}
