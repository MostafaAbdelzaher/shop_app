import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';
import 'package:untitled/shard/style/colors.dart';

import '../../../models/shop_app/detail_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final id;
  ProductDetailsScreen(this.id);
  var pageControlLar = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopAppCubit>(context)
        ..getProductData(id.toString()),
      child: BlocConsumer<ShopAppCubit, ShopAppStates>(
          listener: (context, stata) {},
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Product Details',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                body: ConditionalBuilder(
                  condition: state is! ShopLoadingGetProductDetailsDataStats,
                  builder: (context) => buiDetails(
                    context,
                    ShopAppCubit.get(context).productDetailsModel,
                  ),
                  fallback: (context) => Center(
                      child: Padding(
                    padding: const EdgeInsets.all(55.0),
                    child: LinearProgressIndicator(
                      minHeight: 5,
                    ),
                  )),
                ));
          }),
    );
  }

  Widget buiDetails(
    context,
    ProductDetailsModel? model,
  ) {
    List<Widget> images = [];
    model!.data.images.forEach((element) {
      images.add(Image.network(
        element,
        fit: BoxFit.contain,
      ));
    });
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Text(
            model.data.name!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          CarouselSlider(
              items: images,
              options: CarouselOptions(
                onPageChanged: (x, s) {
                  ShopAppCubit.get(context).changeIndex(x);
                },
                height: 250,
              )),
          SizedBox(
            height: 10,
          ),
          Center(
            child: AnimatedSmoothIndicator(
                effect: const ExpandingDotsEffect(
                  dotHeight: 7,
                  dotWidth: 15,
                  spacing: 1,
                ),
                activeIndex: ShopAppCubit.get(context).currentIndex,
                count: images.length),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                "${model.data.price.toString()} EGP",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Description",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            model.data.description!,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
