import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';

import '../../controller/phone verify.dart';
import '../../controller/variable.dart';
import '../Widget/communbutton.dart';
import '../Widget/height_width.dart';
import 'register_screen.dart';

class Otpenternumber extends StatefulWidget {
  const Otpenternumber({Key? key}) : super(key: key);

  @override
  State<Otpenternumber> createState() => _OtpenternumberState();
}

class _OtpenternumberState extends State<Otpenternumber>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  List tabText = [
    "PHONE",
    "EMAIL",
  ];

  @override
  void initState() {
    tabController = TabController(length: tabText.length, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  TextEditingController controller1 = TextEditingController();
  var _contrycode = 'IN';
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height * 0.04),
            Container(
              height: height * 0.19,
              width: width * 0.37,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 65,
              ),
            ),
            SizedBox(height: height * 0.04),
            TabBar(
              labelPadding: EdgeInsets.only(bottom: height * 0.02),
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.label,
              physics: const BouncingScrollPhysics(),
              labelColor: Colors.grey,
              indicatorColor: Colors.black,
              isScrollable: true,
              tabs: List.generate(
                tabText.length,
                (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.11),
                    child: Text("${tabText[index]}")),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  Column(
                    children: [
                      SizedBox(height: height * 0.05),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.070),
                        child: Container(
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              CountryCodePicker(
                                onChanged: (cc) {
                                  _contrycode = cc.code!;
                                },
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: _contrycode,
                                favorite: ['+91', 'IN'],
                                // optional. Shows only country name and flag
                                showCountryOnly: false,

                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
                              ),
                              const VerticalDivider(
                                thickness: 1,
                                color: Color(0xff707070),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: number,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    hintText: '123 456 7890',
                                    hintStyle: const TextStyle(
                                        color: Color(0xffB6B7B7), fontSize: 18),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      const Text(
                        textAlign: TextAlign.center,
                        "You my receive SMS notifications from us for security and\nlogin purposes",
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                      SizedBox(height: height * 0.05),
                      commonbutton(height * 0.060, width * 0.65, () {
                        abc();
                      }, 'Next'),
                    ],
                  ),
                  const LoginPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
