import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';
import 'package:untitled/models/shop_app/categories_model.dart';
import 'package:untitled/models/shop_app/delete_address.dart';
import 'package:untitled/models/shop_app/faqs_model.dart';
import 'package:untitled/models/shop_app/favorites_mode.dart';
import 'package:untitled/models/shop_app/home_model.dart';
import 'package:untitled/modules/Shop_app/setteings/faqs_screen.dart';
import 'package:untitled/shard/nerwork/local/cache_helper.dart';
import '../../../models/shop_app/InCart_Get_model.dart';
import '../../../models/shop_app/add_address.dart';
import '../../../models/shop_app/cahnge_favorites_model.dart';
import '../../../models/shop_app/categories_details.dart';
import '../../../models/shop_app/detail_model.dart';
import '../../../models/shop_app/get_address.dart';
import '../../../models/shop_app/in_cart_model.dart';
import '../../../models/shop_app/login_model.dart';
import '../../../models/shop_app/notifications_model.dart';
import '../../../models/shop_app/orders_model.dart';
import '../../../models/shop_app/search_model.dart';
import '../../../models/shop_app/update_address.dart';
import '../../../modules/Shop_app/In_cart_screen/In_cart_screen.dart';
import '../../../modules/Shop_app/categories/categories_screen.dart';
import '../../../modules/Shop_app/favorites/favorite_screen.dart';
import '../../../modules/Shop_app/productes/products_Screen.dart';
import '../../../modules/Shop_app/setteings/profile_screen.dart';
import '../../../modules/Shop_app/setteings/settings_screen.dart';
import '../../../shard/component/constants.dart';
import '../../../shard/nerwork/remote/end_points.dart';
import '../../../shard/nerwork/remote/dio_helper.dart';

class ShopAppCubit extends Cubit<ShopAppStates> {
  ShopAppCubit() : super(InitialState());
  static ShopAppCubit get(context) => BlocProvider.of(context);
  List<Widget> screen = [
    ProductesScreen(),
    CategoriesScreen(),
    FavoriteScreen(),
    InCartScreen(),
    SettingsScreen(),
  ];
  int currentIndex = 0;
  List<SalomonBottomBarItem> navList = [
    SalomonBottomBarItem(
        icon: Icon(Icons.home),
        title: Text(
          "Home",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
    SalomonBottomBarItem(
        icon: Icon(Icons.apps),
        title: Text(
          "Categories",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
    SalomonBottomBarItem(
        icon: Icon(Icons.favorite),
        title: Text(
          "Favorite",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
    SalomonBottomBarItem(
        icon: Icon(Icons.shopping_cart_sharp),
        title: Text(
          "Carts",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
    SalomonBottomBarItem(
        icon: Icon(Icons.settings),
        title: Text(
          "settings",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )),
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  int value = 0;

  void changeVal(val) {
    value = val;
    emit(ChangeIndicatorState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};
  Map<int, bool> carts = {};
  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({element.id!: element.inFavorites!});
      });
      homeModel!.data!.products.forEach((element) {
        carts.addAll({element.id!: element.inCart!});
      });
      print(favorites);
      print(carts);
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategoriesData() {
    emit(ShopLoadingCategoryDataState());
    DioHelper.getData(
      url: CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoryDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoryDataState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;

    emit(ChangeFavoritesIcon());
    DioHelper.postData(
            url: FAVORITES,
            data: {"product_id": productId},
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
      }
      emit(ShopSuccessChangeFavoritesDataState(changeFavoritesModel));
    }).catchError((onError) {
      favorites[productId] = !favorites[productId]!;

      emit(ShopErrorChangeFavoritesDataState());
    });
  }

  FavoritesModel? favoritesModel;
  void getFavoritesData() {
    emit(ShopLoadingGetFavoritesDataState());
    DioHelper.getData(url: FAVORITES, token: CacheHelper.getData(key: 'token'))
        .then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      print(favoritesModel);

      emit(ShopSuccessGetFavoritesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesDataState());
    });
  }

  InCartChange? inCartChange;
  void inCarts(int productId) {
    carts[productId] = !carts[productId]!;
    emit(ShopChangeInCartIconState());
    DioHelper.postData(
            url: CARTS,
            data: {"product_id": productId},
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      inCartChange = InCartChange.fromJson(value.data);
      if (!inCartChange!.status!) {
        carts[productId] = !carts[productId]!;
      } else {
        getInCartData();
      }
      emit(ShopSuccessInCartDataState(inCartChange!));
    }).catchError((onError) {
      carts[productId] = !carts[productId]!;
      print(onError.toString());
      emit(ShopErrorInCartDataState());
    });
  }

  InCartGetModel? inCartGetModel;
  void getInCartData() {
    emit(ShopGetInCartLoadingDataState());
    DioHelper.getData(url: CARTS, token: CacheHelper.getData(key: 'token'))
        .then((value) {
      inCartGetModel = InCartGetModel.fromJson(value.data);
      emit(ShopGetInCartSuccessDataState());
      print(inCartGetModel!.message);
    }).catchError((error) {
      print(error.toString());
      emit(ShopGetInCartErrorDataState());
    });
  }

  LoginModel? userModel;
  Future<void> getUserData() async {
    emit(ShopLoadingUpdateDataState());
    DioHelper.getData(url: PROFILES, token: CacheHelper.getData(key: 'token'))
        .then((value) {
      userModel = LoginModel.fromJson(value.data);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      print(userModel!.data!.phone!);
      emit(ShopSuccessUpdateDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateDataState());
    DioHelper.putData(
        url: UPDATE_PROFILE,
        token: CacheHelper.getData(key: 'token'),
        data: {
          'name': name,
          'email': email,
          'phone': phone,
        }).then((value) {
      userModel = LoginModel.fromJson(value.data);
      print(userModel!.data!.phone!);
      emit(ShopSuccessUpdateDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateDataState());
    });
  }

  ProductDetailsModel? productDetailsModel;

  void getProductData(String id) {
    emit(ShopLoadingGetProductDetailsDataStats());
    DioHelper.getData(
            url: 'products/$id', token: CacheHelper.getData(key: 'token'))
        .then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      emit(ShopSuccessGetProductDetailsDataStats());
    }).catchError((error) {
      emit(ShoErrorGetProductDetailsDataState());
      print(error.toString());
    });
  }

  SearchModel? searchModel;

  void getSearchData(String text) {
    emit(ShopLoadingSearchDataStatus());
    DioHelper.postData(
            data: {text: 'text'},
            url: SEARCH,
            token: CacheHelper.getData(key: 'token'))
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(ShopSuccessSearchDataStatus());
    }).catchError((error) {
      emit(ShoErrorSearchDataState());
      print(error.toString());
    });
  }

  CategoryDetailModel? categoriesDetailModel;

  void getCategoriesDetailData(int? categoryID) {
    emit(ShopCategoryDetailsLoadingState());
    DioHelper.getData(url: CATEGORIES_DETAIL, query: {
      'category_id': '$categoryID',
    }).then((value) {
      categoriesDetailModel = CategoryDetailModel.fromJson(value.data);
      emit(ShopCategoryDetailsSuccessState());
    }).catchError((error) {
      emit(ShopCategoryDetailsErrorState());
      print(error.toString());
    });
  }

  int quantity = 1;
  void plusQuantity(InCartGetModel model, index) {
    quantity = model.data.cartItems[index].quantity;
    quantity++;
    emit(ShopAppUpdateInCartPlusQuantity());
  }

  void minusQuantity(InCartGetModel model, index) {
    quantity = model.data.cartItems[index].quantity;
    if (quantity >= 1) quantity--;
    emit(ShopAppUpdateInCartMinusQuantity());
  }

  // Up date cart data

  void updateCartData({required String id, int? quantity}) {
    emit(ShopAppUpdateInCartDataLoading());
    DioHelper.putData(
            url: "${"carts/" + id}",
            data: {
              'quantity': quantity,
            },
            token: CacheHelper.getData(key: "token"))
        .then((value) {
      getInCartData();
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppUpdateInCartDataError());
    });
  }

  AddAddressModel? addressModel;

  void addAddress({
    required String name,
    required String city,
    required String region,
    required String details,
    required String notes,
    double latitude = 30.0616863,
    double longitude = 31.3260088,
  }) {
    emit(ShopAppAddAddressLoadingState());
    DioHelper.postData(
      url: ADDRESS,
      data: {
        'name': name,
        'city': city,
        'region': region,
        'details': details,
        'notes': notes,
        'latitude': latitude,
        'longitude': longitude,
      },
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      addressModel = AddAddressModel.fromJson(value.data);
      if (addressModel!.status!) getAddresses();
      emit(ShopAppAddAddressSuccessState(addressModel!));
    }).catchError((error) {
      emit(ShopAppAddAddressErrorState());
    });
  }

  GetAddressModel? getAddressModel;
  void getAddresses() {
    emit(ShopAppGetAddressLoadingState());
    DioHelper.getData(
      url: ADDRESS,
      token: CacheHelper.getData(key: "token"),
    ).then((value) {
      getAddressModel = GetAddressModel.fromJson(value.data);
      emit(ShopAppGetAddressSuccessState());
    }).catchError((error) {
      emit(ShopAppGetAddressErrorState());
    });
  }

  DeleteAddress? deleteAddress;
  void removeAddress({required addressId}) {
    emit(ShopAppDeleteAddressLoadingState());
    DioHelper.deleteData(
      url: 'addresses/$addressId',
      token: token,
    ).then((value) {
      deleteAddress = DeleteAddress.fromJson(value.data);
      if (deleteAddress!.status!) getAddresses();
      emit(ShopAppDeleteAddressSuccessState());
    }).catchError((error) {
      emit(ShopAppDeleteAddressErrorState());
      print(error.toString());
    });
  }

// Update address
  UpdateAddressModel? updateAddressModel;
  void updateAddress({
    required addressId,
    required String name,
    required String city,
    required String region,
    required String details,
    required String notes,
    double latitude = 30.0616863,
    double longitude = 31.3260088,
  }) {
    emit(ShopAppUpdateAddressLoadingState());
    DioHelper.putData(
      url: 'addresses/$addressId',
      data: {
        'name': name,
        'city': city,
        'region': region,
        'details': details,
        'notes': notes,
        'latitude': latitude,
        'longitude': longitude,
      },
      token: token,
    ).then((value) {
      updateAddressModel = UpdateAddressModel.fromJson(value.data);
      if (updateAddressModel!.status) getAddresses();
      emit(ShopAppUpdateAddressSuccessState(updateAddressModel));
    }).catchError((error) {
      emit(ShopAppUpdateAddressErrorState());
      print(error.toString());
    });
  }

  // Add order
  AddAddressModel? addAddressModel;
  void addOrders({
    addressId,
  }) {
    DioHelper.postData(
      url: ORDERS,
      data: {
        'address_id': addressId,
        'payment_method': 1,
        'use_points': false,
      },
      token: token,
    ).then((value) {
      addAddressModel = AddAddressModel.fromJson(value.data);
      emit(ShopAppAddOrdersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppAddOrdersErrorState());
    });
  }

  // Get order
  GetOrdersModel? getOrdersModel;
  void getOrders() {
    DioHelper.getData(
      url: ORDERS,
      token: CacheHelper.getData(key: "token"),
    ).then((
      value,
    ) {
      getOrdersModel = GetOrdersModel.fromJson(value.data);
      print('ddd${getOrdersModel!.message}');
      emit(ShopAppGetOrdersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppGetOrdersErrorState());
    });
  }

  // Get faqs
  FAQsModel? faQsModel;
  void getFaqs() {
    DioHelper.getData(
      url: FAQS,
    ).then((
      value,
    ) {
      faQsModel = FAQsModel.fromJson(value.data);
      emit(ShopAppGetFaqsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppGetFaqsErrorState());
    });
  }

  // Get Notifications
  NotificationsModel? notifications;
  void getNotifications() {
    emit(ShopAppGetNotificationsLoadingState());

    DioHelper.getData(url: NOTIFICATIONS, token: token).then((
      value,
    ) {
      notifications = NotificationsModel.fromJson(value.data);
      emit(ShopAppGetNotificationsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppGetNotificationsErrorState());
    });
  }

  // Cancel order
  CancelOrderModel? cancelOrderModel;
  void cancelOrder({required int orderId}) {
    DioHelper.getData(
      url: "$ORDERS $orderId cancel ",
      token: CacheHelper.getData(key: "token"),
    ).then((
      value,
    ) {
      cancelOrderModel = CancelOrderModel.fromJson(value.data);
      getOrders();
    }).catchError((error) {
      print(error.toString());
      emit(ShopAppCancelOrdersErrorState());
    });
  }

  IconData changeIcon = Icons.toggle_on;
  bool isDark = false;
  void changeThemMod() {
    isDark = !isDark;
    changeIcon = isDark == false ? Icons.toggle_on : Icons.toggle_off;
    emit(ChangeIconThem());
  }
}
