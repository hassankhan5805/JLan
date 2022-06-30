class tenants {
  String? profileURL;
  String? apartmentID;
  String? balance;
  String? name;
  String? id;
  String? email;
  String? notes;
  DateTime? registerOn;

  tenants(
      {this.profileURL,
      this.apartmentID,
      this.balance,
      this.name,
      this.id,
      this.notes,
      this.registerOn,
      this.email});

  tenants.fromJson(Map<String, dynamic> json) {
    profileURL = json['profileURL'];
    apartmentID = json['apartmentID'];
    balance = json['balance'];
    name = json['name'];
    id = json['id'];
    notes = json['notes'];
    registerOn = json['registerOn'].toDate() ?? DateTime.now();
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileURL'] = this.profileURL;
    data['apartmentID'] = this.apartmentID;
    data['balance'] = this.balance;
    data['name'] = this.name;
    data['registerOn'] = this.registerOn;
    data['id'] = this.id;
    data['notes'] = this.notes;
    data['email'] = this.email;
    return data;
  }
}
