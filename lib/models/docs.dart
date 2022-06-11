class docs {
  String? name;
  String? docURL;
  String? docID;

  docs({this.name, this.docURL,this.docID});

  docs.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    docURL = json['docURL'];
    docID = json['docID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['docID'] = this.docID;
    data['docURL'] = this.docURL;
    return data;
  }
}
