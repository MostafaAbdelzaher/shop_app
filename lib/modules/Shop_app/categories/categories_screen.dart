import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';
import 'package:untitled/models/shop_app/categories_model.dart';

import '../../../shard/component/component.dart';
import 'category_products_Screen.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        CategoriesModel categoriesModel =
            ShopAppCubit.get(context).categoriesModel!;

        return ConditionalBuilder(
          condition: state is! ShopLoadingCategoryDataState,
          builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildCategoriesItemRow(
                  categoriesModel.data!.data[index], context),
              separatorBuilder: (context, index) => buildCategorySeparated(),
              itemCount: categoriesModel.data!.data.length),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

Widget buildCategoriesItemRow(DataModel model, context) => InkWell(
      onTap: () {
        ShopAppCubit.get(context).getCategoriesDetailData(model.id);
        navigateTo(context, CategoryProductsDetailsScreen(model.name));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(model.image!),
                    ))),
            SizedBox(
              width: 20,
            ),
            Text(
              model.name!,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
Widget buildCategorySeparated() => Container(
      height: 0.8,
      width: double.infinity,
      color: Colors.blueGrey,
    );
