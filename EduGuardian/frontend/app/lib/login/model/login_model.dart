class LoginModel {
  String username;
  String password;

  LoginModel(this.username, this.password);

  factory LoginModel.fromJson(dynamic data){
    return LoginModel(data['username'], data['password']);
  }
}
