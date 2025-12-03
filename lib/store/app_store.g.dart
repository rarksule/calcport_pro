// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  late final _$tokensLengthAtom =
      Atom(name: '_AppStore.tokensLength', context: context);

  @override
  int get tokensLength {
    _$tokensLengthAtom.reportRead();
    return super.tokensLength;
  }

  @override
  set tokensLength(int value) {
    _$tokensLengthAtom.reportWrite(value, super.tokensLength, () {
      super.tokensLength = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$requestsCountAtom =
      Atom(name: '_AppStore.requestsCount', context: context);

  @override
  RequestCountModel get requestsCount {
    _$requestsCountAtom.reportRead();
    return super.requestsCount;
  }

  @override
  set requestsCount(RequestCountModel value) {
    _$requestsCountAtom.reportWrite(value, super.requestsCount, () {
      super.requestsCount = value;
    });
  }

  late final _$addTokenAsyncAction =
      AsyncAction('_AppStore.addToken', context: context);

  @override
  Future<void> addToken(TokenModel val) {
    return _$addTokenAsyncAction.run(() => super.addToken(val));
  }

  late final _$tokenChangedAsyncAction =
      AsyncAction('_AppStore.tokenChanged', context: context);

  @override
  Future<void> tokenChanged() {
    return _$tokenChangedAsyncAction.run(() => super.tokenChanged());
  }

  late final _$removeTokenAsyncAction =
      AsyncAction('_AppStore.removeToken', context: context);

  @override
  Future<void> removeToken(TokenModel val) {
    return _$removeTokenAsyncAction.run(() => super.removeToken(val));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void requestChanged(RequestType type, [dynamic isAdd = true]) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.requestChanged');
    try {
      return super.requestChanged(type, isAdd);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tokensLength: ${tokensLength},
isLoading: ${isLoading},
requestsCount: ${requestsCount}
    ''';
  }
}
