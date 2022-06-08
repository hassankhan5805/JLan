import 'dart:io';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? github;
  bool? isDesigner;
  bool? isStudent;
  String? linkedin;
  File? imageFile;
  String? idea;
  Institute? institute;
  String? photoURL;
  String? token;
  List<String>? languagesOrTools;
  List<String>? matches;
  List<String>? swipe;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.github,
      this.isDesigner,
      this.isStudent,
      this.linkedin,
      this.idea,
      this.matches,
      this.institute,
      this.photoURL,
      this.token,
      this.languagesOrTools,
      this.swipe});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    name = json['name'] ?? null;
    email = json['email'] ?? null;
    matches = json['matches'] == null ? null : json['matches'].cast<String>();
    swipe = json['swipe'] == null ? null : json['swipe'].cast<String>();
    github = json['github'] ?? null;
    isDesigner = json['isDesigner'] ?? null;
    isStudent = json['isStudent'] ?? null;
    linkedin = json['linkedin'] ?? null;
    idea = json['idea'] ?? null;
    institute = json['education'] != null
        ? new Institute.fromJson(json['education'])
        : null;
    photoURL = json['photoURL'] ?? null;
    token = json['token'] ?? null;
    languagesOrTools =
        json['languages'] == null ? null : json['languages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['matches'] = this.matches;
    data['github'] = this.github;
    data['isDesigner'] = this.isDesigner;
    data['isStudent'] = this.isStudent;
    data['linkedin'] = this.linkedin;
    data['idea'] = this.idea;
    if (this.institute != null) {
      data['education'] = this.institute!.toJson();
    }

    data['photoURL'] = this.photoURL;
    data['token'] = this.token;
    data['languages'] = this.languagesOrTools;
    data['swipe'] = this.swipe;
    return data;
  }
}

class Institute {
  String? name;
  String? address;

  Institute({this.name, this.address});

  Institute.fromJson(Map<String, dynamic> json) {
    name = json['institute'] != null ? json['institute'] : null;
    address = json['address'] != null ? json['address'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['institute'] = this.name;
    data['address'] = this.address;
    return data;
  }
}
