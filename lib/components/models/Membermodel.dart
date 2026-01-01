
class MemberModel {
  String name;
  String imageUrl;
  bool isSelected;

  MemberModel({
    required this.name,
    required this.imageUrl,
    this.isSelected = false,
  });

  // Useful for cloning
  MemberModel copy() {
    return MemberModel(
      name: name,
      imageUrl: imageUrl,
      isSelected: isSelected,
    );
  }

  // For saving to JSON (future backend)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "imageUrl": imageUrl,
      "isSelected": isSelected,
    };
  }

  // From JSON
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      name: json["name"],
      imageUrl: json["imageUrl"],
      isSelected: json["isSelected"] ?? false,
    );
  }
}
