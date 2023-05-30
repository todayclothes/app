class ClothesChoice {
  final int id;
  final int memberId;
  final String date;
  final double tempAvg;
  final String plan;
  final ClothingChoice topChoice;
  final ClothingChoice bottomChoice;
  final int likeId;
  late bool isLiked; // 좋아요 상태


  ClothesChoice({
    required this.id,
    required this.memberId,
    required this.date,
    required this.tempAvg,
    required this.plan,
    required this.topChoice,
    required this.bottomChoice,
    required this. likeId,
    this.isLiked = false, // 초기값은 좋아요되지 않은 상태로 설정
  });

  factory ClothesChoice.fromJson(Map<String, dynamic> json) {
    return ClothesChoice(
      id: json['id'],
      memberId: json['memberId'],
      date: json['date'],
      tempAvg: json['tempAvg'],
      plan: json['plan'],
      topChoice: ClothingChoice.fromJson(json['topChoice']),
      bottomChoice: ClothingChoice.fromJson(json['bottomChoice']),
      likeId: json['likeId'],
      isLiked: json['isLiked'] ?? false, // JSON 데이터에서 좋아요 상태를 가져옴
    );
  }
}

class ClothingChoice {
  final int id;
  final String imgUrl;
  final String itemUrl;

  ClothingChoice({
    required this.id,
    required this.imgUrl,
    required this.itemUrl,
  });

  factory ClothingChoice.fromJson(Map<String, dynamic> json) {
    return ClothingChoice(
      id: json['id'],
      imgUrl: json['imgUrl'],
      itemUrl: json['itemUrl'],
    );
  }
}
