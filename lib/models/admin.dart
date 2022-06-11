class admin {
  String? name;
  String? id;
  String? email;
  String? isAdmin;

  admin({this.name, this.id, this.email, this.isAdmin});

  admin.fromJson(Map<String, dynamic> json) {
    isAdmin = json['isAdmin'];
    name = json['name'];
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['isAdmin'] = this.isAdmin;
    data['name'] = this.name;
    data['id'] = this.id;
    data['email'] = this.email;
    return data;
  }
}
