
import 'package:fitness4all/common/color_extensions.dart';
import 'package:fitness4all/common_widgets/round_button.dart';
import 'package:fitness4all/screen/home/Meals/meals_screen.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int selectPage = 0;
  PageController controller = PageController();
  final PocketBase pb = PocketBase('http://127.0.0.1:8090'); // Replace with your PocketBase URL
  List<Map<String, dynamic>> pageArr = [];

  @override
  void initState() {
    super.initState();
    _fetchOnboardingData();
    controller.addListener(() {
      setState(() {
        selectPage = controller.page?.round() ?? 0;
      });
    });
  }

  Future<void> _fetchOnboardingData() async {
    try {
      final result = await pb.collection('onboarding_data').getFullList();
      setState(() {
        pageArr = result.map((record) => record.toJson()).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch onboarding data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            alignment: Alignment.center,
            child: RoundButton(
                title: "Skip",
                height: 30,
                fontSize: 12,
                width: 70,
                fontWeight: FontWeight.w300,
                type: RoundButtonType.line,
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const MealsScreen()));
                }),
          )
        ],
      ),
      body: Stack(alignment: Alignment.center, children: [
        PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: (context, index) {
              var pObj = pageArr[index] as Map? ?? {};

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Text(
                    pObj["title"].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    pObj["subtitle"].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Image.asset(
                      pObj["image"],
                      width: MediaQuery.of(context).size.width * 0.65,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              );
            }),
        SafeArea(
            child: Column(
              children: [
                const Spacer(
                  flex: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pageArr.map((e) {
                    var index = pageArr.indexOf(e);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color:
                        index == selectPage ? TColor.primary : TColor.inactive,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(),
                RoundButton(
                    title: "Next",
                    width: 150,
                    onPressed: () {
                      if (selectPage >= pageArr.length - 1) {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => const MealsScreen()));
                      } else {
                        selectPage = selectPage + 1;
                        controller.animateToPage(
                          selectPage,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.bounceInOut,
                        );
                        setState(() {});
                      }
                    }),
                const Spacer(),
              ],
            ))
      ]),
    );
  }
}
