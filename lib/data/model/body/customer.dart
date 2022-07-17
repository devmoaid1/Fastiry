class Customer {
  String firstName;
  String lastName;
  String email;
  String phone;

  Customer({this.email, this.firstName, this.lastName, this.phone});

  Customer.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['order_id'] = this.phone;

    return data;
  }
}
