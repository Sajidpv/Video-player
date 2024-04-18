// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? name, email, dob, image;
  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    dob = json['dob'];
    image = json['imageLink'];
  }
}
