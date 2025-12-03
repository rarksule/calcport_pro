import '../main.dart';
import '../models/request_count_model.dart';
import 'package:mobx/mobx.dart';

import '../models/token_model.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  int tokensLength = 0;
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
    for (var tkn in stateTokens.data) {
      if (!tkn.isActive) {
        // invalidTokens.data.add(tkn);
        stateTokens.data.removeWhere((tk) => tk.id == tkn.id);
      }
    }
    stateTokens.data.add(val);
    tokensLength = stateTokens.data.length;
  }

  @action
  Future<void> tokenChanged() async{
    tokensLength = stateTokens.data.where((tk)=>tk.isActive).length;
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  Future<void> removeToken(TokenModel val) async{
    // invalidTokens.data.add(val);
    stateTokens.data.removeWhere((tk) => tk.id == val.id);
    tokensLength = stateTokens.data.where((tk)=>tk.isActive).length;
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
