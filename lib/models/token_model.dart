import '../main.dart';

class TokensListModel {
  Set<TokenModel> data;

  TokensListModel({required this.data});

  factory TokensListModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map<TokenModel>((e) => TokenModel.fromJson(e as Map<String, dynamic>))
        .toList()
        .toSet();
    return TokensListModel(
      data: Set<TokenModel>.of(list),
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
  bool _used = false;
  DateTime? usedAt;

  TokenModel({
    required this.value,
    required this.expireTime,
    required this.id,
    this.usedAt,
  });

  // Getter
  bool get used => _used;

  // Setter (action)
  set used(bool value) {
    _used = value;
    usedAt = DateTime.now();
    state.tokenChanged();
  }

  bool get isActive => !_used && DateTime.now().isBefore(expireTime);

  // JSON
  static TokenModel fromJson(Map<String, dynamic> json) {
    final mdl = TokenModel(
      value: json['value'] as String,
      expireTime: DateTime.parse(json['expireTime'] as String),
      id: json['id'] as String,
      usedAt: json['usedAt'] != null
          ? DateTime.parse(json['usedAt'] as String)
          : null,
    );
    mdl.used = json['used'] ?? false;
    return mdl;
  }

  Map<String, dynamic> toJson() {
    return {
      "used": _used,
      "value": value,
      "expireTime": expireTime.toIso8601String(),
      "id": id,
      "usedAt": usedAt?.toIso8601String(),
    };
  }

// needed to keep uniqu
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenModel &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
