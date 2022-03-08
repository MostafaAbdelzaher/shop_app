import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';
import 'package:untitled/modules/Shop_app/login/shop_login.dart';
import 'package:untitled/shard/component/component.dart';
import 'package:untitled/shard/nerwork/local/cache_helper.dart';
import 'package:untitled/shard/style/colors.dart';

import '../../../layout/Shop_app/cubit/cubit.dart';

class ProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopAppCubit.get(context).userModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return Scaffold(
          appBar: AppBar(),
          body: ConditionalBuilder(
            condition: model != null,
            fallback: (context) => CircularProgressIndicator(),
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    if (state is ShopLoadingUpdateDataState)
                      LinearProgressIndicator(
                        backgroundColor: defaultColor,
                        color: Colors.blueGrey,
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        isOutLine: true,
                        type: TextInputType.text,
                        controller: nameController,
                        label: "Name",
                        prefix: Icons.person),
                    SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        isOutLine: true,
                        type: TextInputType.text,
                        controller: emailController,
                        label: "Email Address",
                        prefix: Icons.email),
                    SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        isOutLine: true,
                        type: TextInputType.number,
                        controller: phoneController,
                        label: "Phone",
                        prefix: Icons.phone),
                    SizedBox(height: 10),
                    defaultButton(
                        text: "UPDATE",
                        width: 350,
                        function: () {
                          ShopAppCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text);
                        }),
                    Image(
                      image: AssetImage("assets/images/shopApp.jpg"),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
