import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';
import 'package:untitled/models/shop_app/categories_model.dart';
import 'package:untitled/models/shop_app/favorites_mode.dart';
import 'package:untitled/modules/Shop_app/product_details/product_details.dart';
import 'package:untitled/shard/component/component.dart';

import '../../../../../shard/style/colors.dart';
import '../../../models/shop_app/InCart_Get_model.dart';
import '../address/address_screen.dart';

class InCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: ShopAppCubit.get(context).inCartGetModel != null,
            builder: (context) => Column(children: [
                  ListTile(
                    title: const Text('Total Price',
                        style: TextStyle(fontSize: 20)),
                    subtitle: Text(
                        '${ShopAppCubit.get(context).inCartGetModel!.data.total} EG',
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                    trailing: SizedBox(
                      width: 160.0,
                      height: 40.0,
                      child: MaterialButton(
                        onPressed: () {
                          navigateTo(context, AddressScreen());
                        },
                        child: const Text(
                          'Order',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: defaultColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                          itemBuilder: (context, index) => buildListProduct(
                              ShopAppCubit.get(context).inCartGetModel!,
                              context,
                              index),
                          separatorBuilder: (context, index) =>
                              buildCategorySeparated(),
                          itemCount: ShopAppCubit.get(context)
                              .inCartGetModel!
                              .data
                              .cartItems
                              .length),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                  )
                ]),
            fallback: (context) => Center(child: CircularProgressIndicator()));
      },
    );
  }
}

Widget buildListProduct(InCartGetModel model, context, index) => Padding(
    padding: const EdgeInsets.all(20),
    child: Container(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(alignment: Alignment.bottomLeft, children: [
            Image(
              image: NetworkImage(model.data.cartItems[index].product.image),
              width: 120,
              height: 120,
            ),
            if (model.data.cartItems[index].product.discount != 0)
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "DISCOUNT",
                    style: TextStyle(fontSize: 8.5, color: Colors.white),
                  ),
                ),
                color: Colors.red,
              ),
          ]),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  model.data.cartItems[index].product.name,
                  maxLines: 2,
                  style: TextStyle(fontSize: 13.5, height: 1.2),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 130,
                  height: 45,
                  decoration: BoxDecoration(
                      border: Border.all(color: defaultColor, width: 0.5),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    children: [
                      Expanded(
                          child: IconButton(
                        onPressed: () {
                          ShopAppCubit.get(context).minusQuantity(model, index);
                          ShopAppCubit.get(context).updateCartData(
                              id: model.data.cartItems[index].id.toString(),
                              quantity: ShopAppCubit.get(context).quantity);
                        },
                        icon: Icon(
                          Icons.remove,
                          size: 15,
                        ),
                      )),
                      Center(
                          child: Text(
                        "${model.data.cartItems[index].quantity}",
                        style: TextStyle(fontSize: 15),
                      )),
                      Expanded(
                          child: IconButton(
                        onPressed: () {
                          ShopAppCubit.get(context).plusQuantity(model, index);
                          ShopAppCubit.get(context).updateCartData(
                              id: model.data.cartItems[index].id.toString(),
                              quantity: ShopAppCubit.get(context).quantity);
                        },
                        icon: Icon(
                          Icons.add,
                          size: 15,
                        ),
                      ))
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '${model.data.cartItems[index].product.price!.round()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: defaultColor,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      if (model.data.cartItems[index].product.discount != 0)
                        Text(
                          '${model.data.cartItems[index].product.oldPrice!.round()}',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopAppCubit.get(context)
                              .inCarts(model.data.cartItems[index].product.id);
                        },
                        icon: Icon(Icons.shopping_cart_outlined),
                        color: ShopAppCubit.get(context)
                                .carts[model.data.cartItems[index].product.id]!
                            ? defaultColor
                            : Colors.black,
                        focusColor: Colors.grey,
                        iconSize: 22,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
Widget buildCategorySeparated() => Container(
      height: 0.5,
      width: double.infinity,
      color: Colors.blueGrey,
    );
