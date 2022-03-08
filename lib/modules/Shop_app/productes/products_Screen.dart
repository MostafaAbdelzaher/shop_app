import 'dart:ffi';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';
import 'package:untitled/models/shop_app/categories_model.dart';
import 'package:untitled/models/shop_app/home_model.dart';
import 'package:untitled/shard/component/component.dart';
import 'package:untitled/shard/style/colors.dart';

import '../details_screen/details_screen.dart';
import '../categories/category_products_Screen.dart';
import '../product_details/product_details.dart';

class ProductesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesDataState) {
          if (state.changeFavoritesModel!.status!) {
            showToast(
                text: state.changeFavoritesModel!.message!,
                state: ToastStates.SUCCESS);
          } else {
            showToast(
                text: state.changeFavoritesModel!.message!,
                state: ToastStates.ERROR);
          }
        }
        if (state is ShopSuccessInCartDataState) {
          if (state.inCartChange.status!) {
            showToast(
                text: state.inCartChange.message!, state: ToastStates.SUCCESS);
          } else {
            showToast(
                text: state.inCartChange.message!, state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        ShopAppCubit cubit = ShopAppCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.homeModel != null && cubit.categoriesModel != null,
            builder: (context) => productsBuilder(
                cubit.homeModel!, cubit.categoriesModel!, context),
            fallback: (context) => Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget productsBuilder(
          HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data!.banners
                  .map(
                    (e) => Image(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          '${e.image}',
                        )),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 200.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => buildCategoryItem(
                            categoriesModel.data!.data[index], context),
                        separatorBuilder: (context, index) => SizedBox(
                              width: 10,
                            ),
                        itemCount: categoriesModel.data!.data.length),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'New products',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                crossAxisSpacing: 2,
                mainAxisSpacing: 1,
                childAspectRatio: 1 / 1.53,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(
                    model.data!.products.length,
                    (index) => InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              ProductDetailsScreen(
                                  model.data!.products[index].id));
                        },
                        child: buildGridItem(
                            model.data!.products[index], context))),
              ),
            ),
          ],
        ),
      );
  Widget buildCategoryItem(DataModel model, context) => InkWell(
        onTap: () {
          ShopAppCubit.get(context).getCategoriesDetailData(model.id);
          navigateTo(context, CategoryProductsDetailsScreen(model.name));
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(model.image!),
                  )),
            ),
            Container(
                color: Colors.black.withOpacity(0.8),
                width: 100,
                child: Text(
                  model.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ))
          ],
        ),
      );
  Widget buildGridItem(ProductsModel model, context) => Container(
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
