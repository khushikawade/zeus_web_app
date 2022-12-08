import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;


  const CustomAppBar({required this.title}) ;

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar:AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 64.0,
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // showAddPeople(context);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 26.0, left: 20.0),
                child: SvgPicture.asset(
                  'images/hamburger.svg',
                  width: 18.0,
                  height: 12.0,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 26.0, left: 0.0),
              child: SvgPicture.asset(
                'images/logo.svg',
              ),
            ),


            const Spacer(),

            /* Container(
                width: MediaQuery.of(context).size.width * 0.22,
                margin: const EdgeInsets.only(left: 15.0, top: 26.0),
                height: 35.0,
                decoration: BoxDecoration(
                  color: const Color(0xff1E293B),
                  border: Border.all(color: const Color(0xff1E293B)),
                  borderRadius: BorderRadius.circular(
                    48.0,
                  ),
                ),
                child: TextFormField(
                  cursorColor: const Color(0xffFFFFFF),
                  style: const TextStyle(color: Color(0xffFFFFFF)),
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        bottom: 13.0,
                        top: 14.0,
                        right: 10,
                        left: 14.0,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            "images/search.svg",
                            color: const Color(0xff64748B),
                            width: 17.05,
                            height: 17.06,
                          ),
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: 'Search project',
                      hintStyle: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xff64748B),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400)),
                  onChanged: (value) {
                    //filterSearchResults(value);
                  },
                ),
              ),*/

            Container(
                width: 30.0,
                height: 30.0,
                margin: const EdgeInsets.only(
                  top: 26.0,
                  left: 10.0,
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  NetworkImage('https://picsum.photos/id/237/200/300'),
                )),

            Container(
              width: 16.0,
              height: 16.0,
              decoration: BoxDecoration(
                color: const Color(0xff334155),
                border: Border.all(color: const Color(0xff334155)),
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              margin: const EdgeInsets.only(
                top: 26.0,
                left: 8.0,
                right: 5.0,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SvgPicture.asset(
                  "images/drop_arrow.svg",
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );

  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(64.0);


}
