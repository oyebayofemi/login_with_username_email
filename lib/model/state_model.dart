class StateModel {
  String? state;
  List<String>? lga;

  StateModel({this.state, this.lga});

  StateModel.fromJson(Map<String, dynamic> json) {
    state:
    json['state'];
    lga:
    json['lga'];
  }
}
