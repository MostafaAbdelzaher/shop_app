import 'package:untitled/models/shop_app/login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialState extends ShopLoginStates {}

class ShopLoginLoadingState  extends ShopLoginStates {}

class ShopLoginSuccessState  extends ShopLoginStates {
  final LoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);
}

class ShopLoginErrorState  extends ShopLoginStates {
  final error;
  ShopLoginErrorState({this.error});
}
class ChangePasswordVisibility  extends ShopLoginStates {}

