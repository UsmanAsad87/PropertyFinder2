class AdModel {
  final String description;
  final String title;
  final String uid;
  final String adId;
  final String username;
  final datePublished;
  final String adImageUrl;
  final String resOrComm;
  final String area;
  final String city;
  final String price;
  final String purpose;
  final String address;
  final bool isReported;
  final String reportReason;

  AdModel({
    required this.title,
    required this.uid,
    required this.adId,
    required this.username,
    required this.datePublished,
    required this.adImageUrl,
    required this.resOrComm,
    required this.area,
    required this.city,
    required this.price,
    required this.description,
    required this.purpose,
    required this.address,
    required this.isReported,
    required this.reportReason,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "title": title,
        "uid": uid,
        "username": username,
        "adId": adId,
        "datePublished": datePublished,
        "adImageUrl": adImageUrl,
        "area": area,
        "city": city,
        "price": price,
        "resOrCom": resOrComm,
        "purpose": purpose,
        "address": address,
        "isReported": isReported,
        "reportReason": reportReason
      };

  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      uid: map['uid'] ?? '',
      adId: map['adId'] ?? '',
      username: map['username'] ?? '',
      adImageUrl: map['adImageUrl'] ?? '',
      resOrComm: map['resOrCom'] ?? "",
      area: map['area'] ?? '',
      city: map['city'] ?? '',
      price: map['price'] ?? '',
      description: map['description'] ?? '',
      title: map['title'] ?? '',
      datePublished: map['datePublished'] ?? '',
      purpose: map['purpose'] ?? '',
      address: map['address'] ?? '',
      isReported: map['isReported'] ?? false,
      reportReason: map['reportReason'] ?? '',
    );
  }
}
