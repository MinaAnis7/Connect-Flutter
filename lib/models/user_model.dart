class UserModel {
  late String name;
  late String email;
  late String phone;
  late String id;
  late String image;
  late String bio;
  late String cover;
  late int numOfConnects = 0;
  bool isEmailVerified = false;

  UserModel(String name, String email, String phone, String id, String img,
      String bio, String cover, int numOfConn) {
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.id = id;
    this.image = img;
    this.bio = bio;
    this.cover = cover;
    this.numOfConnects = numOfConn;
  }

  UserModel.fromJson(Map<String, dynamic>? user) {
    this.name = user?['name'];
    this.email = user?['email'];
    this.phone = user?['phone'];
    this.id = user?['id'];
    this.isEmailVerified = user?['isEmailVerified'];
    this.image = user?['image'];
    this.bio = user?['bio'];
    this.cover = user?['cover'];
    this.numOfConnects = user?['numOfConnects'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'id': this.id,
      'isEmailVerified': this.isEmailVerified,
      'image': this.image,
      'bio': this.bio,
      'cover': this.cover,
      'numOfConnects': this.numOfConnects,
    };
  }
}
