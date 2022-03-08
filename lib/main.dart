import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/modules/Shop_app/login/shop_login.dart';
import 'package:untitled/shard/bloc_observer.dart';
import 'package:untitled/shard/component/constants.dart';
import 'package:untitled/shard/nerwork/local/cache_helper.dart';
import 'package:untitled/shard/nerwork/remote/dio_helper.dart';
import 'package:untitled/shard/style/themes.dart';
import 'layout/Shop_app/cubit/cubit.dart';
import 'layout/Shop_app/cubit/states.dart';
import 'layout/Shop_app/shop_layout.dart';
import 'modules/Shop_app/on_boarding/on_boarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () async {
      DioHelper.init();
      await CacheHelper.init();
      dynamic onBoarding = CacheHelper.getData(key: 'onBoarding');
      token = CacheHelper.getData(key: 'token');
      Widget widget;
      if (onBoarding != null) {
        if (token != null)
          widget = ShopLayoutScreen();
        else
          widget = ShopLoginScreen();
      } else {
        widget = OnBoardingScreen();
      }
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  MyApp({
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ShopAppCubit()
              ..getHomeData()
              ..getCategoriesData()
              ..getFavoritesData()
              ..getInCartData()
              ..getUserData()
              ..getAddresses()
              ..getOrders()
              ..getFaqs()
              ..getNotifications()),
      ],
      child: BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: lightThem,
            darkTheme: darkThem,
            themeMode: ThemeMode.light,
            home: startWidget,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
