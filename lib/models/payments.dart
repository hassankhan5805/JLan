class payments {
  String? date;
  String? photoURL;
  String? amount;
  String? payID;
  String? isApproved;

  payments(
      {this.date, this.photoURL, this.amount, this.payID, this.isApproved});

  payments.fromJson(Map<String, dynamic> json) {
    date = json['date'] ?? "";
    photoURL = json['photoURL'] ?? "";
    amount = json['amount'] ?? "";
    payID = json['payID'] ?? "";
    isApproved = json['isApproved'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['photoURL'] = this.photoURL;
    data['amount'] = this.amount;
    data['payID'] = this.payID;
    data['isApproved'] = this.isApproved;
    return data;
  }
}
