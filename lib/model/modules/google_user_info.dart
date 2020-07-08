class GoogleUserInfo {
  String id;
  String email;
  bool emailVerified;
  String name;
  String givenName;
  String familyName;
  Uri picture;
  String locale;
  String hd;

  GoogleUserInfo(
      {this.id,
      this.email,
      this.emailVerified,
      this.name,
      this.givenName,
      this.familyName,
      this.picture,
      this.hd,
      this.locale});
  factory GoogleUserInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return GoogleUserInfo(
        id: json['id'],
        email: json['email'],
        emailVerified: json['verified_email'],
        name: json['name'],
        givenName: json['given_name'],
        familyName: json['family_name'],
        picture: Uri.parse(json['picture']),
        locale: json['locale'],
        hd: json['hd']);
  }
}
