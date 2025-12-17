import 'Membermodel.dart';

class CircleModel {
  String id;
  String name;
  bool locked;
  String? pin;
  List<MemberModel> members;

  CircleModel({
    required this.id,
    required this.name,
    this.locked = false,
    this.pin,
    required this.members,
  });

  // Clone the model safely
  CircleModel copy() {
    return CircleModel(
      id: id,
      name: name,
      locked: locked,
      pin: pin,
      members: members.map((m) => m.copy()).toList(),
    );
  }

  // For saving to backend
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "locked": locked,
      "pin": pin,
      "members": members.map((m) => m.toJson()).toList(),
    };
  }

  // Load from backend JSON
  factory CircleModel.fromJson(Map<String, dynamic> json) {
    return CircleModel(
      id: json["id"],
      name: json["name"],
      locked: json["locked"] ?? false,
      pin: json["pin"],
      members: (json["members"] as List<dynamic>)
          .map((m) => MemberModel.fromJson(m))
          .toList(),
    );
  }
}
