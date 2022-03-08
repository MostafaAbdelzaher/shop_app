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

import '../../../shard/style/colors.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: ShopAppCubit.get(context).favoritesModel != null,
            builder: (context) => ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        navigateTo(
                            context,
                            ProductDetailsScreen(ShopAppCubit.get(context)
                                .favoritesModel!
                                .data!
                                .data![index]
                                .product!
                                .id));
                      },
                      child: buildListProduct(
                          ShopAppCubit.get(context)
                              .favoritesModel!
                              .data!
                              .data![index]
                              .product!,
                          context),
                    ),
                separatorBuilder: (context, index) => buildCategorySeparated(),
                itemCount: ShopAppCubit.get(context)
                    .favoritesModel!
                    .data!
                    .data!
                    .length),
            fallback: (context) => Center(child: CircularProgressIndicator()));
      },
    );
  }
}

Widget buildListProduct(model, context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Container(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(alignment: Alignment.bottomLeft, children: [
            Image(
              image: NetworkImage(model.image!),
              width: 120,
              height: 120,
            ),
            if (model.discount != 0)
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  maxLines: 2,
                  style: TextStyle(fontSize: 13.5, height: 1.2),
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '${model.price!.round()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: defaultColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice!.round()}',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopAppCubit.get(context).inCarts(model.id!);
                      },
                      icon: Icon(Icons.shopping_cart_outlined),
                      color: ShopAppCubit.get(context).carts[model.id]!
                          ? defaultColor
                          : Colors.black,
                      focusColor: Colors.grey,
                      iconSize: 22,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        ShopAppCubit.get(context).changeFavorites(model.id!);

                        print(model.id);
                      },
                      icon: CircleAvatar(
                        backgroundColor:
                            ShopAppCubit.get(context).favorites[model.id]!
                                ? defaultColor
                                : Colors.blueGrey,
                        radius: 15,
                        child: Icon(
                          Icons.favorite_border,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
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
