class ResponseModel {
  bool _isSuccess;
  String _message;
  Map? body;
  ResponseModel(this._isSuccess, this._message, {this.body});

  String get message => _message;
  bool get isSuccess => _isSuccess;

}