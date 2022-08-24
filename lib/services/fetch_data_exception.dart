class FetchDataException implements Exception{
  final _message;
  FetchDataException([this._message]);
  @override
  String toString() {
    if (_message == null) return "Exception.......";
    return _message;
  }
}