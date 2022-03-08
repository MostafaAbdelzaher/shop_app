import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled/shard/component/component.dart';
import 'package:untitled/shard/nerwork/local/cache_helper.dart';

import '../../../shard/style/colors.dart';
import '../login/shop_login.dart';

class OnBoardingModel {
  final String? image;
  final String? title;
  final String? body;
  OnBoardingModel({this.image, this.title, this.body});
}

class OnBoardingScreen extends StatelessWidget {
  var boardController = PageController();
  List<OnBoardingModel> boarding = [
    OnBoardingModel(
      image: "assets/images/1.jpg",
      title: 'Explore',
      body:
          'Choose What ever the Product you wish for with the easiest way possible using Salla',
    ),
    OnBoardingModel(
      image: "assets/images/2.PNG",
      body: 'Pay with the safest way possible either by cash or credit cards',
      title: 'Make the Payment',
    ),
    OnBoardingModel(
      image: "assets/images/3.PNG",
      body:
          'Yor Order will be shipped to you as fast as possible by our carrier',
      title: 'Shipping',
    ),
  ];
  bool? isLast = false;
  @override
  Widget build(BuildContext context) {
    void submit() {
      CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
        if (value) {
          navigateToAndFinish(context, ShopLoginScreen());
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: submit,
              child: Text(
                "Skip",
                style: Theme.of(context).appBarTheme.textTheme?.bodyText1,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    isLast = true;
                    print(isLast);
                  } else {
                    isLast = false;
                    print(isLast);
                  }
                },
                controller: boardController,
                itemBuilder: (context, index) => boardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: boarding.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5,
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast!) {
                      submit();
                    } else {
                      boardController.nextPage(
                          duration: Duration(
                            seconds: 1,
                          ),
                          curve: Curves.fastOutSlowIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                )
              ],
            )
          ]),
        ));
  }

  Widget boardingItem(model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: AssetImage("${model.image}"),
              width: 300,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("${model.title}"),
          SizedBox(height: 10),
          Text("${model.body}"),
        ],
      );
}
