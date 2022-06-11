class apartment {
  String? period;
  String? id;
  String? incremental;
  String? rent;

  apartment({this.period, this.id, this.incremental, this.rent});

  apartment.fromJson(Map<String, dynamic> json) {
    period = json['period'] ?? '';
    id = json['id'] ?? "";
    incremental = json['incremental'] ?? "";
    rent = json['rent'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['period'] = this.period;
    data['id'] = this.id;
    data['incremental'] = this.incremental;
    data['rent'] = this.rent;
    return data;
  }
}
