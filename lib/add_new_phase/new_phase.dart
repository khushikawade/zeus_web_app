import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeus/helper_widget/labeltextfield.dart';
import 'package:zeus/helper_widget/textformfield.dart';
import 'package:zeus/utility/validations.dart';

class NewPhase extends StatefulWidget {
  const NewPhase({Key? key}) : super(key: key);

  @override
  State<NewPhase> createState() => _NewPhaseState();
}

class _NewPhaseState extends State<NewPhase> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.zero,
        backgroundColor: const Color(0xff1E293B),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.99,
          height: MediaQuery.of(context).size.height * 0.99,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.11,
                          width: MediaQuery.of(context).size.width * 0.94,
                          decoration: const BoxDecoration(
                            color: Color(0xff283345),
                            //border: Border.all(color: const Color(0xff0E7490)),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16.0),
                              topLeft: Radius.circular(16.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x26000000),
                                offset: Offset(
                                  0.0,
                                  1.0,
                                ),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ), //BoxShadow
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              titleHeadlineWidget("New Phase", 22.0),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width:
                                          97.0, //MediaQuery.of(context).size.width * 0.22,
                                      margin: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        //border: Border.all(color:  const Color(0xff1E293B)),
                                        borderRadius: BorderRadius.circular(
                                          40.0,
                                        ),
                                      ),
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Color(0xffFFFFFF),
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      width:
                                          97, //MediaQuery.of(context).size.width * 0.22,
                                      margin: const EdgeInsets.only(
                                          top: 10.0, right: 20.0, bottom: 10.0),
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7DD3FC),
                                        //border: Border.all(color:  const Color(0xff1E293B)),
                                        borderRadius: BorderRadius.circular(
                                          40.0,
                                        ),
                                      ),

                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Color(0xff000000),
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            titleHeadlineWidget("Phases details", 18.0),
                          ],
                        ),
                      ],
                    ),
                    // Expanded(
                    //     flex: 1,
                    //     child: Container(
                    //       height: double.infinity,
                    //       child: SingleChildScrollView(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [],
                    //         ),
                    //       ),
                    //     ))
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                formField(
                  context: context,
                  labelText: "Phase Title",
                  hintText: 'Next Waves',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                formField(
                  labelText: "Phase Type",
                  context: context,
                  hintText: 'Design Phase',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 30.0),
                  // height: 50.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff334155),
                    //border: Border.all(color:  const Color(0xff1E293B)),
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xff475569),
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5.0, left: 0.0),
                        height: 35.0,
                        child: TextFormField(
                          cursorColor: const Color(0xffFFFFFF),
                          style: TextStyle(color: Color(0xffFFFFFF)),
                          textAlignVertical: TextAlignVertical.bottom,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                bottom: 16.0,
                                top: 0.0,
                                right: 10,
                                left: 15.0,
                              ),
                              prefixIcon: Container(
                                  child: Image.asset('images/date.png')),
                              border: InputBorder.none,
                              hintText: "",
                              // suffixIcon: Icon(Icons.cancel),
                              hintStyle: const TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xffFFFFFF),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400)),
                          onChanged: (value) {
                            //filterSearchResults(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                titleHeadlineWidget("Resources needed", 16.0),
                Row(
                  children: [
                    Container(
                      // width: 80.0,
                      // height: 80.0,
                      margin: const EdgeInsets.only(left: 27.0, top: 0.0),
                      decoration: BoxDecoration(
                        color: const Color(0xff334155),
                        borderRadius: BorderRadius.circular(
                          100.0,
                        ),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(34.0),
                          child: SvgPicture.asset(
                            'images/photo.svg',
                            width: 30.0,
                            height: 30.0,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  titleHeadlineWidget(String title, double i) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, top: 10.0, bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
            color: const Color(0xffFFFFFF),
            fontSize: i,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700),
      ),
    );
  }

  titleSubHeadlineWidget(String title, double i) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, top: 10.0, bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
            color: const Color(0xffFFFFFF),
            fontSize: i,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
