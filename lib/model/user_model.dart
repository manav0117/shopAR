class Users {
  String? name;
  String? phoneNumber;
  String? email;
  String? password;

  Users({this.name, this.phoneNumber, this.email, this.password});

  Users.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['password'] = this.password;

    return data;
  }
}
