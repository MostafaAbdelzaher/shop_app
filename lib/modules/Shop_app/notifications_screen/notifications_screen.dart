import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/shop_app/faqs_model.dart';
import 'package:untitled/modules/Shop_app/setteings/profile_screen.dart';
import 'package:untitled/shard/component/component.dart';
import 'package:untitled/shard/style/colors.dart';

import '../../../../layout/Shop_app/cubit/cubit.dart';
import '../../../../layout/Shop_app/cubit/states.dart';
import '../../../../shard/nerwork/local/cache_helper.dart';
import '../../../models/shop_app/notifications_model.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        NotificationsModel model = ShopAppCubit.get(context).notifications!;
        return Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            title: Text(
              "Notifications",
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.notifications_active_outlined),
              )
            ],
          ),
          body: state is ShopAppGetNotificationsLoadingState
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  itemBuilder: (context, index) =>
                      notificationsItem(context, model, index),
                  separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: SizedBox(
                          height: 0,
                        ),
                      ),
                  itemCount: model.data!.data!.length),
        );
      },
    );
  }

  Widget notificationsItem(context, NotificationsModel model, index) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "13:02:24",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Spacer(),
                  Text("2022:02:27",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 15,
                      ))
                ],
              ),
              SizedBox(
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Text(
                "${model.data!.data![index].title} ",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${model.data!.data![index].message}",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
