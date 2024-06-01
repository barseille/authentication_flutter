class User {
  String id;
  String email;
  String username;

  User({
    required this.id, 
    required this.email, 
    required this.username});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'];
}
