abstract class AppStates {}

class InitialState extends AppStates {}

class ChangeVisibility extends AppStates {}
class UserRegisterSuccessState extends AppStates {}
class UserRegisterLoadingState extends AppStates {}
class UserRegisterErrorState extends AppStates {}
class UserLoginSuccessState extends AppStates {}
class UserLoginLoadingState extends AppStates {}
class UserLoginErrorState extends AppStates {
  late String error;

  UserLoginErrorState(String e)
  {
    this.error = e;
  }
}

class CreateUserSuccessState extends AppStates {}
class CreateUserLoadingState extends AppStates {}
class CreateUserErrorState extends AppStates {
  late String error;

  CreateUserErrorState(String e)
  {
    this.error = e;
  }
}

class UserDataSavedSuccessState extends AppStates {}
class UserDataSavedErrorState extends AppStates {}
class ChangeNavIndex extends AppStates {}

class ChangeImage extends AppStates {}

class GetUserDataSuccessState extends AppStates{}
class GetUserDataErrorState extends AppStates{}

class StoreImageLoadingState extends AppStates {}
class StoreImageSuccessState extends AppStates {}
class StoreImageErrorState extends AppStates {}
class StoreCoverLoadingState extends AppStates {}

class UpdateUserProfileLoadingState extends AppStates {}
class UpdateUserProfileSuccessState extends AppStates {}
class UpdateUserProfileErrorState extends AppStates {}

class CreatePostLoadingState extends AppStates {}
class CreatePostSuccessState extends AppStates {}
class CreatePostErrorState extends AppStates {}

class GetPostsLoadingState extends AppStates {}
class GetPostsSuccessState extends AppStates {}
class GetPostsErrorState extends AppStates {}

class CreateTagState extends AppStates {}

class GetProfilePostsState extends AppStates {}

class LovePostSuccessState extends AppStates {}
class LovePostErrorState extends AppStates {}

class LoveWithdrawalSuccessState extends AppStates {}
class LoveWithdrawalErrorState extends AppStates {}

class PostCommentSuccessState extends AppStates {}
class PostCommentErrorState extends AppStates {}

class UpdateNumOfCommentsSuccessState extends AppStates {}
class UpdateNumOfCommentsErrorState extends AppStates {}

class GetCommentsLoadingState extends AppStates {}
class GetCommentsSuccessState extends AppStates {}
class GetCommentsErrorState extends AppStates {}

class GetAllUsersLoadingState extends AppStates {}
class GetAllUsersSuccessState extends AppStates {}
class GetAllUsersErrorState extends AppStates {}

class ChangeEmojiVisibility extends AppStates {}

class SendMessageSuccessState extends AppStates {}
class SendMessageErrorState extends AppStates {}

class GetMessagesState extends AppStates {}

class ChangeCommentImageState extends AppStates {}
