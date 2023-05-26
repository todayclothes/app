class Clothes {
  List<ClothesItem> morningTop;
  List<ClothesItem> afternoonTop;
  List<ClothesItem> nightTop;
  List<ClothesItem> morningBottom;
  List<ClothesItem> afternoonBottom;
  List<ClothesItem> nightBottom;

  Clothes(
      {required this.morningTop,
      required this.nightTop,
      required this.afternoonTop,
      required this.afternoonBottom,
      required this.morningBottom,
      required this.nightBottom});
}

class ClothesItem {
  int id;
  String imgUrl;
  String itemUrl;
  int clothesGroupId;

  ClothesItem(
      {required this.id,
      required this.imgUrl,
      required this.itemUrl,
      required this.clothesGroupId});
}

Clothes parseClothesData(Map<String, dynamic> jsonData) {

  List<dynamic> morningTopData = jsonData['morning']['clothes']['top'];
  List<dynamic> afternoonTopData = jsonData['afternoon']['clothes']['top'];
  List<dynamic> nightTopData = jsonData['night']['clothes']['top'];
  List<dynamic> morningBottomData = jsonData['morning']['clothes']['bottom'];
  List<dynamic> afternoonBottomData = jsonData['afternoon']['clothes']['bottom'];
  List<dynamic> nightBottomData = jsonData['night']['clothes']['bottom'];


  List<ClothesItem> morningTopList = morningTopData.map((item) {
    return ClothesItem(
      id: item['id'],
      imgUrl: item['imgUrl'],
      itemUrl: item['itemUrl'],
      clothesGroupId: item['clothesGroupId'],
    );
  }).toList();

  List<ClothesItem> afternoonTopList = afternoonTopData.map((item) {
    return ClothesItem(
      id: item['id'],
      imgUrl: item['imgUrl'],
      itemUrl: item['itemUrl'],
      clothesGroupId: item['clothesGroupId'],
    );
  }).toList();

  List<ClothesItem> nightTopList = nightTopData.map((item) {
    return ClothesItem(
      id: item['id'],
      imgUrl: item['imgUrl'],
      itemUrl: item['itemUrl'],
      clothesGroupId: item['clothesGroupId'],
    );
  }).toList();

  List<ClothesItem> morningBottomList = morningBottomData.map((item) {
    return ClothesItem(
      id: item['id'],
      imgUrl: item['imgUrl'],
      itemUrl: item['itemUrl'],
      clothesGroupId: item['clothesGroupId'],
    );
  }).toList();

  List<ClothesItem> afternoonBottomList = afternoonBottomData.map((item) {
    return ClothesItem(
      id: item['id'],
      imgUrl: item['imgUrl'],
      itemUrl: item['itemUrl'],
      clothesGroupId: item['clothesGroupId'],
    );
  }).toList();

  List<ClothesItem> nightBottomList = nightBottomData.map((item) {
    return ClothesItem(
      id: item['id'],
      imgUrl: item['imgUrl'],
      itemUrl: item['itemUrl'],
      clothesGroupId: item['clothesGroupId'],
    );
  }).toList();

  return Clothes(
      morningTop: morningTopList,
      nightTop: nightTopList,
      afternoonTop: afternoonTopList,
      afternoonBottom: afternoonBottomList,
      morningBottom: morningBottomList,
      nightBottom: nightBottomList);
}
