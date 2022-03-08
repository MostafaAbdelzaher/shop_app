import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/models/shop_app/login_model.dart';
import 'package:untitled/modules/Shop_app/login/cubit/cubit.dart';
import 'package:untitled/modules/Shop_app/login/cubit/states.dart';
import 'package:untitled/shard/component/component.dart';
import 'package:untitled/shard/nerwork/local/cache_helper.dart';
import 'package:untitled/shard/style/colors.dart';

import '../../../layout/Shop_app/shop_layout.dart';
import '../../../shard/component/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ShopRegisterCubit(),
        child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
          listener: (context, state) {
            if (state is ShopRegisterSuccessState) {
              if (state.registerModel.status!) {
                CacheHelper.saveData(
                        key: "token", value: state.registerModel.data!.token)
                    .then((value) {
                  token = state.registerModel.data!.token!;
                  navigateToAndFinish(context, ShopLayoutScreen());
                });
                showToast(
                    text: state.registerModel.message!,
                    state: ToastStates.SUCCESS);
              } else {
                showToast(
                    text: state.registerModel.message!,
                    state: ToastStates.ERROR);
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            "REGISTER",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Register now to browse our hot offers",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          defaultTextFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter your name";
                                }
                              },
                              type: TextInputType.name,
                              controller: nameController,
                              label: "User Name",
                              prefix: Icons.person),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter your Email Address";
                                }
                              },
                              type: TextInputType.emailAddress,
                              controller: emailController,
                              label: " Email Address  ",
                              prefix: Icons.email),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Enter your password";
                                }
                              },
                              type: TextInputType.visiblePassword,
                              controller: passwordController,
                              label: "Password",
                              prefix: Icons.lock),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                ShopRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Enter your phone";
                              }
                            },
                            type: TextInputType.phone,
                            controller: phoneController,
                            label: "Phone Number",
                            prefix: Icons.phone,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ConditionalBuilder(
                            condition: state is! ShopRegisterLoadingState,
                            builder: (context) => defaultButton(
                                text: "REGISTER",
                                color: defaultColor,
                                width: 250,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                }),
                            fallback: (context) => CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
