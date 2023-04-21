class MakePaymentResponse {
  String? message;
  String? url;
  String? displayType;

  MakePaymentResponse({this.message, this.url, this.displayType});

  MakePaymentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    url = json['url'];
    displayType = json['displayType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['url'] = url;
    data['displayType'] = displayType;
    return data;
  }
}
