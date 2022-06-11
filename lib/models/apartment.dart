class apartment {
  String? period;
  String? id;
  String? incremental;
  String? rent;
  String? occupiedBy;

  apartment(
      {this.period, this.id, this.incremental, this.rent, this.occupiedBy});

  apartment.fromJson(Map<String, dynamic> json) {
    period = json['period'] ?? '';
    id = json['id'] ?? "";
    incremental = json['incremental'] ?? "";
    occupiedBy = json['occupiedBy'] ?? "";
    rent = json['rent'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['period'] = this.period;
    data['id'] = this.id;
    data['incremental'] = this.incremental;
    data['occupiedBy'] = this.occupiedBy;
    data['rent'] = this.rent;
    return data;
  }
}
