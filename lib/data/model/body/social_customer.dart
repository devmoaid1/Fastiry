class SocialCustomer {
  String socialId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String password;

  SocialCustomer(
      {this.email,
      this.socialId,
      this.firstName,
      this.lastName,
      this.phone,
      this.password});

  SocialCustomer.fromJson(Map<String, dynamic> json) {
    socialId = json['socialId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    return data;
  }
}
