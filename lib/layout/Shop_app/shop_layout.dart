import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';
import 'package:untitled/modules/Shop_app/login/shop_login.dart';
import 'package:untitled/modules/Shop_app/on_boarding/on_boarding.dart';
import 'package:untitled/shard/component/component.dart';
import 'package:untitled/shard/nerwork/local/cache_helper.dart';
import 'package:untitled/shard/style/colors.dart';

import '../../modules/Shop_app/notifications_screen/notifications_screen.dart';
import '../../modules/Shop_app/search/search_screen.dart';

class ShopLayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopAppCubit cubit = ShopAppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Salla",
              style: TextStyle(color: defaultColor),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context, ShopAppSearch());
                  },
                  icon: Icon(Icons.search)),
              IconButton(
                  onPressed: () {
                    ShopAppCubit.get(context).getNotifications();
                    navigateTo(context, NotificationsScreen());
                  },
                  icon: Icon(
                    Icons.notifications_outlined,
                  )),
            ],
          ),
          bottomNavigationBar: SalomonBottomBar(
            duration: Duration(
              seconds: 1,
            ),
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items: cubit.navList,
          ),
          body: cubit.screen[cubit.currentIndex],
        );
      },
    );
  }
}
