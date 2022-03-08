import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/shard/component/component.dart';
import 'package:untitled/shard/style/colors.dart';

import '../../../../../layout/Shop_app/cubit/cubit.dart';
import '../../../../../layout/Shop_app/cubit/states.dart';
import '../../../../../models/shop_app/get_address.dart';
import '../../../../../shard/component/constants.dart';
import '../../../models/shop_app/orders_model.dart';

class GetOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.shopping_cart_sharp,
                color: defaultColor,
              ),
              title: Text("My Orders"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))
              ],
              elevation: 2,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                  itemBuilder: (context, index) => itemOrders(
                      ShopAppCubit.get(context).getOrdersModel!,
                      index,
                      context),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                  itemCount: ShopAppCubit.get(context)
                      .getOrdersModel!
                      .data!
                      .data!
                      .length),
            ),
          );
        });
  }

  Widget itemOrders(GetOrdersModel model, index, context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ' ID    :    ${model.data!.data![index].id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                Spacer(),
                if (model.data!.data![index].status == "New")
                  Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: MaterialButton(
                        onPressed: () {
                          ShopAppCubit.get(context).cancelOrder(
                              orderId: model.data!.data![index].id!);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                  )
              ],
            ),
            Text(
              ' Total  :   ${model.data!.data![index].total}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
            const SizedBox(height: 10),
            Text(
              ' Date   :  ${model.data!.data![index].date}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("Status  : ", style: textStyle),
                Text(
                  " ${model.data!.data![index].status}",
                  style: textStyle.copyWith(
                      color: model.data!.data![index].status! == "New"
                          ? Colors.green
                          : Colors.red),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
