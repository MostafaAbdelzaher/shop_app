import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';

import '../../../models/shop_app/home_model.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
        );
      },
    );
  }
}

Widget build(ProductsModel model) => Container(child: Text("${model.name}"));
