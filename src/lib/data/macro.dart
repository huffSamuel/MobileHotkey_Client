class Macro{
  final int id;
  final String name;

  const Macro({this.id, this.name});

  Macro.fromMap(Map<String, dynamic> map) :
    id = map['id'],
    name = map['name'];
}

class FetchDataException implements Exception {
  final String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}
