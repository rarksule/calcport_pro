import 'package:mobx/mobx.dart';

class TokensListModel {
  ObservableList<TokenModel> data;

  TokensListModel({required this.data});

  factory TokensListModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map<TokenModel>((e) => TokenModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return TokensListModel(
      data: ObservableList<TokenModel>.of(list),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class TokenModel {
  String value;
  DateTime expireTime;
  String id;
  Observable<bool> _used = Observable(false);
  DateTime? usedAt;

  TokenModel({
    required this.value,
    required this.expireTime,
    required this.id,
    DateTime? usedAt,
    bool used = false,
  }) {
    _used.value = used;
  }

  // Getter
  bool get used => _used.value;

  // Setter (action)
  set used(bool value) {
    Action(() {
      _used.value = value;
      usedAt = DateTime.now();
    })();
  }


  bool get isActive => !_used.value && DateTime.now().isBefore(expireTime);

  // JSON
  static TokenModel fromJson(Map<String, dynamic> json) {
    return TokenModel(
      value: json['value'] as String,
      expireTime: DateTime.parse(json['expireTime'] as String),
      id: json['id'] as String,
      usedAt: json['usedAt'] != null
          ? DateTime.parse(json['usedAt'] as String)
          : null,
      used: json['used'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "used": _used.value,
      "value": value,
      "expireTime": expireTime.toIso8601String(),
      "id": id,
      "usedAt": usedAt?.toIso8601String(),
    };
  }
}
