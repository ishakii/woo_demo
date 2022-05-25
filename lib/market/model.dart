class CoinModel {
  String base;
  String quote;
  String type;
  double lastPrice;
  double volume;

  CoinModel({
    required this.base,
    required this.quote,
    required this.type,
    required this.lastPrice,
    required this.volume,
  });

  Map<String, dynamic> toMap() {
    return {
      'base': base,
      'quote': quote,
      'type': type,
      'lastPrice': lastPrice,
      'volume': volume,
    };
  }

  factory CoinModel.fromMap(Map<String, dynamic> map) {
    return CoinModel(
      base: map['base'] as String,
      quote: map['quote'] as String,
      type: map['type'] as String,
      lastPrice: double.parse(map['lastPrice'].toString()),
      volume: double.parse(map['volume'].toString()),
    );
  }
}

enum CoinTypeEnum { spot, future }

extension CoinTypeEnumExtension on CoinTypeEnum {
  String get text {
    switch (this) {
      case CoinTypeEnum.spot:
        return "SPOT";
      case CoinTypeEnum.future:
        return "FUTURES";
      default:
        throw Exception("CoinTypeEnum value exception");
    }
  }
}
