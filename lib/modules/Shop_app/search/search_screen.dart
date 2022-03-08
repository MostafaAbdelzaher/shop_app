import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';

import '../../../shard/component/component.dart';
import '../favorites/favorite_screen.dart';
import '../product_details/product_details.dart';

class ShopAppSearch extends StatelessWidget {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.grey[400],
                ),
                width: double.infinity,
                height: 45,
                child: TextFormField(
                  controller: searchController,
                  cursorColor: HexColor("#2a5f99"),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  onFieldSubmitted: (String value) {
                    ShopAppCubit.get(context).getSearchData(value);
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      suffixIcon: Icon(Icons.search),
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (state is ShopLoadingSearchDataStatus)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(),
              ),
            if (state is ShopSuccessSearchDataStatus)
              Expanded(
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            navigateTo(
                                context,
                                ProductDetailsScreen(ShopAppCubit.get(context)
                                    .searchModel!
                                    .data!
                                    .data![index]
                                    .id));
                          },
                          child: buildListProduct(
                              ShopAppCubit.get(context)
                                  .searchModel!
                                  .data!
                                  .data![index],
                              context),
                        ),
                    separatorBuilder: (context, index) =>
                        buildCategorySeparated(),
                    itemCount: ShopAppCubit.get(context)
                        .searchModel!
                        .data!
                        .data!
                        .length),
              ),
          ]),
        );
      },
    );
  }
}
