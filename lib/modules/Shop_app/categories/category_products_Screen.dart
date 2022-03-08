import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/models/shop_app/categories_details.dart';

import '../../../layout/Shop_app/cubit/cubit.dart';
import '../../../layout/Shop_app/cubit/states.dart';
import '../../../models/shop_app/home_model.dart';
import '../../../shard/component/component.dart';
import '../../../shard/style/colors.dart';
import '../product_details/product_details.dart';

class CategoryProductsDetailsScreen extends StatelessWidget {
  final String? name;
  CategoryProductsDetailsScreen(this.name);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: ConditionalBuilder(
              condition:
                  ShopAppCubit.get(context).categoriesDetailModel != null,
              fallback: (BuildContext context) => Center(
                child: Text("Loding.."),
              ),
              builder: (BuildContext context) => SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      name!,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: GridView.count(
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 1 / 1.53,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: List.generate(
                            ShopAppCubit.get(context)
                                .categoriesDetailModel!
                                .data
                                .productData
                                .length,
                            (index) => InkWell(
                                onTap: () {
                                  navigateTo(
                                      context,
                                      ProductDetailsScreen(
                                          ShopAppCubit.get(context)
                                              .categoriesDetailModel!
                                              .data
                                              .productData[index]
                                              .id));
                                },
                                child: buildGridItemCaCategory(
                                    ShopAppCubit.get(context)
                                        .categoriesDetailModel!
                                        .data
                                        .productData[index],
                                    context))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildGridItemCaCategory(CategoryData model, context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(alignment: AlignmentDirectional.bottomStart, children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Image(
                  image: NetworkImage(model.image!),
                  width: double.infinity,
                  height: 180,
                ),
              ),
              if (model.discount != 0)
                Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'discount',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                )
            ]),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 2,
                    style: TextStyle(fontSize: 13.5, height: 1.2),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
      );
}
