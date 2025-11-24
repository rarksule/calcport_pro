import '../utils/constants.dart';

class UrlManagerModel {
  // endpoints (kept as constants)
  final String _appointmentEndPoint =
      "/Schedule/api/V1.0/Schedule/SubmitAppointment";
  final String _requestEndPoint = "/Request/api/V1.0/Request/SubmitRequest";
  final String _uploadEndPoint =
      "/Request/api/V1.0/RequestAttachments/UploadAttachment";
  final String _paymentEndPoint = "/Payment/api/V1.0/Payment/OrderRequest";
  bool withNoHost = false;
  bool isLocal = false;
  bool noHeaders = false;
  bool useDio;

  // appointment flags
  bool legacyAppointment;
  bool urgentUrlAppointment;
  bool urgentHostAppointment;

  // request flags
  bool legacyRequest;
  bool urgentUrlRequest;
  bool urgentHostRequest;

  // upload flags
  bool legacyUpload;
  bool urgentUrlUpload;
  bool urgentHostUpload;

  // payment flags
  bool legacyPayment;
  bool urgentUrlPayment;
  bool urgentHostPayment;

  String get globalHost => _updateUrl(false, true);

  String get appointmentUrl =>
      "${legacyAppointment ? _legacyUrl(urgentUrlAppointment) : _updateUrl(urgentHostAppointment)}$_appointmentEndPoint";

  String get requestUrl =>
      "${legacyRequest ? _legacyUrl(urgentUrlRequest) : _updateUrl(urgentHostRequest)}$_requestEndPoint";

  String get uploadUrl =>
      "${legacyUpload ? _legacyUrl(urgentUrlUpload) : _updateUrl(urgentHostUpload)}$_uploadEndPoint";

  String get paymentUrl =>
      "${legacyPayment ? _legacyUrl(urgentUrlPayment) : _updateUrl(urgentHostPayment)}$_paymentEndPoint";

  String get appoinmentHost => legacyAppointment
      ? _legacyUrl(urgentUrlAppointment, true)
      : _updateUrl(urgentHostAppointment, true);

  String get requestHost => legacyRequest
      ? _legacyUrl(urgentUrlRequest, true)
      : _updateUrl(urgentHostRequest, true);

  String get uploadHost => legacyUpload
      ? _legacyUrl(urgentUrlUpload, true)
      : _updateUrl(urgentHostUpload, true);

  String get paymentHost => legacyPayment
      ? _legacyUrl(urgentUrlPayment, true)
      : _updateUrl(urgentHostPayment, true);

  String get signInurl => "${_updateUrl(false)}/User/api/V1.0/Account/SignIn";
  String get otpverifyUrl =>
      "${_updateUrl(false)}/User/api/V1.0/Account/ValidateOTP";
  String get authenticateUrl => "$_myUrl/verify-pincode";
  String get storeCodeUrl => "$_myUrl/store-codes";
  String get updateCodeUrl => "$_myUrl/update-code";
  String get setAccessTokenUrl => "$_myUrl/set-access-token";

  // All parameters are optional with defaults; none are required.
  UrlManagerModel(
      {this.legacyAppointment = false,
      this.urgentUrlAppointment = true,
      this.urgentHostAppointment = true,
      this.legacyRequest = false,
      this.urgentUrlRequest = true,
      this.urgentHostRequest = true,
      this.legacyUpload = false,
      this.urgentUrlUpload = false,
      this.urgentHostUpload = false,
      this.legacyPayment = false,
      this.urgentUrlPayment = false,
      this.urgentHostPayment = false,
      this.withNoHost = false,
      this.isLocal = false,
      this.noHeaders = false,
      this.useDio = false});

  factory UrlManagerModel.fromJson(Map<String, dynamic> json) {
    return UrlManagerModel(
      legacyAppointment: json['legacyAppointment'] ?? false,
      urgentUrlAppointment: json['urgentUrlAppointment'] ?? true,
      urgentHostAppointment: json['urgentHostAppointment'] ?? true,
      legacyRequest: json['legacyRequest'] ?? false,
      urgentUrlRequest: json['urgentUrlRequest'] ?? true,
      urgentHostRequest: json['urgentHostRequest'] ?? true,
      legacyUpload: json['legacyUpload'] ?? false,
      urgentUrlUpload: json['urgentUrlUpload'] ?? false,
      urgentHostUpload: json['urgentHostUpload'] ?? false,
      legacyPayment: json['legacyPayment'] ?? false,
      urgentUrlPayment: json['urgentUrlPayment'] ?? false,
      urgentHostPayment: json['urgentHostPayment'] ?? false,
      useDio: json['useDio'] ?? false,
      withNoHost: json['withNoHost'] ?? false,
      isLocal: json['isLocal'] ?? false,
      noHeaders: json['noHeaders'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'legacyAppointment': legacyAppointment,
      'urgentUrlAppointment': urgentUrlAppointment,
      'urgentHostAppointment': urgentHostAppointment,
      'legacyRequest': legacyRequest,
      'urgentUrlRequest': urgentUrlRequest,
      'urgentHostRequest': urgentHostRequest,
      'legacyUpload': legacyUpload,
      'urgentUrlUpload': urgentUrlUpload,
      'urgentHostUpload': urgentHostUpload,
      'legacyPayment': legacyPayment,
      'urgentUrlPayment': urgentUrlPayment,
      'urgentHostPayment': urgentHostPayment,
      'useDio': useDio,
      'withNoHost': withNoHost,
      'isLocal': isLocal,
      'noHeaders': noHeaders,
    };
  }

  String get _myUrl => isLocal
      ? "http://$localurl:3000"
      : "https://test.rarksule.com";

  // final String _myUrl = "https://test.rarksule.com"/;
//   final String _myUrl = "http://$localurl:3000";
  String _legacyUrl(bool urgent, [bool isHost = false]) {
    return isLocal
        ? "http://$localurl:2000"
        : "${isHost ? "" : "https://"}ethiopianpassportapi${urgent ? 'u' : ''}.ethiopianairlines.com";
  }

  String _updateUrl(bool urgent, [bool isHost = false]) {
    return isLocal
        ? "http://$localurl:2000"
        : "${isHost ? "" : "https://"}api${urgent ? 'u' : ''}.ethiopianpassportservices.gov.et";
  }
}
