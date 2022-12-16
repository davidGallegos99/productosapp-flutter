import 'dart:convert';

class RegisterResponse {
  RegisterResponse({
    required this.kind,
    required this.idToken,
    required this.email,
    required this.refreshToken,
    required this.expiresIn,
    required this.localId,
  });

  String kind;
  String idToken;
  String email;
  String refreshToken;
  String expiresIn;
  String localId;

  factory RegisterResponse.fromJson(String str) =>
      RegisterResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RegisterResponse.fromMap(Map<String, dynamic> json) =>
      RegisterResponse(
        kind: json["kind"],
        idToken: json["idToken"],
        email: json["email"],
        refreshToken: json["refreshToken"],
        expiresIn: json["expiresIn"],
        localId: json["localId"],
      );

  Map<String, dynamic> toMap() => {
        "kind": kind,
        "idToken": idToken,
        "email": email,
        "refreshToken": refreshToken,
        "expiresIn": expiresIn,
        "localId": localId,
      };
}
