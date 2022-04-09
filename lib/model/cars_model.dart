class CarsModel {
  late String make;
  late List<Brand> brand;

  CarsModel({required this.make, required this.brand});

  CarsModel.fromJSON(Map<String, dynamic> json) {
    make = json['make'];
    brand = json['brand'].map<Brand>((json) => Brand.fromJSON(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['make'] = this.make;
    data['brand'] = this.brand;
    return data;
  }
}

class Brand {
  late String name;
  late String category;

  Brand({required this.name, required this.category});

  Brand.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['category'] = this.category;

    return data;
  }
}
