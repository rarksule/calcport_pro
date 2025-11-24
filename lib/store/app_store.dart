import '../main.dart';
import '../models/request_count_model.dart';
import 'package:mobx/mobx.dart';

import '../models/token_model.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  TokensListModel tokens =
      TokensListModel(data: ObservableList<TokenModel>.of([]));
  @observable
  bool isLoading = false;

  @observable
  RequestCountModel requestsCount = RequestCountModel(
    appt: ObservableList<int>.of([]),
    req: ObservableList<int>.of([]),
    pay: ObservableList<int>.of([]),
    img: ObservableList<int>.of([]),
  );

  @action
  Future<void> addToken(TokenModel val) async {
    for (var tkn in tokens.data) {
      if (!tkn.isActive) {
        invalidTokens.data.add(tkn);
        tokens.data.removeWhere((tk) => tk.id == tkn.id);
      }
    }
    tokens.data.add(val);
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  void removeToken(TokenModel val) {
    invalidTokens.data.add(val);
    tokens.data.removeWhere((tk) => tk.id == val.id);
  }

  @action
  void requestChanged(RequestType type, [isAdd = true]) {
    switch (type) {
      case RequestType.appointment:
        isAdd ? requestsCount.appt.add(0) : requestsCount.appt.removeLast();
      case RequestType.request:
        isAdd ? requestsCount.req.add(0) : requestsCount.req.removeLast();
      case RequestType.upload:
        isAdd ? requestsCount.img.add(0) : requestsCount.img.removeLast();
      case RequestType.payment:
        isAdd ? requestsCount.pay.add(0) : requestsCount.pay.removeLast();
      case RequestType.myapi:
      //  isAdd ? requestsCount.appt.add(0) :  requestsCount.appt.removeLast();
    }
  }
}
