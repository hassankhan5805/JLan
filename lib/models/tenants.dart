class tenants {
  String? profileURL;
  String? apartmentID;
  String? balance;
  String? name;
  String? id;
  String? email;

  tenants(
      {this.profileURL,
      this.apartmentID,
      this.balance,
      this.name,
      this.id,
      this.email});

  tenants.fromJson(Map<String, dynamic> json) {
    profileURL = json['profileURL'];
    apartmentID = json['apartmentID'];
    balance = json['balance'];
    name = json['name'];
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileURL'] = this.profileURL;
    data['apartmentID'] = this.apartmentID;
    data['balance'] = this.balance;
    data['name'] = this.name;
    data['id'] = this.id;
    data['email'] = this.email;
    return data;
  }
}
