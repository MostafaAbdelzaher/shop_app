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
import '../register_screen/register_screen.dart';

class ShopLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ShopLoginCubit(),
        child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
          listener: (context, state) {
            if (state is ShopLoginSuccessState) {
              if (state.loginModel.status!) {
                CacheHelper.saveData(
                        key: "token", value: state.loginModel.data!.token)
                    .then((value) {
                  token=state.loginModel.data!.token!;
                  navigateToAndFinish(context, ShopLayoutScreen());
                });
                showToast(
                    text: state.loginModel.message!,
                    state: ToastStates.SUCCESS);
              } else {
                showToast(
                    text: state.loginModel.message!, state: ToastStates.ERROR);
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
                          Image(
                            image: AssetImage("assets/images/2.PNG"),
                            height: 350,
                            width: 300,
                          ),
                          Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Login now to browse our hot offers",
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
                                  return "Email is not be empty";
                                }
                              },
                              type: TextInputType.text,
                              controller: emailController,
                              label: "Email Address",
                              prefix: Icons.email),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                              showPassword:
                                  ShopLoginCubit.get(context).isPassword,
                              onFieldSubmitted: (value) {
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Password is not be empty";
                                }
                              },
                              type: TextInputType.text,
                              controller: passwordController,
                              label: "Password Address",
                              prefix: Icons.lock,
                              suffixPress: () {
                                ShopLoginCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              suffix: ShopLoginCubit.get(context).suffix),
                          SizedBox(
                            height: 15,
                          ),
                          ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            builder: (context) => defaultButton(
                                text: "LOGIN",
                                color: defaultColor,
                                width: 250,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                }),
                            fallback: (context) => CircularProgressIndicator(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "don\'t have an account?",
                                style: TextStyle(fontSize: 13),
                              ),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                  child: Text("Register now"))
                            ],
                          )
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
