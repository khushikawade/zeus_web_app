import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/helper_widget/custom_search_dropdown.dart';
import 'package:zeus/people_module/create_people/create_people_page.dart';
import 'package:zeus/people_module/people_home/people_home_view_model.dart';
import 'package:zeus/project_module/create_project/create_project.dart';
import 'package:zeus/project_module/project_detail/project_home_view_model.dart';
import 'package:zeus/project_module/project_detail/project_home_view.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/user_module/logout_module/logout_view.dart';
import 'package:zeus/utility/debouncer.dart';
import 'package:zeus/utility/dropdrowndata.dart';
import 'package:zeus/utility/util.dart';
import '../helper_widget/search_view.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../utility/app_url.dart';
import '../utility/colors.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:http_parser/http_parser.dart';
import '../utility/constant.dart';
import '../utility/upertextformate.dart';
import 'package:zeus/helper_widget/custom_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomePage extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  final ValueChanged<String> adOnSubmit;

  const MyHomePage({Key? key, required this.onSubmit, required this.adOnSubmit})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _NavigationRailState();
}

class _NavigationRailState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // AutoCompleteTextField? searchTextField;
  final fieldText = TextEditingController();
  final searchController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Datum>> key = new GlobalKey();
  static List<Datum> users = <Datum>[];
  bool loading = true;
  List<int>? _selectedFile;
  GlobalKey<FormState> _addFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> abc = [];
  List<String> selectedDaysList = List.empty(growable: true);
  Debouncer _debouncer = Debouncer();
  bool peopleListTapIcon = false;
  bool projectListTapIcon = true;
  bool cameraTapIcon = false;
  bool circleTapIcon = false;
  bool bellTapIcon = false;
  bool settingIcon = false;
  bool createButtonClick = false;
  TypeAheadFormField? searchTextField;
  final TextEditingController _typeAheadController = TextEditingController();

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  bool ishover = false;
  var startTime;
  var endTime;
  String validateName = '';
  String validNickName = '';
  String validateCountry = '';
  String validateCity = '';

  var startTime1;
  var endTime2;
  bool selectDepartment = false;
  bool selectSalary = false;
  bool selectDays = false;
  bool selectSkill = false;
  bool selectTime = false;
  bool selectTimeZone = false;
  bool selectImage = false;
  bool saveButtonClick = false;
  bool createProjectValidate = true;
  String name_ = '';

  getformattedTime(TimeOfDay time) {
    DateTime tempDate = DateFormat("hh:mm")
        .parse(time.hour.toString() + ":" + time.minute.toString());
    var dateFormat = DateFormat("h:mm a"); // you can change the format here
    print(dateFormat.format(tempDate));
    return dateFormat.format(tempDate);
  }

  var prefs;

  void change() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('val', 'q');
  }

  Future? getList;

  Future getListData() {
    return Provider.of<ProjectHomeViewModel>(context, listen: true)
        .changeProfile();
  }

  @override
  void didChangeDependencies() {
    getList = getListData();
    super.didChangeDependencies();
  }

  List<Datum> getSuggestions(String query) {
    List<Datum> matches = List.empty(growable: true);
    matches.addAll(users);
    matches.retainWhere(
        (s) => s.title!.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Image? image;
  Uint8List? webImage;

  Future? _getTag;
  List addSkills = [];

  String name1 = '';
  bool _autoValidate = false;

  String capitalize(String value) {
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  List _addtag = [];

  void getUsers() async {
    var token = 'Bearer ' + storage.read("token");
    var response = await http.get(
      Uri.parse(AppUrl.tags_search),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
    );
    if (response.statusCode == 200) {
      print("skills sucess");
      var user = userFromJson(response.body);
      users = user.data!;

      setState(() {
        loading = false;
      });
    } else if (response.statusCode == 401) {
      AppUtil.showErrorDialog(context);
    } else {
      print("Error getting users.");
    }
  }

  MyDropdownData myDropdownData = MyDropdownData();
  int _selectedIndex = 1;
  DateTime selectedDate = DateTime.now();
  String dropdownvalue = 'Item 1';
  ImagePicker picker = ImagePicker();
  String? _depat;
  String? _curren, _time, _day, _shortday;

  String name = '';

  List _department = [];
  List<DropdownModel>? departmentlist;
  List<DropdownModel>? selecTimeZoneList = [];
  List<DropdownModel>? selectDaysList;
  var items1 = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  int? position = 0;
  List _accountableId = [];
  List _customerName = [];
  List _currencyName = [];
  List<DropdownModel>? currencyList = [];
  List _statusList = [];
  List _timeline = [];
  List addTag = [];
  List<String> _tag1 = [];
  bool? _isSelected;

  List<String>? addTag1 = [];
  List<int> add1 = [1];
  bool imageavail = false;

  var isIndex = 0;
  var isLoading = false;

  @override
  void initState() {
    Provider.of<ProjectHomeViewModel>(context, listen: false)
        .getPeopleIdel(searchText: '');
    getUsers();
    change();
    _isSelected = false;

    getAddpeople();

    getTagpeople();
    getDepartment();
    getAccountable();
    getCustomer();
    getCurrency();
    getSelectStatus();
    getTimeline();
    super.initState();
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _nickName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _designation = TextEditingController();
  final TextEditingController _association = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  final TextEditingController _salaryCurrency = TextEditingController();
  final TextEditingController _availableDay = TextEditingController();
  final TextEditingController _availableTime = TextEditingController();
  final TextEditingController _search = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _enterCity = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();

  final ScrollController verticalScroll = ScrollController();

  final List<Widget> _mainContents = [
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Home',
        style: TextStyle(fontSize: 40),
      ),
    ),
    ProjectHome(),
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
    Container(
      child: const Navigator(
        onGenerateRoute: generateRoute,
        initialRoute: '/peopleList',
      ),
    ),
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
  ];

  //Create project_detail popup
  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              backgroundColor: const Color(0xff1E293B),
              content: Form(
                  key: _addFormKey,
                  child: CreateProjectPage(
                    formKey: _addFormKey,
                    response: null,
                  )),
            ),
          );
        });
  }

  //Create project_detail popup
  void showAlertDialogPeople(BuildContext context) async {
    bool result = await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              backgroundColor: const Color(0xff1E293B),
              content: Form(
                  key: _formKey,
                  child: CreatePeoplePage(
                    formKey: _formKey,
                    response: null,
                    isEdit: false,
                  )),
            ),
          );
        });

    if (result != null && result) {
      Provider.of<PeopleHomeViewModel>(context, listen: false)
          .getPeopleDataList(searchText: '');

      setState(() {});
    }
  }

  //Add people popup
  // showAddPeople(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         abc.clear();
  //         //---------------sayyam
  //         selectDaysList = [];
  //         items1.forEach((element) {
  //           selectDaysList!.add(DropdownModel('', element));
  //         });
  //         imageavail = false;

  //         createButtonClick = false;

  //         _day = '';

  //         selectedDaysList.clear();
  //         return StatefulBuilder(
  //           builder: (context, setStateView) => AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //             contentPadding: EdgeInsets.zero,
  //             backgroundColor: const Color(0xff1E293B),
  //             content: Form(
  //               key: _formKey,
  //               child: SizedBox(
  //                 width: MediaQuery.of(context).size.width * 0.99,
  //                 height: MediaQuery.of(context).size.height * 0.99,
  //                 child: RawScrollbar(
  //                   controller: verticalScroll,
  //                   thumbColor: const Color(0xff4b5563),
  //                   crossAxisMargin: 2,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   thickness: 8,
  //                   child: ListView(
  //                     controller: verticalScroll,
  //                     shrinkWrap: true,
  //                     children: [
  //                       Container(
  //                           height: 87,
  //                           decoration: const BoxDecoration(
  //                             color: Color(0xff283345),
  //                             borderRadius: BorderRadius.only(
  //                               topRight: Radius.circular(16.0),
  //                               topLeft: Radius.circular(16.0),
  //                             ),
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Color(0x26000000),
  //                                 offset: Offset(
  //                                   0.0,
  //                                   1.0,
  //                                 ),
  //                                 blurRadius: 0.0,
  //                                 spreadRadius: 0.0,
  //                               ),
  //                             ],
  //                           ),
  //                           child: Row(
  //                             children: [
  //                               Container(
  //                                 margin: const EdgeInsets.only(
  //                                     left: 30.0, top: 10.0, bottom: 10.0),
  //                                 child: const Text(
  //                                   "Add People",
  //                                   style: TextStyle(
  //                                       color: Color(0xffFFFFFF),
  //                                       fontSize: 22.0,
  //                                       fontFamily: 'Inter',
  //                                       fontWeight: FontWeight.w700),
  //                                 ),
  //                               ),
  //                               Spacer(),
  //                               Container(
  //                                 width: 97.0,
  //                                 margin: const EdgeInsets.only(
  //                                     top: 10.0, bottom: 10.0),
  //                                 height: 40.0,
  //                                 decoration: BoxDecoration(
  //                                   color: const Color(0xff334155),
  //                                   borderRadius: BorderRadius.circular(
  //                                     40.0,
  //                                   ),
  //                                 ),
  //                                 child: InkWell(
  //                                   onTap: () {
  //                                     _name.clear();
  //                                     _nickName.clear();
  //                                     _bio.clear();
  //                                     _password.clear();
  //                                     _designation.clear();
  //                                     _association.clear();
  //                                     _salary.clear();
  //                                     _salaryCurrency.clear();
  //                                     _availableDay.clear();
  //                                     _availableTime.clear();
  //                                     _search.clear();
  //                                     _country.clear();
  //                                     _enterCity.clear();
  //                                     _phoneNumber.clear();
  //                                     _emailAddress.clear();
  //                                     _depat = null;
  //                                     _curren = null;
  //                                     _time = null;
  //                                     startTime1 = null;
  //                                     endTime2 = null;
  //                                     webImage = null;
  //                                     webImage = null;
  //                                     selectImage = false;
  //                                     selectTimeZone = false;
  //                                     selectSalary = false;
  //                                     selectSkill = false;
  //                                     selectDepartment = false;
  //                                     selectDays = false;
  //                                     selectTime = false;

  //                                     if (selectDepartment == false ||
  //                                         selectSalary == false ||
  //                                         selectSkill == false ||
  //                                         selectTimeZone == false ||
  //                                         selectImage == false ||
  //                                         selectDays == false ||
  //                                         selectTime == false) {
  //                                       saveButtonClick = false;
  //                                     }
  //                                     Navigator.of(context).pop();
  //                                   },
  //                                   child: const Align(
  //                                     alignment: Alignment.center,
  //                                     child: Text(
  //                                       "Cancel",
  //                                       style: TextStyle(
  //                                           fontSize: 14.0,
  //                                           color: Color(0xffFFFFFF),
  //                                           fontFamily: 'Inter',
  //                                           fontWeight: FontWeight.w700),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               const SizedBox(
  //                                 width: 16,
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     top: 10.0, right: 30.0, bottom: 10.0),
  //                                 child: InkWell(
  //                                   onTap: () {
  //                                     setStateView(() {
  //                                       createProjectValidate = true;
  //                                       createButtonClick = true;
  //                                     });

  //                                     if (_formKey.currentState!.validate()) {
  //                                       Future.delayed(
  //                                           const Duration(microseconds: 500),
  //                                           () {
  //                                         if (createProjectValidate) {
  //                                           if (selectImage == true &&
  //                                               selectDepartment == true &&
  //                                               selectDays == true &&
  //                                               selectSalary == true &&
  //                                               selectSkill == true &&
  //                                               selectTime == true &&
  //                                               selectTimeZone == true) {
  //                                             SmartDialog.showLoading(
  //                                               msg:
  //                                                   "Your request is in progress please wait for a while...",
  //                                             );

  //                                             createPeople(
  //                                                 context, setStateView);
  //                                           }
  //                                         }
  //                                       });
  //                                     }
  //                                     setStateView(() {
  //                                       saveButtonClick = true;
  //                                     });
  //                                   },
  //                                   child: Container(
  //                                     width: 97,
  //                                     margin: const EdgeInsets.only(),
  //                                     height: 40.0,
  //                                     decoration: BoxDecoration(
  //                                       color: const Color(0xff7DD3FC),
  //                                       borderRadius: BorderRadius.circular(
  //                                         40.0,
  //                                       ),
  //                                     ),
  //                                     child: const Align(
  //                                       alignment: Alignment.center,
  //                                       child: Text(
  //                                         "Save",
  //                                         style: TextStyle(
  //                                             fontSize: 14.0,
  //                                             color: Color(0xff000000),
  //                                             fontFamily: 'Inter',
  //                                             fontWeight: FontWeight.w700),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           )),
  //                       Row(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         children: [
  //                           Expanded(
  //                             flex: 1,
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Row(
  //                                   children: [
  //                                     Container(
  //                                         width: 120.0.sp,
  //                                         height: 120.0.sp,
  //                                         margin: EdgeInsets.only(
  //                                             left: 27.0, top: 28),
  //                                         decoration: BoxDecoration(
  //                                           color: const Color(0xff334155),
  //                                           borderRadius:
  //                                               BorderRadius.circular(200.0.r),
  //                                         ),
  //                                         child: ClipRRect(
  //                                           borderRadius:
  //                                               BorderRadius.circular(200.0.r),
  //                                           child: imageavail
  //                                               ? Image.memory(
  //                                                   webImage!,
  //                                                   fit: BoxFit.fill,
  //                                                 )
  //                                               : Padding(
  //                                                   padding:
  //                                                       EdgeInsets.all(46.0),
  //                                                   child: SvgPicture.asset(
  //                                                     'images/photo.svg',
  //                                                     height: 36.0.h,
  //                                                     width: 36.0.w,
  //                                                   )),
  //                                         )),
  //                                     Column(
  //                                       children: [
  //                                         Padding(
  //                                           padding: EdgeInsets.only(
  //                                               left: 48.0.sp, top: 57.0.sp),
  //                                           child: InkWell(
  //                                             onTap: () async {
  //                                               final image =
  //                                                   await ImagePickerWeb
  //                                                       .getImageAsBytes();
  //                                               setStateView(() {
  //                                                 webImage = image!;
  //                                                 imageavail = true;
  //                                                 selectImage = true;
  //                                               });
  //                                             },
  //                                             child: Container(
  //                                               height: 35.0.h,
  //                                               width: MediaQuery.of(context)
  //                                                       .size
  //                                                       .width *
  //                                                   0.11.w,
  //                                               // margin: const EdgeInsets.only(
  //                                               //     left: 48.0, top: 57.0),
  //                                               decoration: BoxDecoration(
  //                                                 color:
  //                                                     const Color(0xff334155),
  //                                                 //color: Colors.red,
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(
  //                                                   40.0.r,
  //                                                 ),
  //                                               ),
  //                                               child: Row(
  //                                                 children: [
  //                                                   Container(
  //                                                     margin:
  //                                                         const EdgeInsets.only(
  //                                                             left: 16.0),
  //                                                     child: const Icon(
  //                                                         Icons.camera_alt,
  //                                                         size: 18,
  //                                                         color: Color(
  //                                                             0xffFFFFFF)),
  //                                                   ),
  //                                                   Container(
  //                                                     margin: EdgeInsets.only(
  //                                                         left: 11.0.sp),
  //                                                     child: Flexible(
  //                                                       child: Text(
  //                                                         "Upload new",
  //                                                         overflow:
  //                                                             TextOverflow.fade,
  //                                                         style: TextStyle(
  //                                                             color: Color(
  //                                                                 0xffFFFFFF),
  //                                                             fontSize: 14.0.sp,
  //                                                             fontFamily:
  //                                                                 'Inter',
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .w500),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         Row(
  //                                           children: [
  //                                             SizedBox(width: 10),
  //                                             saveButtonClick
  //                                                 ? selectImage
  //                                                     ? const Text(
  //                                                         " ",
  //                                                       )
  //                                                     : Padding(
  //                                                         padding:
  //                                                             const EdgeInsets
  //                                                                 .only(
  //                                                           top: 8,
  //                                                           left: 0,
  //                                                         ),
  //                                                         child: errorWidget())
  //                                                 : Text(''),
  //                                           ],
  //                                         )
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 Container(
  //                                   margin: const EdgeInsets.only(
  //                                       left: 30.0, top: 30.0),
  //                                   child: const Text(
  //                                     "About you",
  //                                     style: TextStyle(
  //                                         color: Color(0xffFFFFFF),
  //                                         fontSize: 18.0,
  //                                         fontStyle: FontStyle.normal,
  //                                         fontFamily: 'Inter-Bold',
  //                                         fontWeight: FontWeight.w700),
  //                                   ),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 16.0,
  //                                 ),

  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                     right: 25,
  //                                     left: 30.0,
  //                                     bottom: 0,
  //                                   ),
  //                                   child: CustomFormField(
  //                                     controller: _name,
  //                                     hint: 'Enter name',
  //                                     label: 'Name',
  //                                     fontSizeForLabel: 14,
  //                                     contentpadding: EdgeInsets.only(
  //                                         left: 16,
  //                                         bottom: 10,
  //                                         right: 10,
  //                                         top: 10),
  //                                     hintTextHeight: 1.7,
  //                                     validator: (value) {
  //                                       RegExp regex = RegExp(r'^[a-z A-Z]+$',
  //                                           caseSensitive: false);
  //                                       if (value.isEmpty) {
  //                                         setState(() {
  //                                           createProjectValidate = false;
  //                                         });

  //                                         return 'Please enter';
  //                                       } else if (!regex.hasMatch(value)) {
  //                                         setState(() {
  //                                           createProjectValidate = false;
  //                                         });
  //                                         return 'Please enter valid name';
  //                                       }
  //                                       return null;
  //                                     },
  //                                     onChange: (text) =>
  //                                         setState(() => name_ = text),
  //                                   ),
  //                                 ),
  //                                 //  const SizedBox(
  //                                 //   height: 16.0,
  //                                 // ),

  //                                 // Stack(
  //                                 //   children: [
  //                                 //     Column(
  //                                 //       crossAxisAlignment:
  //                                 //           CrossAxisAlignment.start,
  //                                 //       children: [
  //                                 //         Container(
  //                                 //           width: MediaQuery.of(context)
  //                                 //                   .size
  //                                 //                   .width *
  //                                 //               0.99,
  //                                 //           margin: const EdgeInsets.only(
  //                                 //               left: 30.0,
  //                                 //               top: 5.0,
  //                                 //               right: 25.0,
  //                                 //               bottom: 10),
  //                                 //           height: 56.0,
  //                                 //           decoration: BoxDecoration(
  //                                 //             color: const Color(0xff334155),
  //                                 //             borderRadius:
  //                                 //                 BorderRadius.circular(
  //                                 //               8.0,
  //                                 //             ),
  //                                 //             boxShadow: const [
  //                                 //               BoxShadow(
  //                                 //                 color: Color(0xff475569),
  //                                 //                 offset: Offset(
  //                                 //                   0.0,
  //                                 //                   2.0,
  //                                 //                 ),
  //                                 //                 blurRadius: 0.0,
  //                                 //                 spreadRadius: 0.0,
  //                                 //               ),
  //                                 //             ],
  //                                 //           ),
  //                                 //         ),
  //                                 //       ],
  //                                 //     ),
  //                                 //     Container(
  //                                 //         margin: const EdgeInsets.only(
  //                                 //             top: 14.0, left: 45.0),
  //                                 //         child: const Text(
  //                                 //           "Nickname",
  //                                 //           style: TextStyle(
  //                                 //               fontSize: 11.0,
  //                                 //               color: Color(0xff64748B),
  //                                 //               fontFamily: 'Inter',
  //                                 //               fontWeight: FontWeight.w500),
  //                                 //         )),
  //                                 //     TextFormField(
  //                                 //       controller: _nickName,
  //                                 //       cursorColor: const Color(0xffFFFFFF),
  //                                 //       style: const TextStyle(
  //                                 //           color: Color(0xffFFFFFF)),
  //                                 //       textAlignVertical:
  //                                 //           TextAlignVertical.bottom,
  //                                 //       keyboardType: TextInputType.text,
  //                                 //       maxLength: 30,
  //                                 //       decoration: const InputDecoration(
  //                                 //           counterText: "",
  //                                 //           contentPadding: EdgeInsets.only(
  //                                 //             bottom: 16.0,
  //                                 //             top: 45.0,
  //                                 //             right: 10,
  //                                 //             left: 45.0,
  //                                 //           ),
  //                                 //           errorStyle: TextStyle(
  //                                 //               fontSize: 14, height: 0.20),
  //                                 //           border: InputBorder.none,
  //                                 //           hintText: 'Enter nickname',
  //                                 //           hintStyle: TextStyle(
  //                                 //               fontSize: 14.0,
  //                                 //               color: Color(0xffFFFFFF),
  //                                 //               fontFamily: 'Inter',
  //                                 //               fontWeight: FontWeight.w400)),
  //                                 //       autovalidateMode: _addSubmitted
  //                                 //           ? AutovalidateMode.onUserInteraction
  //                                 //           : AutovalidateMode.disabled,
  //                                 //       validator: (value) {
  //                                 //         if (value!.isEmpty) {
  //                                 //           return 'Please enter';
  //                                 //         }
  //                                 //         return null;
  //                                 //       },
  //                                 //       onChanged: (text) =>
  //                                 //           setStateView(() => name1 = text),
  //                                 //     ),
  //                                 //   ],
  //                                 // ),

  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                       right: 25, left: 30.0, bottom: 0),
  //                                   child: CustomFormField(
  //                                     controller: _nickName,
  //                                     hint: 'Enter nickname',
  //                                     label: 'Nickname',
  //                                     fontSizeForLabel: 14,
  //                                     contentpadding: EdgeInsets.only(
  //                                         left: 16,
  //                                         bottom: 10,
  //                                         right: 10,
  //                                         top: 10),
  //                                     hintTextHeight: 1.7,
  //                                     validator: (value) {
  //                                       if (value.isEmpty) {
  //                                         setState(() {
  //                                           createProjectValidate = false;
  //                                         });

  //                                         return 'Please enter';
  //                                       }
  //                                       return null;
  //                                     },
  //                                     onChange: (text) =>
  //                                         setState(() => name_ = text),
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                     right: 25,
  //                                     left: 30.0,
  //                                   ),
  //                                   child: CustomFormField(
  //                                     controller: _bio,
  //                                     maxline: 4,
  //                                     fontSizeForLabel: 14,
  //                                     hint: 'Enter your bio',
  //                                     label: 'Your bio',
  //                                     contentpadding: EdgeInsets.only(
  //                                         left: 16,
  //                                         bottom: 10,
  //                                         right: 10,
  //                                         top: 10),
  //                                     hintTextHeight: 1.7,
  //                                     validator: (value) {
  //                                       if (value.isEmpty) {
  //                                         setState(() {
  //                                           createProjectValidate = false;
  //                                         });

  //                                         return 'Please enter';
  //                                       }
  //                                       return null;
  //                                     },
  //                                     onChange: (text) =>
  //                                         setState(() => name_ = text),
  //                                   ),
  //                                 ),
  //                                 // Stack(
  //                                 //   children: [
  //                                 //     Container(
  //                                 //       width:
  //                                 //           MediaQuery.of(context).size.width *
  //                                 //               0.99,
  //                                 //       margin: const EdgeInsets.only(
  //                                 //           left: 30.0, top: 16.0, right: 25.0),
  //                                 //       height: 110.0,
  //                                 //       decoration: const BoxDecoration(
  //                                 //         color: Color(0xff334155),
  //                                 //         borderRadius: BorderRadius.only(
  //                                 //           topRight: Radius.circular(8.0),
  //                                 //           topLeft: Radius.circular(8.0),
  //                                 //         ),
  //                                 //         boxShadow: [
  //                                 //           BoxShadow(
  //                                 //             color: Color(0xff475569),
  //                                 //             offset: Offset(
  //                                 //               0.0,
  //                                 //               2.0,
  //                                 //             ),
  //                                 //             blurRadius: 0.0,
  //                                 //             spreadRadius: 0.0,
  //                                 //           ),
  //                                 //         ],
  //                                 //       ),
  //                                 //     ),
  //                                 //     Container(
  //                                 //         margin: const EdgeInsets.only(
  //                                 //             top: 22.0, left: 45.0),
  //                                 //         child: const Text(
  //                                 //           "Your bio",
  //                                 //           style: TextStyle(
  //                                 //               fontSize: 11.0,
  //                                 //               color: Color(0xff64748B),
  //                                 //               fontFamily: 'Inter',
  //                                 //               fontWeight: FontWeight.w500),
  //                                 //         )),
  //                                 //     TextFormField(
  //                                 //       maxLines: 5,
  //                                 //       controller: _bio,
  //                                 //       cursorColor: const Color(0xffFFFFFF),
  //                                 //       style: const TextStyle(
  //                                 //           color: Color(0xffFFFFFF)),
  //                                 //       textAlignVertical:
  //                                 //           TextAlignVertical.bottom,
  //                                 //       keyboardType: TextInputType.text,
  //                                 //       decoration: const InputDecoration(
  //                                 //           counterText: "",
  //                                 //           errorStyle: TextStyle(
  //                                 //               fontSize: 14, height: 0.20),
  //                                 //           contentPadding: EdgeInsets.only(
  //                                 //             bottom: 10.0,
  //                                 //             top: 47.0,
  //                                 //             right: 40,
  //                                 //             left: 45.0,
  //                                 //           ),
  //                                 //           border: InputBorder.none,
  //                                 //           hintText: 'Enter your bio',
  //                                 //           hintStyle: TextStyle(
  //                                 //               fontSize: 14.0,
  //                                 //               color: Color(0xffFFFFFF),
  //                                 //               fontFamily: 'Inter',
  //                                 //               fontWeight: FontWeight.w400)),
  //                                 //       autovalidateMode: _addSubmitted
  //                                 //           ? AutovalidateMode.onUserInteraction
  //                                 //           : AutovalidateMode.disabled,
  //                                 //       validator: (value) {
  //                                 //         if (value!.isEmpty) {
  //                                 //           return 'Please enter';
  //                                 //         }
  //                                 //         return null;
  //                                 //       },
  //                                 //       onChanged: (text) =>
  //                                 //           setStateView(() => name1 = text),
  //                                 //     ),
  //                                 //   ],
  //                                 // ),

  //                                 Padding(
  //                                   padding: const EdgeInsets.only(top: 3.0),
  //                                   child: Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.start,
  //                                     mainAxisSize: MainAxisSize.max,
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       Expanded(
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.only(
  //                                             right: 16.0,
  //                                             left: 30.0,
  //                                           ),
  //                                           child: CustomFormField(
  //                                             controller: _designation,
  //                                             maxLength: 20,
  //                                             fontSizeForLabel: 14,
  //                                             hint: 'Enter ',
  //                                             label: 'Designation',
  //                                             contentpadding: EdgeInsets.only(
  //                                                 left: 16,
  //                                                 bottom: 10,
  //                                                 right: 10,
  //                                                 top: 10),
  //                                             hintTextHeight: 1.7,
  //                                             validator: (value) {
  //                                               if (value.isEmpty) {
  //                                                 setState(() {
  //                                                   createProjectValidate =
  //                                                       false;
  //                                                 });

  //                                                 return 'Please enter';
  //                                               }
  //                                               return null;
  //                                             },
  //                                             onChange: (text) =>
  //                                                 setState(() => name_ = text),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       // Expanded(
  //                                       //   child: Stack(
  //                                       //     children: [
  //                                       //       Container(
  //                                       // width: MediaQuery.of(context)
  //                                       //         .size
  //                                       //         .width *
  //                                       //     0.12,
  //                                       //         margin: const EdgeInsets.only(
  //                                       //             left: 30.0, right: 16.0),
  //                                       //         height: 56.0,
  //                                       //         decoration: BoxDecoration(
  //                                       //           color:
  //                                       //               const Color(0xff334155),
  //                                       //           borderRadius:
  //                                       //               BorderRadius.circular(
  //                                       //             8.0,
  //                                       //           ),
  //                                       //           boxShadow: const [
  //                                       //             BoxShadow(
  //                                       //               color: Color(0xff475569),
  //                                       //               offset: Offset(
  //                                       //                 0.0,
  //                                       //                 2.0,
  //                                       //               ),
  //                                       //               blurRadius: 0.0,
  //                                       //               spreadRadius: 0.0,
  //                                       //             ),
  //                                       //           ],
  //                                       //         ),
  //                                       //       ),
  //                                       //       Container(
  //                                       //           margin: const EdgeInsets.only(
  //                                       //               top: 23.0, left: 45.0),
  //                                       //           child: const Text(
  //                                       //             "Designation",
  //                                       //             style: TextStyle(
  //                                       //                 fontSize: 11.0,
  //                                       //                 color:
  //                                       //                     Color(0xff64748B),
  //                                       //                 fontFamily: 'Inter',
  //                                       //                 fontWeight:
  //                                       //                     FontWeight.w500),
  //                                       //           )),
  //                                       //       TextFormField(
  //                                       //         controller: _designation,
  //                                       //         // inputFormatters: [
  //                                       //         //   UpperCaseTextFormatter()
  //                                       //         // ],
  //                                       //         maxLength: 20,
  //                                       //         cursorColor:
  //                                       //             const Color(0xffFFFFFF),
  //                                       //         style: const TextStyle(
  //                                       //             color: Color(0xffFFFFFF)),
  //                                       //         textAlignVertical:
  //                                       //             TextAlignVertical.bottom,
  //                                       //         keyboardType:
  //                                       //             TextInputType.text,
  //                                       //         decoration:
  //                                       //             const InputDecoration(
  //                                       //                 counterText: "",
  //                                       //                 errorStyle: TextStyle(
  //                                       //                     fontSize: 14,
  //                                       //                     height: 0.20),
  //                                       //                 contentPadding:
  //                                       //                     EdgeInsets.only(
  //                                       //                   bottom: 16.0,
  //                                       //                   top: 53.0,
  //                                       //                   right: 10,
  //                                       //                   left: 45.0,
  //                                       //                 ),
  //                                       //                 border:
  //                                       //                     InputBorder.none,
  //                                       //                 hintText: 'Enter',
  //                                       //                 hintStyle: TextStyle(
  //                                       //                     fontSize: 14.0,
  //                                       //                     color: Color(
  //                                       //                         0xffFFFFFF),
  //                                       //                     fontFamily: 'Inter',
  //                                       //                     fontWeight:
  //                                       //                         FontWeight
  //                                       //                             .w500)),
  //                                       //         autovalidateMode: _addSubmitted
  //                                       //             ? AutovalidateMode
  //                                       //                 .onUserInteraction
  //                                       //             : AutovalidateMode.disabled,
  //                                       //         validator: (value) {
  //                                       //           if (value!.isEmpty) {
  //                                       //             return 'Please enter';
  //                                       //           }
  //                                       //           return null;
  //                                       //         },
  //                                       //         onChanged: (text) =>
  //                                       //             setStateView(
  //                                       //                 () => name1 = text),
  //                                       //       ),
  //                                       //     ],
  //                                       //   ),
  //                                       // ),

  //                                       SizedBox(
  //                                         width: 8,
  //                                       ),

  //                                       Expanded(
  //                                         child: Padding(
  //                                           padding:
  //                                               EdgeInsets.only(right: 30.sp),
  //                                           child: CustomSearchDropdown(
  //                                             hint: 'Select',
  //                                             label: "Department",
  //                                             errorText: createButtonClick ==
  //                                                         true &&
  //                                                     (_depat == null ||
  //                                                         _depat!.isEmpty)
  //                                                 ? 'Please Select this field'
  //                                                 : '',
  //                                             items: departmentlist!,
  //                                             onChange: ((value) {
  //                                               // _curren = value.id;
  //                                               _depat = value.id;
  //                                               setStateView(() {
  //                                                 selectDepartment = true;
  //                                               });
  //                                             }),
  //                                           ),
  //                                         ),
  //                                       )
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                       right: 25, left: 30.0, bottom: 0),
  //                                   child: CustomFormField(
  //                                     controller: _association,
  //                                     maxLength: 30,
  //                                     hint: 'Enter team name',
  //                                     label: "Associated with",
  //                                     fontSizeForLabel: 14,
  //                                     contentpadding: EdgeInsets.only(
  //                                         left: 16,
  //                                         bottom: 10,
  //                                         right: 10,
  //                                         top: 10),
  //                                     hintTextHeight: 1.7,
  //                                     validator: (value) {
  //                                       if (value.isEmpty) {
  //                                         setState(() {
  //                                           createProjectValidate = false;
  //                                         });

  //                                         return 'Please enter';
  //                                       }
  //                                       return null;
  //                                     },
  //                                     onChange: (text) =>
  //                                         setState(() => name_ = text),
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   margin: const EdgeInsets.only(
  //                                       left: 30.0, top: 0.0),
  //                                   child: const Text(
  //                                     "Salary",
  //                                     style: TextStyle(
  //                                         color: Color(0xffFFFFFF),
  //                                         fontSize: 18.0,
  //                                         fontFamily: 'Inter',
  //                                         fontWeight: FontWeight.w700),
  //                                   ),
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: Padding(
  //                                         padding: EdgeInsets.only(
  //                                             top: 14.sp,
  //                                             left: 26.0.sp,
  //                                             bottom: 0),
  //                                         child: CustomSearchDropdown(
  //                                           hint: 'Select',
  //                                           label: "A",
  //                                           errorText: createButtonClick &&
  //                                                   (_curren == null ||
  //                                                       _curren!.isEmpty)
  //                                               ? 'Please Select this field'
  //                                               : '',
  //                                           items: currencyList!,
  //                                           onChange: ((value) {
  //                                             _curren = value.id;
  //                                             setStateView(() {
  //                                               selectSalary = true;
  //                                             });
  //                                           }),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       width: 8.w,
  //                                     ),
  //                                     Expanded(
  //                                       flex: 2,
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.only(
  //                                             top: 14, right: 50, bottom: 0),
  //                                         child: CustomFormField(
  //                                           controller: _salary,
  //                                           maxLength: 15,
  //                                           hint: '0.00',
  //                                           label: "Monthly Salary",
  //                                           fontSizeForLabel: 14,
  //                                           contentpadding: EdgeInsets.only(
  //                                               left: 16,
  //                                               bottom: 10,
  //                                               right: 10,
  //                                               top: 10),
  //                                           hintTextHeight: 1.7,
  //                                           validator: (value) {
  //                                             RegExp regex = RegExp(
  //                                                 r'^\D+|(?<=\d),(?=\d)');
  //                                             if (value.isEmpty) {
  //                                               setState(() {
  //                                                 createProjectValidate = false;
  //                                               });

  //                                               return 'Please enter';
  //                                             } else if (regex
  //                                                 .hasMatch(value)) {
  //                                               setState(() {
  //                                                 createProjectValidate = false;
  //                                               });
  //                                               return 'Please enter valid salary';
  //                                             }
  //                                             return null;
  //                                           },
  //                                           onChange: (text) =>
  //                                               setState(() => name_ = text),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     SizedBox(
  //                                       width: 11.w,
  //                                     ),
  //                                     Expanded(
  //                                       child: Container(
  //                                         height: 56,
  //                                       ),
  //                                     )
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Container(
  //                               height:
  //                                   MediaQuery.of(context).size.height * 1.2,
  //                               child: const VerticalDivider(
  //                                 color: Color(0xff94A3B8),
  //                                 thickness: 0.2,
  //                               )),
  //                           Expanded(
  //                             flex: 1,
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Container(
  //                                   margin: const EdgeInsets.only(
  //                                       left: 30.0, top: 27.0),
  //                                   child: const Text(
  //                                     "Availabilty",
  //                                     style: TextStyle(
  //                                         color: Color(0xffFFFFFF),
  //                                         fontSize: 18.0,
  //                                         fontFamily: 'Inter',
  //                                         fontWeight: FontWeight.w700),
  //                                   ),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 8.0,
  //                                 ),
  //                                 Stack(
  //                                   children: [
  //                                     // Column(
  //                                     //   crossAxisAlignment:
  //                                     //       CrossAxisAlignment.start,
  //                                     //   mainAxisAlignment:
  //                                     //       MainAxisAlignment.start,
  //                                     //   children: [
  //                                     //     Container(
  //                                     //       width: MediaQuery.of(context)
  //                                     //               .size
  //                                     //               .width *
  //                                     //           0.26,
  //                                     //       margin: const EdgeInsets.only(
  //                                     //           left: 30.0, right: 29.6),
  //                                     //       height: 56.0,
  //                                     //       decoration: BoxDecoration(
  //                                     //         color: const Color(0xff334155),
  //                                     //         borderRadius:
  //                                     //             BorderRadius.circular(
  //                                     //           8.0,
  //                                     //         ),
  //                                     //         boxShadow: const [
  //                                     //           BoxShadow(
  //                                     //             color: Color(0xff475569),
  //                                     //             offset: Offset(
  //                                     //               0.0,
  //                                     //               2.0,
  //                                     //             ),
  //                                     //             blurRadius: 0.0,
  //                                     //             spreadRadius: 0.0,
  //                                     //           )
  //                                     //         ],
  //                                     //       ),
  //                                     //     ),
  //                                     //     handleAllerrorWidget(selectDays)
  //                                     //   ],
  //                                     // ),
  //                                     // Container(
  //                                     //     margin: const EdgeInsets.only(
  //                                     //         top: 6.0, left: 45.0),
  //                                     //     child: const Text(
  //                                     //       "Select days",
  //                                     //       style: TextStyle(
  //                                     //           fontSize: 11.0,
  //                                     //           color: Color(0xff64748B),
  //                                     //           fontFamily: 'Inter',
  //                                     //           fontWeight: FontWeight.w500),
  //                                     //     )),
  //                                     // Container(
  //                                     //   margin: const EdgeInsets.only(
  //                                     //       left: 30.0,
  //                                     //       right: 55,
  //                                     //       top: 26,
  //                                     //       bottom: 10),
  //                                     //   height: 20.0,
  //                                     //   child: Container(
  //                                     //       margin: const EdgeInsets.only(
  //                                     //           left: 16.0, right: 20.0),
  //                                     //       child: StatefulBuilder(
  //                                     //         builder: (BuildContext context,
  //                                     //             StateSettersetState) {
  //                                     //           return DropdownButtonHideUnderline(
  //                                     //             child: CustomDropdownButton(
  //                                     //               dropdownColor:
  //                                     //                   ColorSelect.class_color,
  //                                     //               underline: Container(),
  //                                     //               hint: const Text(
  //                                     //                 "Select",
  //                                     //                 style: TextStyle(
  //                                     //                     fontSize: 14.0,
  //                                     //                     color:
  //                                     //                         Color(0xffFFFFFF),
  //                                     //                     fontFamily: 'Inter',
  //                                     //                     fontWeight:
  //                                     //                         FontWeight.w500),
  //                                     //               ),
  //                                     //               // isExpanded: true,
  //                                     //               icon: const Icon(
  //                                     //                 Icons.arrow_drop_down,
  //                                     //                 color: Color(0xff64748B),
  //                                     //               ),
  //                                     //               items: items1
  //                                     //                   .map((String items1) {
  //                                     //                 return DropdownMenuItem(
  //                                     //                   value: items1,
  //                                     //                   child: Text(items1,
  //                                     //                       style: (const TextStyle(
  //                                     //                           color: Colors
  //                                     //                               .white))),
  //                                     //                 );
  //                                     //               }).toList(),
  //                                     //               onChanged:
  //                                     //                   (String? newValue) {
  //                                     //                 setStateView(() {
  //                                     //                   _day = newValue;
  //                                     //                   _shortday = _day!
  //                                     //                       .substring(0, 3);
  //                                     //                   if (selectedDaysList
  //                                     //                       .isNotEmpty) {
  //                                     //                     if (selectedDaysList
  //                                     //                         .contains(
  //                                     //                             _shortday)) {
  //                                     //                     } else {
  //                                     //                       selectedDaysList
  //                                     //                           .add(_shortday!
  //                                     //                               .toString());
  //                                     //                       selectDays = true;
  //                                     //                     }
  //                                     //                   } else {
  //                                     //                     selectedDaysList.add(
  //                                     //                         _shortday!
  //                                     //                             .toString());
  //                                     //                     selectDays = true;
  //                                     //                   }
  //                                     //                 });
  //                                     //               },
  //                                     //             ),
  //                                     //           );
  //                                     //         },
  //                                     //       )),
  //                                     // ),

  //                                     Expanded(
  //                                       child: Padding(
  //                                         padding: EdgeInsets.only(
  //                                             right: 29.6.sp,
  //                                             left: 25.0.sp,
  //                                             bottom: 0),
  //                                         child: CustomSearchDropdown(
  //                                           hint: 'Select days',
  //                                           label: "Select",
  //                                           errorText: createButtonClick &&
  //                                                   (_day == null ||
  //                                                       _day!.isEmpty)
  //                                               ? 'Please Select this field'
  //                                               : '',
  //                                           items: selectDaysList!,
  //                                           onChange: ((value) {
  //                                             setStateView(() {
  //                                               _day = value.item;
  //                                               _shortday =
  //                                                   _day!.substring(0, 3);
  //                                               if (selectedDaysList
  //                                                   .isNotEmpty) {
  //                                                 if (selectedDaysList
  //                                                     .contains(_shortday)) {
  //                                                 } else {
  //                                                   selectedDaysList.add(
  //                                                       _shortday!.toString());
  //                                                   selectDays = true;
  //                                                 }
  //                                               } else {
  //                                                 selectedDaysList.add(
  //                                                     _shortday!.toString());
  //                                                 selectDays = true;
  //                                               }
  //                                             });
  //                                           }),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 selectedDaysList.isNotEmpty
  //                                     ? SizedBox(
  //                                         height: 30,
  //                                         child: Padding(
  //                                           padding: EdgeInsets.only(left: 26),
  //                                           child: ListView.builder(
  //                                             scrollDirection: Axis.horizontal,
  //                                             itemCount:
  //                                                 selectedDaysList.length,
  //                                             itemBuilder: (context, index) {
  //                                               return Container(
  //                                                 margin: const EdgeInsets.only(
  //                                                     left: 12.0),
  //                                                 child: InputChip(
  //                                                   shape: RoundedRectangleBorder(
  //                                                       borderRadius:
  //                                                           BorderRadius.all(
  //                                                               Radius.circular(
  //                                                                   8))),
  //                                                   deleteIcon: Icon(
  //                                                     Icons.close,
  //                                                     color: Colors.white,
  //                                                     size: 20,
  //                                                   ),
  //                                                   backgroundColor:
  //                                                       Color(0xff334155),
  //                                                   visualDensity:
  //                                                       VisualDensity.compact,
  //                                                   materialTapTargetSize:
  //                                                       MaterialTapTargetSize
  //                                                           .shrinkWrap,
  //                                                   label: Text(
  //                                                     selectedDaysList[index],
  //                                                     style: TextStyle(
  //                                                         color: Colors.white),
  //                                                   ),
  //                                                   selected: _isSelected!,
  //                                                   onSelected:
  //                                                       (bool selected) {
  //                                                     setStateView(() {
  //                                                       _isSelected = selected;
  //                                                       print(
  //                                                           "_isSelected--------------------------${_isSelected}");
  //                                                     });
  //                                                   },
  //                                                   onDeleted: () {
  //                                                     setStateView(() {
  //                                                       selectedDaysList
  //                                                           .removeAt(index);
  //                                                     });
  //                                                   },
  //                                                   showCheckmark: false,
  //                                                 ),
  //                                               );
  //                                             },
  //                                           ),
  //                                         ),
  //                                       )
  //                                     : Container(),
  //                                 selectedDaysList.isNotEmpty
  //                                     ? const SizedBox(
  //                                         height: 15,
  //                                       )
  //                                     : Container(),
  //                                 Stack(
  //                                   children: [
  //                                     Column(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.start,
  //                                       children: [
  //                                         Padding(
  //                                           padding: EdgeInsets.only(
  //                                               right: 29.6.sp,
  //                                               left: 25.0.sp,
  //                                               bottom: 0),
  //                                           child: Container(
  //                                             height: 57.h,
  //                                             decoration: BoxDecoration(
  //                                               color: const Color(0xff334155),
  //                                               borderRadius:
  //                                                   BorderRadius.circular(
  //                                                 8.0,
  //                                               ),
  //                                               boxShadow: const [
  //                                                 BoxShadow(
  //                                                   color: Color(0xff475569),
  //                                                   offset: Offset(
  //                                                     0.0,
  //                                                     2.0,
  //                                                   ),
  //                                                   blurRadius: 0.0,
  //                                                   spreadRadius: 0.0,
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         handleAllerrorWidget(selectTime)
  //                                       ],
  //                                     ),
  //                                     Container(
  //                                         margin: const EdgeInsets.only(
  //                                           top: 11.0,
  //                                           left: 45.0,
  //                                         ),
  //                                         child: Text(
  //                                           "Select time",
  //                                           style: TextStyle(
  //                                               fontSize: 11.sp,
  //                                               color: Color(0xff64748B),
  //                                               fontFamily: 'Inter',
  //                                               fontWeight: FontWeight.w500),
  //                                         )),
  //                                     Container(
  //                                         margin: const EdgeInsets.only(
  //                                           bottom: 16.0,
  //                                           top: 28.0,
  //                                           right: 10,
  //                                           left: 45.0,
  //                                         ),
  //                                         child: Text(
  //                                           startTime1 != null &&
  //                                                   startTime1.isNotEmpty &&
  //                                                   endTime2 != null &&
  //                                                   endTime2.isNotEmpty
  //                                               ? "$startTime1 - $endTime2"
  //                                               : '',
  //                                           style: TextStyle(
  //                                               fontSize: 14.sp,
  //                                               color: Colors.white,
  //                                               fontFamily: 'Inter',
  //                                               fontWeight: FontWeight.w500),
  //                                         )),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 20,
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                       left: 16, right: 16),
  //                                   child: TimeRange(
  //                                       fromTitle: const Text(
  //                                         'From',
  //                                         style: TextStyle(
  //                                             fontSize: 14,
  //                                             color: Colors.white),
  //                                       ),
  //                                       toTitle: const Text(
  //                                         'To',
  //                                         style: TextStyle(
  //                                             fontSize: 14,
  //                                             color: Colors.white),
  //                                       ),
  //                                       titlePadding: 16,
  //                                       textStyle: const TextStyle(
  //                                           fontWeight: FontWeight.normal,
  //                                           color: Colors.white),
  //                                       activeTextStyle: const TextStyle(
  //                                           fontWeight: FontWeight.bold,
  //                                           color: Colors.white),
  //                                       borderColor: Colors.white,
  //                                       backgroundColor: Colors.transparent,
  //                                       activeBackgroundColor: Colors.green,
  //                                       firstTime:
  //                                           TimeOfDay(hour: 8, minute: 30),
  //                                       lastTime:
  //                                           TimeOfDay(hour: 20, minute: 00),
  //                                       timeStep: 10,
  //                                       timeBlock: 30,
  //                                       onRangeCompleted: (range) {
  //                                         setStateView(() {
  //                                           startTime = range!.start;
  //                                           endTime = range.end;
  //                                           startTime1 =
  //                                               getformattedTime(startTime);
  //                                           endTime2 =
  //                                               getformattedTime(endTime);
  //                                           selectTime = true;
  //                                         });
  //                                       }),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 20.0,
  //                                 ),
  //                                 Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     Container(
  //                                       margin: const EdgeInsets.only(
  //                                           left: 30.0, bottom: 12),
  //                                       child: const Text(
  //                                         "Skills",
  //                                         style: TextStyle(
  //                                             color: Color(0xffFFFFFF),
  //                                             fontSize: 18.0,
  //                                             fontFamily: 'Inter',
  //                                             fontWeight: FontWeight.w700),
  //                                       ),
  //                                     ),
  //                                     Container(
  //                                         width: 40.0,
  //                                         height: 40.0,
  //                                         margin: const EdgeInsets.only(
  //                                           right: 60,
  //                                         ),
  //                                         decoration: const BoxDecoration(
  //                                           color: Color(0xff334155),
  //                                           shape: BoxShape.circle,
  //                                         ),
  //                                         child: Container(
  //                                           child: Padding(
  //                                               padding:
  //                                                   const EdgeInsets.all(10.0),
  //                                               child: SvgPicture.asset(
  //                                                   'images/tag_new.svg')),
  //                                         )),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 2,
  //                                 ),
  //                                 Column(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   children: [
  //                                     Container(
  //                                       padding: EdgeInsets.only(
  //                                         left: 5,
  //                                         right: 5,
  //                                       ),
  //                                       margin: EdgeInsets.only(
  //                                           right: 30.5.sp,
  //                                           left: 25.0.sp,
  //                                           top: 20.sp),
  //                                       height: 49.0.h,
  //                                       decoration: BoxDecoration(
  //                                         color: const Color(0xff334155),
  //                                         borderRadius: BorderRadius.circular(
  //                                           48.0.r,
  //                                         ),
  //                                       ),
  //                                       child: Column(
  //                                         children: [
  //                                           searchTextField =
  //                                               TypeAheadFormField(
  //                                             keepSuggestionsOnLoading: false,
  //                                             suggestionsBoxVerticalOffset: 0.0,
  //                                             suggestionsBoxDecoration:
  //                                                 SuggestionsBoxDecoration(
  //                                                     color: Color(0xff0F172A)),
  //                                             hideOnLoading: true,
  //                                             suggestionsCallback: (pattern) {
  //                                               return getSuggestions(pattern);
  //                                             },
  //                                             textFieldConfiguration:
  //                                                 TextFieldConfiguration(
  //                                               controller:
  //                                                   _typeAheadController,
  //                                               style: const TextStyle(
  //                                                   color: Colors.white,
  //                                                   fontSize: 14.0),
  //                                               keyboardType:
  //                                                   TextInputType.text,
  //                                               cursorColor: Colors.white,
  //                                               autofocus: true,
  //                                               decoration:
  //                                                   const InputDecoration(
  //                                                 // border: InputBorder.none,
  //                                                 contentPadding:
  //                                                     EdgeInsets.only(
  //                                                         top: 15.0, left: 10),
  //                                                 prefixIcon: Padding(
  //                                                     padding: EdgeInsets.only(
  //                                                         top: 4.0),
  //                                                     child: Icon(
  //                                                       Icons.search,
  //                                                       color:
  //                                                           Color(0xff64748B),
  //                                                     )),
  //                                                 hintText: 'Search',
  //                                                 hintStyle: TextStyle(
  //                                                     fontSize: 14.0,
  //                                                     color: Colors.white,
  //                                                     fontFamily: 'Inter',
  //                                                     fontWeight:
  //                                                         FontWeight.w400),
  //                                                 border: InputBorder.none,
  //                                               ),
  //                                             ),
  //                                             itemBuilder: (context, item) {
  //                                               return Padding(
  //                                                 padding:
  //                                                     const EdgeInsets.all(8.0),
  //                                                 child: Text(
  //                                                   item.title.toString(),
  //                                                   style: const TextStyle(
  //                                                       fontSize: 16.0,
  //                                                       color: Colors.white),
  //                                                 ),
  //                                               );
  //                                               // Text("khushi");
  //                                               // rowResourceName(item);
  //                                             },
  //                                             transitionBuilder: (context,
  //                                                 suggestionsBox, controller) {
  //                                               return suggestionsBox;
  //                                             },
  //                                             onSuggestionSelected: (item) {
  //                                               setStateView(() {
  //                                                 searchTextField!
  //                                                     .textFieldConfiguration
  //                                                     .controller!
  //                                                     .text = '';

  //                                                 if (abc.isNotEmpty) {
  //                                                   if (abc
  //                                                       .contains(item.title)) {
  //                                                   } else {
  //                                                     abc.add(item.title!);
  //                                                   }
  //                                                 } else {
  //                                                   abc.add(item.title!);
  //                                                 }
  //                                               });
  //                                             },
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     handleAllerrorWidget(selectSkill),
  //                                     Padding(
  //                                       padding: EdgeInsets.only(left: 30),
  //                                       child: Wrap(
  //                                         spacing: 5,
  //                                         runSpacing: 5,
  //                                         children: List.generate(
  //                                           abc.length,
  //                                           (index) {
  //                                             return Container(
  //                                               height: 32,
  //                                               margin: const EdgeInsets.only(
  //                                                   left: 5.0, right: 5.0),
  //                                               child: InputChip(
  //                                                 shape:
  //                                                     const RoundedRectangleBorder(
  //                                                         borderRadius:
  //                                                             BorderRadius.all(
  //                                                                 Radius
  //                                                                     .circular(
  //                                                                         8))),
  //                                                 deleteIcon: const Icon(
  //                                                   Icons.close,
  //                                                   color: Colors.white,
  //                                                   size: 20,
  //                                                 ),
  //                                                 backgroundColor:
  //                                                     Color(0xff334155),
  //                                                 visualDensity:
  //                                                     VisualDensity.compact,
  //                                                 materialTapTargetSize:
  //                                                     MaterialTapTargetSize
  //                                                         .shrinkWrap,
  //                                                 label: Text(
  //                                                   abc[index],
  //                                                   style: TextStyle(
  //                                                       color: Colors.white),
  //                                                 ),
  //                                                 onSelected: (bool selected) {
  //                                                   setState(() {
  //                                                     _isSelected = selected;
  //                                                   });
  //                                                 },
  //                                                 onDeleted: () {
  //                                                   setState(() {
  //                                                     abc.removeAt(index);
  //                                                   });
  //                                                 },
  //                                                 showCheckmark: false,
  //                                               ),
  //                                             );
  //                                           },
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Container(
  //                               height:
  //                                   MediaQuery.of(context).size.height * 1.2,
  //                               child: const VerticalDivider(
  //                                 color: Color(0xff94A3B8),
  //                                 thickness: 0.2,
  //                               )),
  //                           Expanded(
  //                             flex: 1,
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Container(
  //                                   margin: const EdgeInsets.only(
  //                                       left: 30.0, top: 27.0),
  //                                   child: const Text(
  //                                     "Contact info",
  //                                     style: TextStyle(
  //                                         color: Color(0xffFFFFFF),
  //                                         fontSize: 18.0,
  //                                         fontFamily: 'Inter',
  //                                         fontWeight: FontWeight.w700),
  //                                   ),
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 8.0,
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.only(
  //                                     left: 30,
  //                                     right: 30,
  //                                   ),
  //                                   child: Column(
  //                                     children: [
  //                                       CustomFormField(
  //                                         maxLength: 20,
  //                                         controller: _country,
  //                                         hint: 'Enter country',
  //                                         label: "Country",
  //                                         fontSizeForLabel: 14,
  //                                         contentpadding: EdgeInsets.only(
  //                                             left: 16,
  //                                             bottom: 10,
  //                                             right: 10,
  //                                             top: 10),
  //                                         hintTextHeight: 1.7,
  //                                         validator: (value) {
  //                                           RegExp regex =
  //                                               RegExp(r'^[a-z A-Z]+$');
  //                                           if (value.isEmpty) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });

  //                                             return 'Please enter';
  //                                           } else if (!regex.hasMatch(value)) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });

  //                                             return 'Please enter valid  country name';
  //                                           }
  //                                           return null;
  //                                         },
  //                                         onChange: (text) =>
  //                                             setState(() => name_ = text),
  //                                       ),
  //                                       CustomFormField(
  //                                         maxLength: 20,
  //                                         controller: _enterCity,
  //                                         hint: 'Enter city',
  //                                         label: "City",
  //                                         fontSizeForLabel: 14,
  //                                         contentpadding: EdgeInsets.only(
  //                                             left: 16,
  //                                             bottom: 10,
  //                                             right: 10,
  //                                             top: 10),
  //                                         hintTextHeight: 1.7,
  //                                         validator: (value) {
  //                                           RegExp regex =
  //                                               RegExp(r'^[a-z A-Z]+$');
  //                                           if (value.isEmpty) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });

  //                                             return 'Please enter';
  //                                           } else if (!regex.hasMatch(value)) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });

  //                                             return 'Please enter valid  city name';
  //                                           }
  //                                           return null;
  //                                         },
  //                                         onChange: (text) =>
  //                                             setState(() => name_ = text),
  //                                       ),
  //                                       CustomFormField(
  //                                         maxLength: 10,
  //                                         controller: _phoneNumber,
  //                                         hint: 'Enter number',
  //                                         label: "Phone number",
  //                                         fontSizeForLabel: 14,
  //                                         contentpadding: EdgeInsets.only(
  //                                             left: 16,
  //                                             bottom: 10,
  //                                             right: 10,
  //                                             top: 10),
  //                                         hintTextHeight: 1.7,
  //                                         validator: (value) {
  //                                           String pattern =
  //                                               r'(^(?:[+0]9)?[0-9]{10}$)';
  //                                           RegExp regExp = new RegExp(pattern);
  //                                           if (value.isEmpty) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });

  //                                             return 'Please enter';
  //                                           } else if (!regExp
  //                                               .hasMatch(value)) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });

  //                                             return 'Please enter valid mobile number';
  //                                           }
  //                                           return null;
  //                                         },
  //                                         onChange: (text) =>
  //                                             setState(() => name_ = text),
  //                                       ),
  //                                       CustomFormField(
  //                                         maxLength: 20,
  //                                         controller: _emailAddress,
  //                                         hint: 'Enter email address',
  //                                         label: "Email address",
  //                                         fontSizeForLabel: 14,
  //                                         contentpadding: EdgeInsets.only(
  //                                             left: 16,
  //                                             bottom: 10,
  //                                             right: 10,
  //                                             top: 10),
  //                                         hintTextHeight: 1.7,
  //                                         validator: (value) {
  //                                           RegExp regex = RegExp(
  //                                               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  //                                           if (value.isEmpty) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });

  //                                             return 'Please enter email';
  //                                           } else if (!regex.hasMatch(value)) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });

  //                                             return 'Enter valid Email';
  //                                           }
  //                                           if (regex.hasMatch(values)) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });
  //                                             return 'please enter valid email';
  //                                           }
  //                                           if (value.length > 50) {
  //                                             setState(() {
  //                                               createProjectValidate = false;
  //                                             });
  //                                             return 'No more length 50';
  //                                           }
  //                                           return null;
  //                                         },
  //                                         onChange: (text) =>
  //                                             setState(() => name_ = text),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Stack(
  //                                   children: [
  //                                     Expanded(
  //                                       child: Padding(
  //                                         padding: EdgeInsets.only(
  //                                             right: 29.6.sp,
  //                                             left: 25.0.sp,
  //                                             bottom: 0),
  //                                         child: CustomSearchDropdown(
  //                                           hint: "Select timezone",
  //                                           label: "Select",
  //                                           errorText: createButtonClick &&
  //                                                   (_time == null ||
  //                                                       _time!.isEmpty)
  //                                               ? 'Please Select this field'
  //                                               : '',
  //                                           items: selecTimeZoneList!,
  //                                           onChange: ((value) {
  //                                             setStateView(() {
  //                                               _time = value.item;
  //                                               print("account:$_time");
  //                                               selectTimeZone = true;
  //                                             });
  //                                           }),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),

  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQueryData.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          // resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xff0F172A),
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            toolbarHeight: 70.h,
            backgroundColor: const Color(0xff0F172A),
            elevation: 0,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5.sp, right: 5.sp),
                      width: 475.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xff1e293b),
                        borderRadius: BorderRadius.circular(
                          42.r,
                        ),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (val) {
                          try {
                            _debouncer.run(() async {
                              if (projectListTapIcon) {
                                if (val != null && val.isNotEmpty) {
                                  await Provider.of<ProjectHomeViewModel>(
                                          context,
                                          listen: false)
                                      .getPeopleIdel(searchText: val);
                                }
                              } else if (_selectedIndex == 2) {
                                print(_selectedIndex);
                              } else if (peopleListTapIcon) {
                                Provider.of<PeopleHomeViewModel>(context,
                                        listen: false)
                                    .getPeopleDataList(searchText: val);
                              }
                            });
                          } catch (e) {
                            print(e);
                            print(val);
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 16.sp),
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  top: 12.0.sp, left: 15.sp, right: 20.sp),
                              child: Icon(
                                Icons.search,
                                color: Color(0xff64748B),
                              )),
                          hintText: projectListTapIcon
                              ? 'Search project'
                              : peopleListTapIcon
                                  ? 'Search people'
                                  : 'Search',
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Color(0xff64748B),
                              fontFamily: 'Inter-Recgular',
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w400),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Inter-Medium',
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                        width: 40.w,
                        height: 40.h,
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundImage: AssetImage('images/images.jpeg'),
                        )),
                    SizedBox(
                      width: 10.w,
                    ),
                    LogOut(returnValue: () {}),
                    SizedBox(
                      width: 15.w,
                    ),
                  ],
                ),
              ),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'images/hamburger.svg',
                    width: 18.w,
                    height: 12.h,
                  ),
                ),
                SvgPicture.asset(
                  'images/logo.svg',
                ),
                // SizedBox(
                //   width: 25,
                // ),
                FutureBuilder(
                    future: getList,
                    builder: (context, snapshot) {
                      return Visibility(
                        visible: snapshot.data as bool,
                        child: Column(
                          children: [
                            projectListTapIcon
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: 12.sp, left: 12.sp),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text("List",
                                                style: TextStyle(
                                                    color: Color(0xff93C5FD),
                                                    fontSize: 14.sp,
                                                    fontFamily: 'Inter-Medium',
                                                    fontStyle: FontStyle.normal,
                                                    letterSpacing: 0.1,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            SizedBox(
                                              height: 12.h,
                                            ),
                                            Container(
                                              width: 25.w,
                                              height: 3.h,
                                              decoration: BoxDecoration(
                                                  color: Color(0xff93C5FD),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  3.r),
                                                          topRight:
                                                              Radius.circular(
                                                                  3.r))),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 30.w,
                                        ),
                                        projectListTapIcon
                                            // _selectedIndex == 1
                                            ? Text("Timeline",
                                                style: TextStyle(
                                                    color: Color(0xffffffff),
                                                    fontSize: 14.sp,
                                                    letterSpacing: 0.1,
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Inter-Medium',
                                                    fontWeight:
                                                        FontWeight.w500))
                                            : Container(),
                                      ],
                                    ),
                                  )
                                : Container(),
                            projectListTapIcon == false &&
                                    cameraTapIcon == false &&
                                    circleTapIcon == false &&
                                    settingIcon == false &&
                                    bellTapIcon == false
                                ? Padding(
                                    padding: EdgeInsets.only(left: 22.sp),
                                    child: Text("Profile",
                                        style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 22.sp,
                                            fontFamily: 'Inter-Medium',
                                            letterSpacing: 0.1,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w700)),
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
          body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 56.w,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: const Color(0xff93C5FD),
                            border: Border.all(color: const Color(0xff93C5FD)),
                            borderRadius: BorderRadius.circular(
                              16.r,
                            ),
                          ),
                          margin: EdgeInsets.only(
                            top: 40.sp,
                            left: 10.sp,
                            right: 0.0,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                projectListTapIcon
                                    ? showAlertDialog(context)
                                    : Container();
                                peopleListTapIcon
                                    ? showAlertDialogPeople(context)
                                    : Container();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(20.sp),
                              child: SvgPicture.asset(
                                "images/plus.svg",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.sp),
                          child: Column(
                            children: [
                              projectListTapIcon
                                  ? Container(
                                      // height: 40,
                                      // width: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        border: Border.all(
                                            color: const Color(0xff334155)),
                                        borderRadius: BorderRadius.circular(
                                          18.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.sp,
                                            right: 16.sp,
                                            top: 8.sp,
                                            bottom: 8.sp),
                                        child: SvgPicture.asset(
                                          "images/notification_icon.svg",
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      child: Tooltip(
                                        // verticalOffset: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
                                          border: Border.all(
                                              color: const Color(0xff334155)),
                                          borderRadius: BorderRadius.circular(
                                            18.0,
                                          ),
                                        ),
                                        message: 'Projects',
                                        child: SvgPicture.asset(
                                          "images/notification_icon.svg",
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          bellTapIcon = false;
                                          settingIcon = false;
                                          projectListTapIcon = true;
                                          peopleListTapIcon = false;
                                          cameraTapIcon = false;
                                          circleTapIcon = false;
                                        });
                                      },
                                    ),
                              projectListTapIcon
                                  ? Text(
                                      'Projects',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Container(),
                              SizedBox(height: 40.h),
                              cameraTapIcon
                                  ? Container(
                                      // height: 40,
                                      // width: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        border: Border.all(
                                            color: const Color(0xff334155)),
                                        borderRadius: BorderRadius.circular(
                                          18.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.sp,
                                            right: 16.sp,
                                            top: 8.sp,
                                            bottom: 8.sp),
                                        child: SvgPicture.asset(
                                          "images/camera.svg",
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      child: SvgPicture.asset(
                                        "images/camera.svg",
                                      ),
                                      onTap: () {
                                        setState(() {
                                          bellTapIcon = false;
                                          settingIcon = false;
                                          projectListTapIcon = false;
                                          peopleListTapIcon = false;
                                          cameraTapIcon = true;
                                          circleTapIcon = false;
                                        });
                                      },
                                    ),
                              SizedBox(height: 40.h),
                              peopleListTapIcon
                                  ? Container(
                                      // height: 40,
                                      // width: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        border: Border.all(
                                            color: const Color(0xff334155)),
                                        borderRadius: BorderRadius.circular(
                                          18.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.sp,
                                            right: 16.sp,
                                            top: 8.sp,
                                            bottom: 8.sp),
                                        child: SvgPicture.asset(
                                          "images/people.svg",
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      child: Tooltip(
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
                                          border: Border.all(
                                              color: const Color(0xff334155)),
                                          borderRadius: BorderRadius.circular(
                                            18.0,
                                          ),
                                        ),
                                        message: 'People',
                                        child: SvgPicture.asset(
                                          "images/people.svg",
                                        ),
                                      ),
                                      onTap: () {
                                        bellTapIcon = false;
                                        settingIcon = false;
                                        projectListTapIcon = false;
                                        peopleListTapIcon = true;
                                        cameraTapIcon = false;
                                        circleTapIcon = false;
                                      },
                                    ),
                              peopleListTapIcon
                                  ? Text('People',
                                      style: TextStyle(color: Colors.white))
                                  : Container(),
                              SizedBox(height: 40.h),
                              circleTapIcon
                                  ? Container(
                                      // height: 40,
                                      // width: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        border: Border.all(
                                            color: const Color(0xff334155)),
                                        borderRadius: BorderRadius.circular(
                                          18.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.sp,
                                            right: 16.sp,
                                            top: 8.sp,
                                            bottom: 8.sp),
                                        child: SvgPicture.asset(
                                          "images/button.svg",
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        bellTapIcon = false;
                                        settingIcon = false;
                                        projectListTapIcon = false;
                                        peopleListTapIcon = false;
                                        cameraTapIcon = false;
                                        circleTapIcon = true;
                                      },
                                      child: SvgPicture.asset(
                                        "images/button.svg",
                                      ),
                                    ),
                              SizedBox(height: 40.h),
                              bellTapIcon
                                  ? Container(
                                      // height: 40,
                                      // width: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        border: Border.all(
                                            color: const Color(0xff334155)),
                                        borderRadius: BorderRadius.circular(
                                          18.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.sp,
                                            right: 16.sp,
                                            top: 8.sp,
                                            bottom: 8.sp),
                                        child: SvgPicture.asset(
                                          "images/bell.svg",
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        bellTapIcon = true;
                                        settingIcon = false;
                                        projectListTapIcon = false;
                                        peopleListTapIcon = false;
                                        cameraTapIcon = false;
                                        circleTapIcon = false;
                                        ;
                                      },
                                      child: SvgPicture.asset(
                                        "images/bell.svg",
                                      ),
                                    ),
                              SizedBox(height: 40.h),
                              settingIcon
                                  ? Container(
                                      // height: 40,
                                      // width: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff334155),
                                        border: Border.all(
                                            color: const Color(0xff334155)),
                                        borderRadius: BorderRadius.circular(
                                          18.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.sp,
                                            right: 16.sp,
                                            top: 8.sp,
                                            bottom: 8.sp),
                                        child: SvgPicture.asset(
                                          "images/setting.svg",
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        settingIcon = true;
                                        bellTapIcon = false;
                                        projectListTapIcon = false;
                                        peopleListTapIcon = false;
                                        cameraTapIcon = false;
                                        circleTapIcon = false;
                                      },
                                      child: SvgPicture.asset(
                                        "images/setting.svg",
                                      ),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Column(
                //   children: [
                //     SizedBox(
                //       width: 25.w,
                //     ),
                //   ],
                // ),
                Expanded(
                    child: _mainContents[projectListTapIcon
                        ? 1
                        : peopleListTapIcon
                            ? 3
                            : 2]),
              ])

          // Row(
          //   children: <Widget>[
          //     LayoutBuilder(builder: (context, constraint) {
          //       return Theme(
          //         data: ThemeData(
          //           // highlightColor: Colors.transparent,
          //           colorScheme: ColorScheme.light(primary: Color(0xff0F172A)),
          //         ),
          //         child: SingleChildScrollView(
          //           child: ConstrainedBox(
          //             constraints:
          //                 BoxConstraints(minHeight: constraint.maxHeight),
          //             child: IntrinsicHeight(
          //               child: NavigationRail(
          //                 selectedIndex: _selectedIndex,
          //                 onDestinationSelected: (int index) {
          //                   isIndex = index;
          //                   position = index;
          //                   print(index);
          //                   if (index == 0) {
          //                     if (add1.length == 1) {
          //                       showAlertDialog(context);
          //                     } else if (add1[add1.length - 1] == 1) {
          //                       showAlertDialog(context);
          //                     } else if (add1[add1.length - 1] == 3) {
          //                       print('sizeeee' + _addtag.length.toString());
          //                       showAddPeople(context);
          //                     }
          //                   } else {
          //                     //
          //                     setState(() {
          //                       _selectedIndex = index;
          //                       searchController.clear();
          //                       add1.add(index);
          //                     });
          //                   }
          //                 },
          //                 // groupAlignment: 0.1,
          //                 // elevation: 0.0,

          //                 labelType: NavigationRailLabelType.selected,
          //                 //type: BottomNavigationBarType.fixed,
          //                 backgroundColor: const Color(0xff0F172A),
          //                 destinations: <NavigationRailDestination>[
          //                   NavigationRailDestination(
          //                     padding: EdgeInsets.zero,
          //                     icon: Container(
          //                       width: 46.0,
          //                       height: 46.0,
          //                       decoration: BoxDecoration(
          //                         color: const Color(0xff93C5FD),
          //                         border:
          //                             Border.all(color: const Color(0xff93C5FD)),
          //                         borderRadius: BorderRadius.circular(
          //                           16.0,
          //                         ),
          //                       ),
          //                       margin: const EdgeInsets.only(
          //                         top: 40.0,
          //                         left: 20.0,
          //                         right: 0.0,
          //                       ),
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(16.0),
          //                         child: SvgPicture.asset(
          //                           "images/plus.svg",
          //                         ),
          //                       ),
          //                     ),
          //                     label: const Text(''),
          //                   ),

          //                   NavigationRailDestination(
          //                     padding: EdgeInsets.zero,
          //                     icon: Tooltip(
          //                       verticalOffset: 40,
          //                       decoration: BoxDecoration(
          //                         color: const Color(0xff334155),
          //                         border:
          //                             Border.all(color: const Color(0xff334155)),
          //                         borderRadius: BorderRadius.circular(
          //                           18.0,
          //                         ),
          //                       ),
          //                       message: 'Projects',
          //                       child: Container(
          //                         margin: const EdgeInsets.only(
          //                           top: 40.0,
          //                           left: 20.0,
          //                           right: 0.0,
          //                         ),
          //                         child: SvgPicture.asset(
          //                           "images/notification_icon.svg",
          //                         ),
          //                       ),
          //                     ),
          //                     selectedIcon: Container(
          //                       width: 56.0,
          //                       height: 32.0,
          //                       margin: const EdgeInsets.only(
          //                         top: 40.0,
          //                         left: 20.0,
          //                         right: 0.0,
          //                       ),
          //                       alignment: Alignment.center,
          //                       decoration: BoxDecoration(
          //                         color: const Color(0xff334155),
          //                         border:
          //                             Border.all(color: const Color(0xff334155)),
          //                         borderRadius: BorderRadius.circular(
          //                           18.0,
          //                         ),
          //                       ),
          //                       child: Stack(
          //                         children: [
          //                           SvgPicture.asset(
          //                             "images/notification_icon.svg",
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     label: const Align(
          //                         alignment: Alignment.center,
          //                         child: Padding(
          //                           padding: EdgeInsets.only(left: 25, top: 5),
          //                           child: Text(
          //                             'Projects',
          //                             textAlign: TextAlign.center,
          //                             style: TextStyle(fontSize: 12),
          //                           ),
          //                         )),
          //                   ),

          //                   NavigationRailDestination(
          //                       padding: EdgeInsets.zero,
          //                       icon: Column(
          //                         children: [
          //                           Container(
          //                             width: 20.0,
          //                             height: 18.0,
          //                             margin: const EdgeInsets.only(
          //                               top: 0.0,
          //                               left: 20.0,
          //                               right: 0.0,
          //                             ),
          //                             child: SvgPicture.asset(
          //                               "images/camera.svg",
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                       selectedIcon: Container(
          //                         width: 56.0,
          //                         height: 32.0,
          //                         margin: const EdgeInsets.only(
          //                           top: 0.0,
          //                           left: 20.0,
          //                           right: 0.0,
          //                         ),
          //                         alignment: Alignment.center,
          //                         decoration: BoxDecoration(
          //                           color: const Color(0xff334155),
          //                           border: Border.all(
          //                               color: const Color(0xff334155)),
          //                           borderRadius: BorderRadius.circular(
          //                             18.0,
          //                           ),
          //                         ),
          //                         child: Stack(
          //                           children: [
          //                             SvgPicture.asset(
          //                               "images/camera.svg",
          //                             ),
          //                             // Positioned(
          //                             //   right: 0,
          //                             //   top: 3,
          //                             //   child: Container(
          //                             //     padding: const EdgeInsets.all(1),
          //                             //     decoration: BoxDecoration(
          //                             //       color: Colors.red,
          //                             //       borderRadius: BorderRadius.circular(6),
          //                             //     ),
          //                             //     constraints: const BoxConstraints(
          //                             //       minWidth: 8,
          //                             //       minHeight: 8,
          //                             //     ),
          //                             //   ),
          //                             // )
          //                           ],
          //                         ),
          //                       ),
          //                       label: Text('')),
          //                   // NavigationRailDestination(
          //                   //   icon: Container(
          //                   //     width: 20.0,
          //                   //     height: 18.0,
          //                   //     margin: const EdgeInsets.only(
          //                   //       top: 0.0,
          //                   //       left: 20.0,
          //                   //       right: 0.0,
          //                   //     ),
          //                   //     child: SvgPicture.asset(
          //                   //       "images/camera.svg",
          //                   //     ),
          //                   //   ),
          //                   //   selectedIcon: Container(
          //                   //     width: 56.0,
          //                   //     height: 32.0,
          //                   //     margin: const EdgeInsets.only(
          //                   //       top: 0.0,
          //                   //       left: 20.0,
          //                   //       right: 0.0,
          //                   //     ),
          //                   //     alignment: Alignment.center,
          //                   //     decoration: BoxDecoration(
          //                   //       color: const Color(0xff334155),
          //                   //       border:
          //                   //           Border.all(color: const Color(0xff334155)),
          //                   //       borderRadius: BorderRadius.circular(
          //                   //         18.0,
          //                   //       ),
          //                   //     ),
          //                   //     child: Stack(
          //                   //       children: [
          //                   //         // Positioned(
          //                   //         //   child: Container(
          //                   //         //       height: 8,
          //                   //         //       width: 8,
          //                   //         //       decoration: BoxDecoration(
          //                   //         //           color: Color(0xffEF4444),
          //                   //         //           borderRadius:
          //                   //         //               BorderRadius.circular(100))),
          //                   //         // ),

          //                   //         Padding(
          //                   //           padding: const EdgeInsets.all(6.0),
          //                   //           child: SvgPicture.asset(
          //                   //             "images/camera.svg",
          //                   //           ),
          //                   //         ),
          //                   //         Positioned(
          //                   //           right: 0,
          //                   //           top: 6,
          //                   //           child: Container(
          //                   //             padding: const EdgeInsets.all(1),
          //                   //             decoration: BoxDecoration(
          //                   //               color: Colors.red,
          //                   //               borderRadius: BorderRadius.circular(6),
          //                   //             ),
          //                   //             constraints: const BoxConstraints(
          //                   //               minWidth: 8,
          //                   //               minHeight: 8,
          //                   //             ),
          //                   //           ),
          //                   //         )
          //                   //       ],
          //                   //     ),
          //                   //   ),
          //                   //   label: const Align(
          //                   //       alignment: Alignment.center,
          //                   //       child: Padding(
          //                   //         padding: EdgeInsets.only(left: 25, top: 5),
          //                   //         child: Text(
          //                   //           'People',
          //                   //           textAlign: TextAlign.center,
          //                   //           style: TextStyle(fontSize: 12),
          //                   //         ),
          //                   //       )),
          //                   // ),

          //                   NavigationRailDestination(
          //                     padding: EdgeInsets.zero,
          //                     icon: Column(
          //                       children: [
          //                         Tooltip(
          //                           verticalOffset: 17,
          //                           padding: const EdgeInsets.symmetric(
          //                               horizontal: 12.0, vertical: 5.0),
          //                           //  textAlign: TextAlign.center,
          //                           decoration: BoxDecoration(
          //                             color: const Color(0xff334155),
          //                             border: Border.all(
          //                                 color: const Color(0xff334155)),
          //                             borderRadius: BorderRadius.circular(
          //                               18.0,
          //                             ),
          //                           ),
          //                           excludeFromSemantics: true,
          //                           preferBelow: true,
          //                           message: 'People',
          //                           child: Container(
          //                             width: 20.0,
          //                             height: 18.0,
          //                             margin: const EdgeInsets.only(
          //                               top: 0.0,
          //                               left: 20.0,
          //                               right: 0.0,
          //                             ),
          //                             child: SvgPicture.asset(
          //                               "images/people.svg",
          //                             ),
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                     selectedIcon: Container(
          //                       width: 56.0,
          //                       height: 32.0,
          //                       margin: const EdgeInsets.only(
          //                         top: 0.0,
          //                         left: 20.0,
          //                         right: 0.0,
          //                       ),
          //                       alignment: Alignment.center,
          //                       decoration: BoxDecoration(
          //                         color: const Color(0xff334155),
          //                         border:
          //                             Border.all(color: const Color(0xff334155)),
          //                         borderRadius: BorderRadius.circular(
          //                           18.0,
          //                         ),
          //                       ),
          //                       child: SvgPicture.asset(
          //                         "images/people.svg",
          //                       ),
          //                     ),
          //                     label: const Align(
          //                         alignment: Alignment.center,
          //                         child: Padding(
          //                           padding: EdgeInsets.only(left: 25, top: 5),
          //                           child: Text(
          //                             'People',
          //                             textAlign: TextAlign.center,
          //                             style: TextStyle(fontSize: 12),
          //                           ),
          //                         )),
          //                   ),

          //                   NavigationRailDestination(
          //                     padding: EdgeInsets.zero,
          //                     icon: Container(
          //                       width: 20.0,
          //                       height: 18.0,
          //                       margin: const EdgeInsets.only(
          //                         top: 0.0,
          //                         left: 20.0,
          //                         right: 0.0,
          //                       ),
          //                       child: SvgPicture.asset(
          //                         "images/button.svg",
          //                       ),
          //                     ),
          //                     selectedIcon: Container(
          //                       width: 56.0,
          //                       height: 32.0,
          //                       alignment: Alignment.center,
          //                       margin: const EdgeInsets.only(
          //                         top: 0.0,
          //                         left: 20.0,
          //                         right: 0.0,
          //                       ),
          //                       decoration: BoxDecoration(
          //                         color: const Color(0xff334155),
          //                         border:
          //                             Border.all(color: const Color(0xff334155)),
          //                         borderRadius: BorderRadius.circular(
          //                           18.0,
          //                         ),
          //                       ),
          //                       child: SvgPicture.asset(
          //                         "images/button.svg",
          //                       ),
          //                     ),
          //                     label: const Text(''),
          //                   ),

          //                   NavigationRailDestination(
          //                     padding: EdgeInsets.zero,
          //                     icon: Container(
          //                       width: 20.0,
          //                       height: 18.0,
          //                       margin: const EdgeInsets.only(
          //                         top: 0.0,
          //                         left: 20.0,
          //                         right: 0.0,
          //                       ),
          //                       child: SvgPicture.asset(
          //                         "images/bell.svg",
          //                       ),
          //                     ),
          //                     selectedIcon: Container(
          //                       width: 56.0,
          //                       height: 32.0,
          //                       alignment: Alignment.center,
          //                       margin: const EdgeInsets.only(
          //                         top: 0.0,
          //                         left: 20.0,
          //                         right: 0.0,
          //                       ),
          //                       decoration: BoxDecoration(
          //                         color: const Color(0xff334155),
          //                         border:
          //                             Border.all(color: const Color(0xff334155)),
          //                         borderRadius: BorderRadius.circular(
          //                           18.0,
          //                         ),
          //                       ),
          //                       child: SvgPicture.asset(
          //                         "images/bell.svg",
          //                       ),
          //                     ),
          //                     label: const Text(''),
          //                   ),

          //                   NavigationRailDestination(
          //                     padding: EdgeInsets.zero,
          //                     icon: Container(
          //                       width: 20.0,
          //                       height: 18.0,
          //                       margin: const EdgeInsets.only(
          //                         top: 0.0,
          //                         left: 20.0,
          //                         right: 0.0,
          //                       ),
          //                       child: SvgPicture.asset(
          //                         "images/setting.svg",
          //                       ),
          //                     ),
          //                     selectedIcon: Container(
          //                       width: 56.0,
          //                       height: 32.0,
          //                       margin: const EdgeInsets.only(
          //                         top: 0.0,
          //                         left: 20.0,
          //                         right: 0.0,
          //                       ),
          //                       alignment: Alignment.center,
          //                       decoration: BoxDecoration(
          //                         color: const Color(0xff334155),
          //                         border:
          //                             Border.all(color: const Color(0xff334155)),
          //                         borderRadius: BorderRadius.circular(
          //                           16.0,
          //                         ),
          //                       ),
          //                       child: SvgPicture.asset(
          //                         "images/setting.svg",
          //                       ),
          //                     ),
          //                     label: const Text(''),
          //                   ),
          //                 ],
          //                 selectedIconTheme:
          //                     const IconThemeData(color: Colors.white),
          //                 unselectedIconTheme:
          //                     const IconThemeData(color: Colors.black),
          //                 selectedLabelTextStyle:
          //                     const TextStyle(color: Colors.white),
          //                 extended: false,
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     }),
          //     // sayyamm
          //     Expanded(child: _mainContents[_selectedIndex]),
          //   ],
          // ),
          ),
    );
  }

  Future<String?> getAccountable() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse(AppUrl.accountable_person),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _accountableId = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  Future<String?> getCustomer() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/customer"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _customerName = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  Future<String?> getCurrency() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/currencies"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _currencyName = mdata;
          try {
            currencyList!.clear();
            _currencyName.forEach((element) {
              if (!currencyList!.contains(element['currency']['symbol'])) {
                currencyList!.add(DropdownModel(
                    element['id'].toString(), element['currency']['symbol']));
              }
            });
          } catch (e) {
            print(e);
          }
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  Future<String?> getSelectStatus() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/status"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _statusList = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  Future<String?> getTimeline() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/time-zone/list"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _timeline = mdata;

          try {
            selecTimeZoneList = [];
            _timeline.forEach((element) {
              print(element);
              selecTimeZoneList!.add(DropdownModel(element['id'].toString(),
                  '${element['name'] + ', ' + element['diff_from_gtm']}'));
            });
          } catch (e) {
            print(e);
          }
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  Future<String?> getAddpeople() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/tags"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          addTag = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  Future<String?> getTagpeople() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/skills"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          addSkills = mdata;
          _addtag = addSkills;
          print('ghjhjhjh' + _addtag.length.toString());
        });
        print("yes to much");
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }

  onItemChanged(String value) {
    setState(() {
      _addtag = addSkills
          .where((x) => x['title'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  errorWidget() {
    return Text('Please Select this field',
        style:
            TextStyle(color: Color.fromARGB(255, 221, 49, 60), fontSize: 14));
  }

  errorWidget2(validateValue) {
    return Row(
      children: [
        const SizedBox(
          width: 45,
        ),
        saveButtonClick
            ? validateValue != null && validateValue.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text('$validateValue',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 221, 49, 60),
                            fontSize: 14)),
                  )
                : Text('')
            : Text('')
      ],
    );
  }

  handleAllerrorWidget(bool selectTesting) {
    return Row(
      children: [
        const SizedBox(width: 45),
        saveButtonClick
            ? selectTesting
                ? const Text(
                    " ",
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 0,
                    ),
                    child: errorWidget())
            : Text(''),
      ],
    );
  }

  clearContoller() {
    _name.clear();
    _nickName.clear();
    _emailAddress.clear();
    _phoneNumber.clear();

    _bio.clear();
    _designation.clear();

    _association.clear();
    _salary.clear();
    startTime1 = '';
    endTime2 = '';
    _department.clear();
    getDepartment();

    _country.clear();
    _enterCity.clear();

    webImage!.clear();

    abc.clear();
  }

//dropdown apis
  Future<String?> getDepartment() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/departments"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _department = mdata;
          print(_department);
          print(_department);
          try {
            departmentlist = []; //!.clear();
            _department.forEach((element) {
              print(element);
              departmentlist!.add(
                  DropdownModel(element['id'].toString(), element['name']));
            });
            // _department.forEach((element) {
            //   print(element);
            //   print(element);
            //   if (!departmentlist!.contains(element["id"])) {
            //     departmentlist!
            //         .add(DropdownModel(element["id"], element["id"]));
            //   }
            // });
          } catch (e) {
            print(e);
          }
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context);
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }
}
