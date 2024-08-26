// class Bearer {
//   String be = '';
//
//   // Constructor that takes decodedResponse as a parameter
//   Bearer(decodedResponse) {
//     // Access the 'bearer' property from decodedResponse and assign it to 'be'
//     be = decodedResponse;
//     print(be);// Use the null-aware operator to handle null values
//   }
// }
class Bearer {
  static final Bearer _instance = Bearer._internal();
  String? _token;

  factory Bearer() {
    return _instance;
  }

  Bearer._internal();

  void insertToken(String value) {
    _token = value;
    print(_token);
  }

  String? getToken() {
    print(_token);
    return _token;
  }
}


