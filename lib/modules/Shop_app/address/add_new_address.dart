import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/Shop_app/cubit/cubit.dart';
import 'package:untitled/layout/Shop_app/cubit/states.dart';
import 'package:untitled/shard/component/component.dart';
import 'package:untitled/shard/style/colors.dart';

class AddNewAddress extends StatelessWidget {
  final bool isUpdate;
  final String? name;
  final String? city;
  final String? region;
  final String? details;
  final String? notes;
  final int? id;

  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  var addAddressFormKey = GlobalKey<FormState>();

  AddNewAddress(
      {Key? key,
      required this.isUpdate,
      this.name,
      this.city,
      this.region,
      this.details,
      this.notes,
      this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopAppCubit, ShopAppStates>(
      listener: (context, state) {
        if (state is ShopAppAddAddressSuccessState) {
          if (state.addressModel.status!) {
            showToast(
                text: state.addressModel.message!, state: ToastStates.SUCCESS);
            Navigator.pop(context);
          } else {
            showToast(
                text: state.addressModel.message!, state: ToastStates.ERROR);
          }
        } else if (state is ShopAppUpdateAddressSuccessState) {
          if (state.updateAddressModel!.status) {
            showToast(
                text: state.updateAddressModel!.message!,
                state: ToastStates.SUCCESS);
            Navigator.pop(context);
          } else {
            showToast(
                text: state.updateAddressModel!.message!,
                state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        if (isUpdate) {
          nameController.text = name!;
          cityController.text = city!;
          regionController.text = region!;
          detailsController.text = details!;
          notesController.text = notes!;
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            actions: [
              TextButton(
                  onPressed: () {
                    if (addAddressFormKey.currentState!.validate()) {
                      if (isUpdate) {
                        ShopAppCubit.get(context).updateAddress(
                            addressId: id,
                            name: nameController.text,
                            city: cityController.text,
                            region: regionController.text,
                            details: detailsController.text,
                            notes: notesController.text);
                      } else {
                        ShopAppCubit.get(context).addAddress(
                            name: nameController.text,
                            city: cityController.text,
                            region: regionController.text,
                            details: detailsController.text,
                            notes: notesController.text);
                      }
                    }
                  },
                  child: Text(
                    "save",
                    style: TextStyle(fontSize: 16),
                  ))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                  key: addAddressFormKey,
                  child: Column(
                    children: [
                      if (state is ShopAppAddAddressLoadingState ||
                          state is ShopAppUpdateAddressSuccessState)
                        Column(
                          children: [
                            LinearProgressIndicator(
                              color: defaultColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      Container(
                        padding: EdgeInsetsDirectional.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(25)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Name',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextFormField(
                                  controller: nameController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    hintText: ' Location name',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                    border: UnderlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cant be Empty';
                                    }
                                  }),
                              const SizedBox(
                                height: 40,
                              ),
                              const Text(
                                'City',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextFormField(
                                  controller: cityController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    hintText: 'Please enter your City name',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                    border: UnderlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cant be Empty';
                                    }
                                  }),
                              const SizedBox(
                                height: 40,
                              ),
                              const Text(
                                'Region',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextFormField(
                                  controller: regionController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    hintText: 'Please enter your region',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                    border: UnderlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cant be Empty';
                                    }
                                  }),
                              const SizedBox(
                                height: 40,
                              ),
                              const Text(
                                'Details',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextFormField(
                                  controller: detailsController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    hintText: 'Please enter some details',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                    border: UnderlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cant be Empty';
                                    }
                                  }),
                              const SizedBox(
                                height: 40,
                              ),
                              const Text(
                                'Notes',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextFormField(
                                  controller: notesController,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Please add some notes to help find you',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 17),
                                    border: UnderlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cant be Empty';
                                    }
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                            ]),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
