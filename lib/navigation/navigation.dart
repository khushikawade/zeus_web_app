import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_range/time_range.dart';
import 'package:zeus/helper_widget/delete_dialog.dart';
import 'package:zeus/helper_widget/searchbar.dart';
import 'package:zeus/navigation/tag_model/tag_user.dart';
import 'package:zeus/navigation/tag_model/tagresponse.dart';
import 'package:zeus/navigator_tabs/idle/data/DataClass.dart';
import 'package:zeus/navigator_tabs/people_idle/data/getdata_provider.dart';
import 'package:zeus/people_profile/editpage/edit_page.dart';
import 'package:zeus/routers/routers_class.dart';
import 'package:zeus/util/validation.dart';
import 'package:zeus/utility/debouncer.dart';
import 'package:zeus/utility/dropdrowndata.dart';
import '../DemoContainer.dart';
import '../logout_module/logout_view.dart';
import '../navigator_tabs/idle/data/project_detail_data/ProjectDetailData.dart';
import '../navigator_tabs/idle/idle.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../utility/app_url.dart';
import '../utility/colors.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:http_parser/http_parser.dart';
import '../utility/constant.dart';
import '../utility/upertextformate.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter/cupertino.dart' show ChangeNotifier;

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
  AutoCompleteTextField? searchTextField;
  final fieldText = TextEditingController();
  final searchController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<Datum>> key = new GlobalKey();
  static List<Datum> users = <Datum>[];
  bool loading = true;
  List<int>? _selectedFile;
  Uint8List? _bytesData;
  GlobalKey<FormState> _addFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> abc = [];
  List<String> selectedDaysList = List.empty(growable: true);
  TimeRangeResult? _timeRange;
  Debouncer _debouncer = Debouncer();

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
  bool saveButtonClick = false;
  bool selectDepartment = false;
  bool selectSalary = false;
  bool selectDays = false;
  bool selectSkill = false;
  bool selectTime = false;
  bool selectTimeZone = false;
  bool selectImage = false;

  getformattedTime(TimeOfDay time) {
    DateTime tempDate = DateFormat("hh:mm")
        .parse(time.hour.toString() + ":" + time.minute.toString());
    var dateFormat = DateFormat("h:mm a"); // you can change the format here
    print(dateFormat.format(tempDate));
    return dateFormat.format(tempDate);
    // return '${time.hour}:${time.minute} ${time.period.toString().split('.')[1]}';
  }

  // getformattedTime(TimeOfDay time) {
  //     String to24hours() {
  //        final hour = this.hour.toString().padLeft(2, "0");
  //         final min = this.minute.toString().padLeft(2, "0");

  //          return "$hour:$min";   } }
  //          Text("24h: ${time.to24hours()}");  // 09:0

  var prefs;

  void change() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('val', 'q');
  }

  Future? getList;

  Future getListData() {
    return Provider.of<ProjectDetail>(context, listen: true).changeProfile();
  }

  @override
  void didChangeDependencies() {
    getList = getListData();
    super.didChangeDependencies();
  }

  Image? image;
  Uint8List? webImage;

  Future? _getTag;
  List addSkills = [];
  String name_ = '';
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
      // print('Users: ${users.length}');
      setState(() {
        loading = false;
      });
    } else {
      print("Error getting users.");
      // print(response.body);
    }
  }

  //Add people Api
  createPeople(BuildContext context, StateSetter setStateView) async {
    String commaSepratedString = selectedDaysList.join(", ");

    print("add People---------------------------------------------------");
    var token = 'Bearer ' + storage.read("token");

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://zeus-api.zehntech.net/api/v1/resource'));
    request.headers.addAll({
      "Content-Type": "application/json",
      "Authorization": token,
    });
    request.fields['name'] = _name.text.toString();
    request.fields['nickname'] = _nickName.text.toString();
    request.fields['email'] = _emailAddress.text.toString();
    request.fields['phone_number'] = _phoneNumber.text.toString();
    request.fields['password'] = 'Nirmaljeet@123';
    request.fields['bio'] = _bio.text.toString();
    request.fields['designation'] = _designation.text.toString();
    request.fields['department_id'] = _depat!;
    request.fields['associate'] = _association.text;
    request.fields['salary'] = _salary.text;
    request.fields['salary_currency'] = _curren!;
    // request.fields['availibilty_day'] = _availableDay.text.toString();
    // request.fields['availibilty_time'] = _availableTime.text.toString();
    request.fields['availibilty_day'] = commaSepratedString;
    // request.fields['availibilty_day'] = [selectedDaysList.toString()];
    request.fields['availibilty_time'] =
        //  "10AM-8PM";
        '${startTime1}-${endTime2}';
    request.fields['country'] = _country.text;
    request.fields['city'] = _enterCity.text;
    request.fields['time_zone'] = _time!;

    for (int i = 0; i < abc.length; i++) {
      request.fields['skills[$i]'] = '${abc[i]}';
    }
    // if (_selectedFile != null && _selectedFile!.isNotEmpty) {

    //   print(_selectedFile);
    // }
    _selectedFile = webImage;
    print(_selectedFile);

    request.files.add(await http.MultipartFile.fromBytes(
        'image', _selectedFile!,
        contentType: new MediaType('application', 'octet-stream'),
        filename: "file_up"));

    print("requestData ----------------------------------------- ${request}");

    var response = await request.send();
    print("------------------response.statusCode---------------------");
    print(response.statusCode);

    var responseString = await response.stream.bytesToString();
    print("Response Data ------------------------------- ${responseString}");
    if (response.statusCode == 200) {
      SmartDialog.dismiss();
      // ignore: use_build_context_synchronously
      Navigator.pop(
        context,
      );
      setState(() {
        _selectedIndex = 2;
        clearContoller();
        selectDays = false;
        selectSkill = false;
        selectTime = false;
        selectTimeZone = false;
        selectDepartment = false;
        selectSalary = false;
        selectImage = false;
        commaSepratedString = '';
        imageavail = false;

        _selectedFile = [];
        request.files.clear();
      });

      print("add people created");
    } else {
      Map<String, dynamic> responseJson = json.decode(responseString);
      print("Error response ------------------------ ${responseJson}");

      SmartDialog.dismiss();

      // Fluttertoast.showToast(
      //   msg: 'Something Went Wrong',
      //   backgroundColor: Colors.grey,
      // );

      //var user = userFromJson(response.body);
      Fluttertoast.showToast(
        msg: responseJson['message'] ?? 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
    }
  }

  //Update project Api
  updateProject() async {
    try {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.post(
        Uri.parse('https://zeus-api.zehntech.net/api/v1/resource'),
        body: jsonEncode({
          "name": _name.text.toString(),
          "nickname": _nickName.text.toString(),
          "email": _emailAddress.text.toString(),
          "phone_number": _phoneNumber.text.toString(),
          "password": 'Nirmaljeet@123',
          "bio": _bio.text.toString(),
          "designation": 'Sr. developer',
          "department_id": _depat,
          "associate": _association.text.toString(),
          "salary": '1900',
          "salary_currency": 'USD',
          "availibilty_day": 'asd',
          "availibilty_time": '10-7',
          "country": _country.text.toString(),
          "city": _enterCity.text.toString(),
          "time_zone": _time,
          //"image":webImage,
          "skills": _tag1,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      // ignore: unrelated_type_equality_checks
      if (response.statusCode == 200) {
        var responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;
        final stringRes = JsonEncoder.withIndent('').convert(responseJson);
        print(stringRes);
        print("yes add people");
        print(response.body);
      } else {
        print("failuree");
        print(response.body);
        Fluttertoast.showToast(
          msg: 'Something Went Wrong',
          backgroundColor: Colors.grey,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
      print('error caught: $e');
    }
  }

  //Create project Api
  createProject() async {
    var token = 'Bearer ' + storage.read("token");
    try {
      var response = await http.post(
        Uri.parse(AppUrl.create_project),
        body: jsonEncode({
          "title": _projecttitle.text.toString(),
          "accountable_person_id": _account,
          "customer_id": _custome,
          "crm_task_id": _crmtask.text.toString(),
          "work_folder_id": _warkfolderId.text.toString(),
          "budget": _budget.toString(),
          "currency": "&",
          "estimation_hours": '80', // _estimatehours.toString(),
          "status": _status,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      // ignore: unrelated_type_equality_checks
      if (response.statusCode == 200) {
        var responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;
        final stringRes = JsonEncoder.withIndent('').convert(responseJson);
        print(stringRes);
        print("yes Creaete");
        print(response.body);
      } else {
        print("failuree");
        Fluttertoast.showToast(
          msg: 'Something Went Wrong',
          backgroundColor: Colors.grey,
        );
      }
    } catch (e) {
      // print('error caught: $e');
    }
  }

  /* Future? getProject() {
    return Provider.of<TagDetail>(context, listen: false).getTagData();
  }*/

  MyDropdownData myDropdownData = MyDropdownData();
  int _selectedIndex = 1;
  DateTime selectedDate = DateTime.now();
  String dropdownvalue = 'Item 1';
  ImagePicker picker = ImagePicker();
  String? _depat;
  String? _account, _custome, _curren, _status, _time, _tag, _day, _shortday;

  // bool _submitted = false;
  bool _addSubmitted = true;
  String name = '';

  // var _formKey = GlobalKey<FormState>();

  List _department = [];
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
  List _statusList = [];
  List _timeline = [];
  List addTag = [];
  List<String> _tag1 = [];
  GlobalKey<ScaffoldState>? _key;
  bool? _isSelected;
  List<String>? _filters1 = [
    'User interface',
    'User interface',
    'User interface',
    'User interface',
    'User interface'
  ];
  List<String>? addTag1 = [];
  List<int> add1 = [1];
  bool imageavail = false;

  // XFile? webImage;
  var isIndex = 0;
  var isLoading = false;

  @override
  void initState() {
    //_getTag = getProject();
    getUsers();
    change();
    // webImage=_pickedImage as Uint8List?;
    _isSelected = false;
    //_getProjectDetail=getProject();
    //-----------sayyam
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

  //creatrptoject
  TextEditingController _projecttitle = TextEditingController();
  final TextEditingController _crmtask = TextEditingController();
  final TextEditingController _warkfolderId = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _estimatehours = TextEditingController();

  Future<void> _selectDate(setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff0F172A),
              accentColor: const Color(0xff0F172A),
              colorScheme: ColorScheme.light(primary: const Color(0xff0F172A)),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        initialDate: selectedDate,
        firstDate: new DateTime.now().subtract(new Duration(days: 0)),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final List<Widget> _mainContents = [
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Home',
        style: TextStyle(fontSize: 40),
      ),
    ),
    Idle(),
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
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
  ];

  //Create project popup
  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: const Color(0xff1E293B),
              content: Form(
                  key: _addFormKey,
                  child: EditPage(
                    formKey: _addFormKey,
                  )),
            ),
          );
        });
  }

  //Add people popup
  showAddPeople(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          abc.clear();
          //---------------sayyam
          imageavail = false;

          _day = '';

          selectedDaysList.clear();
          return StatefulBuilder(
            builder: (context, setStateView) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.zero,
              backgroundColor: const Color(0xff1E293B),
              content: Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.99,
                  height: MediaQuery.of(context).size.height * 0.99,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.11,
                            width: MediaQuery.of(context).size.width * 0.99,
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
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30.0, top: 10.0, bottom: 10.0),
                                  child: const Text(
                                    "Add people",
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 18.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 97.0,
                                  //MediaQuery.of(context).size.width * 0.22,
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
                                  child: GestureDetector(
                                    onTap: () {
                                      _name.clear();
                                      _nickName.clear();
                                      _bio.clear();
                                      _password.clear();
                                      _designation.clear();
                                      _association.clear();
                                      _salary.clear();
                                      _salaryCurrency.clear();
                                      _availableDay.clear();
                                      _availableTime.clear();
                                      _search.clear();
                                      _country.clear();
                                      _enterCity.clear();
                                      _phoneNumber.clear();
                                      _emailAddress.clear();
                                      _depat = null;
                                      _curren = null;
                                      _time = null;
                                      startTime1 = null;
                                      endTime2 = null;
                                      webImage = null;
                                      webImage = null;
                                      selectImage = false;
                                      selectTimeZone = false;
                                      selectSalary = false;
                                      selectSkill = false;
                                      selectDepartment = false;
                                      selectDays = false;
                                      selectTime = false;

                                      if (selectDepartment == false ||
                                          selectSalary == false ||
                                          selectSkill == false ||
                                          selectTimeZone == false ||
                                          selectImage == false ||
                                          selectDays == false ||
                                          selectTime == false) {
                                        saveButtonClick = false;
                                      }
                                      Navigator.of(context).pop();
                                    },
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
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (selectImage == true &&
                                          selectDepartment == true &&
                                          selectDays == true &&
                                          selectSkill == true &&
                                          selectTime == true &&
                                          selectTimeZone == true) {
                                        SmartDialog.showLoading(
                                          msg:
                                              "Your request is in progress please wait for a while...",
                                        );

                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          createPeople(context, setStateView);
                                        });
                                      }
                                    }
                                    setStateView(() {
                                      saveButtonClick = true;
                                    });
                                  },
                                  child: Container(
                                    width: 97,
                                    //MediaQuery.of(context).size.width * 0.22,
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
                                ),
                              ],
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 134.0,
                                          height: 134.0,
                                          margin: const EdgeInsets.only(
                                              left: 27.0, top: 28.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xff334155),
                                            borderRadius: BorderRadius.circular(
                                              110.0,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(110.0),
                                            child: imageavail
                                                ? Image.memory(
                                                    webImage!,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            46.0),
                                                    child: SvgPicture.asset(
                                                      'images/photo.svg',
                                                      height: 36.0,
                                                      width: 36.0,
                                                    )),
                                          )),
                                      InkWell(
                                        onTap: () async {
                                          final image = await ImagePickerWeb
                                              .getImageAsBytes();
                                          setStateView(() {
                                            webImage = image!;
                                            imageavail = true;
                                            selectImage = true;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 35.0,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.11,
                                              margin: const EdgeInsets.only(
                                                  left: 48.0, top: 20.0),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff334155),
                                                //border: Border.all(color: const Color(0xff0E7490)),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  40.0,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child: SvgPicture.asset(
                                                        'images/camera_pic.svg'),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 11.0),
                                                    child: const Text(
                                                      "Upload new",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontSize: 14.0,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                saveButtonClick
                                                    ? selectImage
                                                        ? const Text(
                                                            " ",
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 8,
                                                              left: 0,
                                                            ),
                                                            child:
                                                                errorWidget())
                                                    : Text(''),
                                              ],
                                            )
                                            // handleAllerrorWidget(selectImage)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 30.0, top: 20.0),
                                    child: const Text(
                                      "About you",
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 14.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.99,
                                            margin: const EdgeInsets.only(
                                                left: 30.0, right: 25.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                          ),
                                          errorWidget2(validateName)
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 6.0, left: 45.0),
                                        child: const Text(
                                          "Name",
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              color: Color(0xff64748B),
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _name,
                                        inputFormatters: [
                                          UpperCaseTextFormatter()
                                        ],
                                        //   autovalidateMode: AutovalidateMode.onUserInteraction,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        minLines: 1,
                                        // maxLines: 20,
                                        maxLength: 30,

                                        decoration: const InputDecoration(
                                            counterText: "",
                                            contentPadding: EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 35.0,
                                              right: 10,
                                              left: 45.0,
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: 14, height: 0.20),
                                            border: InputBorder.none,
                                            hintText: 'Enter name',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                        //  autovalidate: _autoValidate ,
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,

                                        validator: (value) {
                                          // validateName = nameValidation(value);
                                          RegExp regex =
                                              RegExp(r'^[a-z A-Z]+$');
                                          if (value!.isEmpty) {
                                            return 'Please enter';
                                          } else if (!regex.hasMatch(value)) {
                                            return 'Please enter valid name';
                                          }
                                          return null;
                                        },
                                        onChanged: (text) =>
                                            setStateView(() => name1 = text),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.99,
                                            margin: const EdgeInsets.only(
                                                left: 30.0,
                                                top: 16.0,
                                                right: 25.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                          ),
                                          // errorWidget2(validNickName)
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 22.0, left: 45.0),
                                          child: const Text(
                                            "Nickname",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                      TextFormField(
                                        controller: _nickName,
                                        //   autovalidateMode: AutovalidateMode.onUserInteraction,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        maxLength: 30,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            contentPadding: EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 52.0,
                                              right: 10,
                                              left: 45.0,
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: 14, height: 0.20),
                                            border: InputBorder.none,
                                            hintText: 'Enter nickname',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                        //  autovalidate: _autoValidate ,
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,

                                        validator: (value) {
                                          // validNickName = nameValidation(value);
                                          if (value!.isEmpty) {
                                            return 'Please enter';
                                          }
                                          return null;
                                        },
                                        onChanged: (text) =>
                                            setStateView(() => name1 = text),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.99,
                                        margin: const EdgeInsets.only(
                                            left: 30.0, top: 16.0, right: 25.0),
                                        height: 110.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xff334155),
                                          //border: Border.all(color:  const Color(0xff1E293B)),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8.0),
                                            topLeft: Radius.circular(8.0),
                                          ),
                                          boxShadow: [
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
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 22.0, left: 45.0),
                                          child: const Text(
                                            "Your bio",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                      TextFormField(
                                        maxLines: 5,
                                        maxLength: 152,
                                        controller: _bio,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            errorStyle: TextStyle(
                                                fontSize: 14, height: 0.20),
                                            contentPadding: EdgeInsets.only(
                                              // bottom: 10.0,
                                              top: 47.0,
                                              right: 40,
                                              left: 45.0,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Enter your bio',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        validator: (value) {
                                          //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                          if (value!.isEmpty) {
                                            return 'Please enter';
                                          }
                                          return null;
                                        },
                                        onChanged: (text) =>
                                            setStateView(() => name1 = text),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.12,
                                              margin: const EdgeInsets.only(
                                                  left: 30.0,
                                                  top: 16.0,
                                                  right: 16.0),
                                              height: 56.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff334155),
                                                //border: Border.all(color:  const Color(0xff1E293B)),
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 23.0, left: 45.0),
                                                child: const Text(
                                                  "Designation",
                                                  style: TextStyle(
                                                      fontSize: 11.0,
                                                      color: Color(0xff64748B),
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            TextFormField(
                                              controller: _designation,
                                              inputFormatters: [
                                                UpperCaseTextFormatter()
                                              ],
                                              maxLength: 18,
                                              cursorColor:
                                                  const Color(0xffFFFFFF),
                                              style: const TextStyle(
                                                  color: Color(0xffFFFFFF)),
                                              textAlignVertical:
                                                  TextAlignVertical.bottom,
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                  counterText: "",
                                                  errorStyle: TextStyle(
                                                      fontSize: 14,
                                                      height: 0.20),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    bottom: 16.0,
                                                    top: 53.0,
                                                    right: 10,
                                                    left: 45.0,
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: 'Enter',
                                                  hintStyle: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Color(0xffFFFFFF),
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              autovalidateMode: _addSubmitted
                                                  ? AutovalidateMode
                                                      .onUserInteraction
                                                  : AutovalidateMode.disabled,
                                              validator: (value) {
                                                //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                                if (value!.isEmpty) {
                                                  return 'Please enter';
                                                }
                                                return null;
                                              },
                                              onChanged: (text) => setStateView(
                                                  () => name1 = text),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.13,
                                                  margin: const EdgeInsets.only(
                                                      top: 16.0, right: 30),
                                                  height: 56.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff334155),
                                                    //border: Border.all(color:  const Color(0xff1E293B)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8.0,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 6.0,
                                                                  left: 16.0),
                                                          child: const Text(
                                                            "Department",
                                                            style: TextStyle(
                                                                fontSize: 13.0,
                                                                color: Color(
                                                                    0xff64748B),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          )),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            left: 16.0,
                                                            right: 16.0),
                                                        height: 20.0,
                                                        child: Container(

                                                            // padding: const EdgeInsets.all(2.0),
                                                            child:
                                                                StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSettersetState) {
                                                            return DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton(
                                                                dropdownColor:
                                                                    ColorSelect
                                                                        .class_color,
                                                                value: _depat,
                                                                underline:
                                                                    Container(),
                                                                hint:
                                                                    const Text(
                                                                  "Select",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xffFFFFFF),
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                isExpanded:
                                                                    true,
                                                                icon:
                                                                    const Icon(
                                                                  // Add this
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  // Add this
                                                                  color: Color(
                                                                      0xff64748B),

                                                                  // Add this
                                                                ),
                                                                items: _department
                                                                    .map(
                                                                        (items) {
                                                                  return DropdownMenuItem(
                                                                    value: items[
                                                                            'id']
                                                                        .toString(),
                                                                    child: Text(
                                                                      items[
                                                                          'name'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color: Color(
                                                                              0xffFFFFFF),
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  setStateView(
                                                                      () {
                                                                    print(
                                                                        "---------newValue--------------${newValue}");
                                                                    _depat =
                                                                        newValue!;
                                                                    selectDepartment =
                                                                        true;
                                                                  });
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                saveButtonClick
                                                    ? selectDepartment
                                                        ? const Text(
                                                            " ",
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 8,
                                                              left: 15,
                                                            ),
                                                            child:
                                                                errorWidget())
                                                    : Text(''),
                                              ],
                                            ),
                                            // Text("Red"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.99,
                                        margin: const EdgeInsets.only(
                                            left: 30.0, top: 16.0, right: 26.0),
                                        height: 56.0,
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
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 22.0, left: 45.0),
                                          child: const Text(
                                            "Associated with",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                      TextFormField(
                                        controller: _association,
                                        //   autovalidateMode: AutovalidateMode.onUserInteraction,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        maxLength: 30,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            contentPadding: EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 52.0,
                                              right: 10,
                                              left: 45.0,
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: 14, height: 0.20),
                                            border: InputBorder.none,
                                            hintText: 'Enter team name',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                        //  autovalidate: _autoValidate ,
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,

                                        validator: (value) {
                                          //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                          if (value!.isEmpty) {
                                            return 'Please enter';
                                          }
                                          return null;
                                        },
                                        onChanged: (text) =>
                                            setStateView(() => name1 = text),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 30.0, top: 16.0),
                                    child: const Text(
                                      "Salary",
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 18.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07,
                                            margin: const EdgeInsets.only(
                                                left: 30.0,
                                                top: 16.0,
                                                bottom: 16.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                8.0,
                                              ),
                                            ),
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 13.0, right: 18.0),
                                                // padding: const EdgeInsets.all(2.0),
                                                child: StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          StateSettersetState) {
                                                    return DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            ColorSelect
                                                                .class_color,
                                                        value: _curren,
                                                        underline: Container(),
                                                        hint: const Text(
                                                          "Select",
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              color: Color(
                                                                  0xffFFFFFF),
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        isExpanded: true,
                                                        icon: Icon(
                                                          // Add this
                                                          Icons.arrow_drop_down,
                                                          // Add this
                                                          color:
                                                              Color(0xff64748B),

                                                          // Add this
                                                        ),
                                                        items: _currencyName
                                                            .map((items) {
                                                          return DropdownMenuItem(
                                                            value: items['id']
                                                                .toString(),
                                                            child: Text(
                                                              items['currency']
                                                                  ['symbol'],
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Color(
                                                                      0xffFFFFFF),
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setStateView(() {
                                                            _curren = newValue;
                                                            selectSalary = true;
                                                          });
                                                        },
                                                      ),
                                                    );
                                                  },
                                                )),
                                          ),
                                          // saveButtonClick
                                          //     ? selectSalary
                                          //         ? const Text(
                                          //             " ",
                                          //           )
                                          //         : const Padding(
                                          //             padding: EdgeInsets.only(
                                          //               top: 0,
                                          //               left: 0,
                                          //             ),
                                          //             child: Text(
                                          //                 "Please Select ",
                                          //                 style: TextStyle(
                                          //                     color: Color
                                          //                         .fromARGB(
                                          //                             255,
                                          //                             221,
                                          //                             49,
                                          //                             60),
                                          //                     fontSize: 14)),
                                          //           )
                                          //     : Text(''),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.10,
                                              margin: const EdgeInsets.only(
                                                  top: 16.0, bottom: 16.0),
                                              height: 56.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff334155),
                                                //border: Border.all(color:  const Color(0xff1E293B)),
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 23.0, left: 15.0),
                                                child: const Text(
                                                  "Monthly Salary",
                                                  style: TextStyle(
                                                      fontSize: 11.0,
                                                      color: Color(0xff64748B),
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            TextFormField(
                                              maxLength: 15,
                                              controller: _salary,
                                              cursorColor:
                                                  const Color(0xffFFFFFF),
                                              style: const TextStyle(
                                                  color: Color(0xffFFFFFF)),
                                              textAlignVertical:
                                                  TextAlignVertical.bottom,
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                  counterText: "",
                                                  errorStyle: TextStyle(
                                                      fontSize: 14,
                                                      height: 0.20),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    bottom: 16.0,
                                                    top: 52.0,
                                                    right: 10,
                                                    left: 15.0,
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: '0.00',
                                                  hintStyle: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Color(0xffFFFFFF),
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              autovalidateMode: _addSubmitted
                                                  ? AutovalidateMode
                                                      .onUserInteraction
                                                  : AutovalidateMode.disabled,
                                              validator: (value) {
                                                //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                                RegExp regex = RegExp(
                                                    r'^\D+|(?<=\d),(?=\d)');

                                                if (value!.isEmpty) {
                                                  return 'Please enter';
                                                } else if (regex
                                                    .hasMatch(value)) {
                                                  return 'Please enter valid salary';
                                                }
                                                return null;
                                              },
                                              onChanged: (text) => setStateView(
                                                  () => name1 = text),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.99,
                                child: const VerticalDivider(
                                  color: Color(0xff94A3B8),
                                  thickness: 0.2,
                                )),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 30.0, top: 27.0),
                                    child: const Text(
                                      "Availabilty",
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 18.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                            margin: const EdgeInsets.only(
                                                left: 30.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  // Colors.red,
                                                  const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                          ),
                                          handleAllerrorWidget(selectDays)
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 6.0, left: 45.0),
                                          child: const Text(
                                            "Select days",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 30.0, right: 30.0, top: 30),
                                        height: 20.0,
                                        child: Container(

                                            // padding: const EdgeInsets.all(2.0),
                                            child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSettersetState) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 70),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  dropdownColor:
                                                      ColorSelect.class_color,
                                                  // value: _day,
                                                  underline: Container(),
                                                  hint: const Text(
                                                    "Select",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color:
                                                            Color(0xffFFFFFF),
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  isExpanded: true,
                                                  icon: const Icon(
                                                    // Add this
                                                    Icons.arrow_drop_down,
                                                    // Add this
                                                    color: Color(0xff64748B),

                                                    // Add this
                                                  ),
                                                  items: items1
                                                      .map((String items1) {
                                                    return DropdownMenuItem(
                                                      value: items1,
                                                      child: Text(items1,
                                                          style:
                                                              (const TextStyle(
                                                                  color: Colors
                                                                      .white))),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setStateView(() {
                                                      _day = newValue;
                                                      _shortday =
                                                          _day!.substring(0, 3);
                                                      if (selectedDaysList
                                                          .isNotEmpty) {
                                                        if (selectedDaysList
                                                            .contains(
                                                                _shortday)) {
                                                        } else {
                                                          selectedDaysList.add(
                                                              _shortday!
                                                                  .toString());
                                                          selectDays = true;
                                                        }
                                                      } else {
                                                        selectedDaysList.add(
                                                            _shortday!
                                                                .toString());
                                                        selectDays = true;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 30,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 26),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: selectedDaysList.length,
                                        //.tagResponse!.data!.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                left: 12.0),
                                            child: InputChip(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              deleteIcon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              backgroundColor:
                                                  Color(0xff334155),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              label: Text(
                                                selectedDaysList[index],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),

                                              selected: _isSelected!,

                                              //  selectedColor: Color(0xff334155),
                                              onSelected: (bool selected) {
                                                setStateView(() {
                                                  _isSelected = selected;
                                                  print(
                                                      "_isSelected--------------------------${_isSelected}");
                                                });
                                              },
                                              onDeleted: () {
                                                setStateView(() {
                                                  selectedDaysList
                                                      .removeAt(index);
                                                });
                                              },

                                              showCheckmark: false,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                            margin: const EdgeInsets.only(
                                                left: 30.0, top: 16.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                          ),
                                          handleAllerrorWidget(selectTime)
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 22.0, left: 45.0),
                                          child: const Text(
                                            "Select time",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                      Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 16.0,
                                            top: 50.0,
                                            right: 10,
                                            left: 45.0,
                                          ),
                                          child: Text(
                                            startTime1 != null &&
                                                    startTime1.isNotEmpty &&
                                                    endTime2 != null &&
                                                    endTime2.isNotEmpty
                                                ? "$startTime1 - $endTime2"
                                                : '',
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.white,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: TimeRange(
                                        fromTitle: const Text(
                                          'From',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                        toTitle: const Text(
                                          'To',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                        titlePadding: 16,
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                        activeTextStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        borderColor: Colors.white,
                                        backgroundColor: Colors.transparent,
                                        activeBackgroundColor: Colors.green,
                                        firstTime:
                                            TimeOfDay(hour: 8, minute: 30),
                                        lastTime:
                                            TimeOfDay(hour: 20, minute: 00),
                                        timeStep: 10,
                                        timeBlock: 30,
                                        onRangeCompleted: (range) {
                                          setStateView(() {
                                            startTime = range!.start;
                                            endTime = range.end;
                                            startTime1 =
                                                getformattedTime(startTime);
                                            endTime2 =
                                                getformattedTime(endTime);
                                            selectTime = true;
                                          });
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 25.0,
                                  ),
                                  // Text(
                                  //   'Selected Range: ${_timeRange!.start.format(context)} - ${_timeRange!.end.format(context)}',
                                  //   style: TextStyle(
                                  //       fontSize: 20, color: Colors.white),
                                  // ),
                                  const SizedBox(
                                    height: 25.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 30.0, top: 27.0),
                                        child: const Text(
                                          "Skills",
                                          style: TextStyle(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 18.0,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Container(
                                          width: 40.0,
                                          height: 40.0,
                                          margin: const EdgeInsets.only(
                                              right: 20.0, top: 25.0),
                                          decoration: const BoxDecoration(
                                            color: Color(0xff334155),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Container(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: SvgPicture.asset(
                                                    'images/tag_new.svg')),
                                          )
                                          //SvgPicture.asset('images/list.svg'),
                                          ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        margin: const EdgeInsets.only(
                                            left: 30.0, top: 16.0),
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
                                          //border: Border.all(color:  const Color(0xff1E293B)),
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            loading
                                                ? CircularProgressIndicator()
                                                : searchTextField =
                                                    AutoCompleteTextField<
                                                        Datum>(
                                                    // controller: input_controller,
                                                    //   suggestions: input_list,
                                                    clearOnSubmit: false,
                                                    key: key,
                                                    cursorColor: Colors.white,
                                                    decoration:
                                                        const InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 15.0),
                                                      prefixIcon: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 4.0),
                                                          child: Icon(
                                                            Icons.search,
                                                            color: Color(
                                                                0xff64748B),
                                                          )),
                                                      hintText: 'Search',
                                                      hintStyle: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              Color(0xff64748B),
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      border: InputBorder.none,
                                                    ),

                                                    suggestions: users,
                                                    keyboardType:
                                                        TextInputType.text,

                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0),

                                                    itemFilter: (item, query) {
                                                      return item.title!
                                                          .toLowerCase()
                                                          .startsWith(query
                                                              .toLowerCase());
                                                    },
                                                    itemSorter: (a, b) {
                                                      return a.title!
                                                          .compareTo(b.title!);
                                                    },
                                                    itemSubmitted: (item) {
                                                      setStateView(() {
                                                        //print(item.title);
                                                        searchTextField!
                                                            .textField!
                                                            .controller!
                                                            .text = '';

                                                        if (abc.isNotEmpty) {
                                                          if (abc.contains(
                                                              item.title!)) {
                                                          } else {
                                                            abc.add(item.title!
                                                                .toString());
                                                            selectSkill = true;
                                                          }
                                                        } else {
                                                          abc.add(item.title!
                                                              .toString());
                                                          selectSkill = true;
                                                        }
                                                      });
                                                    },
                                                    itemBuilder:
                                                        (context, item) {
                                                      // ui for the autocompelete row
                                                      return row(item);
                                                    },
                                                  )
                                          ],
                                        ),
                                      ),
                                      handleAllerrorWidget(selectSkill)
                                    ],
                                  ),

                                  /*  SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                        itemBuilder: (context,index){
                                          return Text(_addtag[index]['title']);},
                                        padding: const EdgeInsets.all(12.0),
                                        itemCount: _addtag.length
                                      ),
                                  ),
*/

                                  SizedBox(
                                    height: 30,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 26),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: abc.length,
                                        //.tagResponse!.data!.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                left: 12.0),
                                            child: InputChip(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              deleteIcon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              backgroundColor:
                                                  Color(0xff334155),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              label: Text(
                                                abc[index],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              selected: _isSelected!,
                                              //  selectedColor: Color(0xff334155),
                                              onSelected: (bool selected) {
                                                setStateView(() {
                                                  _isSelected = selected;
                                                });
                                              },
                                              onDeleted: () {
                                                setStateView(() {
                                                  abc.removeAt(index);
                                                });
                                              },

                                              showCheckmark: false,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.99,
                                child: const VerticalDivider(
                                  color: Color(0xff94A3B8),
                                  thickness: 0.2,
                                )),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 30.0, top: 27.0),
                                    child: const Text(
                                      "Contact info",
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 18.0,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                            margin: const EdgeInsets.only(
                                                left: 30.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                          ),
                                          errorWidget2(validateCountry)
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 6.0, left: 45.0),
                                          child: const Text(
                                            "Country",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                      TextFormField(
                                        maxLength: 20,
                                        controller: _country,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            errorStyle: TextStyle(
                                                fontSize: 14, height: 0.20),
                                            contentPadding: EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 35.0,
                                              right: 10,
                                              left: 45.0,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Enter country',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        validator: (value) {
                                          //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

                                          // validateCountry =
                                          //     countryValidation(value);

                                          RegExp regex =
                                              RegExp(r'^[a-z A-Z]+$');
                                          if (value!.isEmpty) {
                                            return 'Please enter';
                                          } else if (!regex.hasMatch(value)) {
                                            return 'Please enter valid  country name';
                                          }
                                          return null;
                                        },
                                        onChanged: (text) =>
                                            setStateView(() => name1 = text),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.26,
                                            margin: const EdgeInsets.only(
                                                left: 30.0, top: 16.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              //border: Border.all(color:  const Color(0xff1E293B)),
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                          ),
                                          errorWidget2(validateCity)
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 22.0, left: 45.0),
                                          child: const Text(
                                            "City",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                      TextFormField(
                                        maxLength: 20,
                                        controller: _enterCity,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            errorStyle: TextStyle(
                                                fontSize: 14, height: 0.20),
                                            contentPadding: EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 50.0,
                                              right: 10,
                                              left: 45.0,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Enter city',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        validator: (value) {
                                          //  RegExp regex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                          // validateCity = cityValidation(value);
                                          RegExp regex =
                                              RegExp(r'^[a-z A-Z]+$');
                                          if (value!.isEmpty) {
                                            return 'Please enter';
                                          } else if (!regex.hasMatch(value)) {
                                            return 'Please enter valid  city name';
                                          }
                                          return null;
                                        },
                                        onChanged: (text) =>
                                            setStateView(() => name1 = text),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        margin: const EdgeInsets.only(
                                            left: 30.0, top: 16.0),
                                        height: 56.0,
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
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 22.0, left: 45.0),
                                          child: const Text(
                                            "Phone number",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                      TextFormField(
                                        maxLength: 10,
                                        controller: _phoneNumber,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            errorStyle: TextStyle(
                                                fontSize: 14, height: 0.20),
                                            contentPadding: EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 50.0,
                                              right: 10,
                                              left: 45.0,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Enter number',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        validator: (value) {
                                          String pattern =
                                              r'(^(?:[+0]9)?[0-9]{10}$)';
                                          RegExp regExp = new RegExp(pattern);
                                          // RegExp regex = RegExp(
                                          //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                          if (value!.isEmpty) {
                                            return 'Please enter';
                                          } else if (!regExp.hasMatch(value)) {
                                            return 'Please enter valid mobile number';
                                          }

                                          return null;
                                        },
                                        onChanged: (text) =>
                                            setStateView(() => name1 = text),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        margin: const EdgeInsets.only(
                                            left: 30.0, top: 16.0),
                                        height: 56.0,
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
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 22.0, left: 45.0),
                                          child: const Text(
                                            "Email address",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Color(0xff64748B),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500),
                                          )),
                                      TextFormField(
                                        maxLength: 20,
                                        controller: _emailAddress,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            errorStyle: TextStyle(
                                                fontSize: 14, height: 0.20),
                                            contentPadding: EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 50.0,
                                              right: 10,
                                              left: 45.0,
                                            ),
                                            border: InputBorder.none,
                                            hintText: 'Enter email address',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        validator: (value) {
                                          RegExp regex = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                          if (value!.isEmpty) {
                                            return 'Please enter email';
                                          }
                                          if (!regex.hasMatch(value)) {
                                            return 'Enter valid Email';
                                          }
                                          if (regex.hasMatch(values)) {
                                            return 'please enter valid email';
                                          }
                                          if (value.length > 50) {
                                            return 'No more length 50';
                                          }
                                          return null;
                                        },
                                        onChanged: (text) =>
                                            setStateView(() => name1 = text),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        margin: const EdgeInsets.only(
                                            top: 20.0, left: 30.0),
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
                                          //border: Border.all(color:  const Color(0xff1E293B)),
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 16.0, right: 20.0),
                                            // padding: const EdgeInsets.all(2.0),
                                            child: StatefulBuilder(
                                              builder: (BuildContext context,
                                                  StateSettersetState) {
                                                return DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    dropdownColor:
                                                        ColorSelect.class_color,
                                                    value: _time,
                                                    underline: Container(),
                                                    hint: const Text(
                                                      "Select TimeZone",
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    isExpanded: true,
                                                    icon: Icon(
                                                      // Add this
                                                      Icons.arrow_drop_down,
                                                      // Add this
                                                      color: Color(0xff64748B),

                                                      // Add this
                                                    ),
                                                    items:
                                                        _timeline.map((items) {
                                                      return DropdownMenuItem(
                                                        value: items['id']
                                                            .toString(),
                                                        child: Text(
                                                          items['name'] +
                                                              ', ' +
                                                              items[
                                                                  'diff_from_gtm'],
                                                          style: const TextStyle(
                                                              fontSize: 14.0,
                                                              color: Color(
                                                                  0xffFFFFFF),
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setStateView(() {
                                                        _time = newValue;
                                                        print("account:$_time");
                                                        selectTimeZone = true;
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                            )),
                                      ),
                                      handleAllerrorWidget(selectTimeZone)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQueryData.copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 64.0,
          backgroundColor: const Color(0xff0F172A),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              FutureBuilder(
                  future: getList,
                  builder: (context, snapshot) {
                    return Visibility(
                      visible: snapshot.data as bool,
                      child: Container(
                          margin: const EdgeInsets.only(top: 35.0, left: 6.0),
                          child: Column(
                            children: [
                              /*  Text(prefs.getString('val')=='q'?'List':prefs.getString('val')=='r'?'Profile':'List', style: const TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 22.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700)),*/

                              // if (prefs.getString('val') == 'q') ...[
                              _selectedIndex == 1
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("List",
                                            style: TextStyle(
                                                color: Color(0xff93C5FD),
                                                fontSize: 14.0,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    )
                                  : Container(),
                              //] else
                              if (prefs.getString('val') == 'r') ...[
                                const Text("Profile",
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 22.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700))
                              ],

                              const SizedBox(height: 10),

                              // prefs.getString('val')=='q'?'List':prefs.getString('val')=='r'?'Profile':'List'
                              if (prefs.getString('val') == 'q') ...[
                                Container(
                                  width: 25,
                                  height: 3,
                                  decoration: const BoxDecoration(
                                      color: Color(0xff93C5FD),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(3),
                                          topRight: Radius.circular(3))),
                                )
                              ] else if (prefs.getString('val') == 'r') ...[
                                SizedBox(),
                              ]
                            ],
                          )),
                    );
                  }),
              const SizedBox(width: 30),
              // if (prefs.getString('val')! == 'q') ...[
              _selectedIndex == 1
                  ? const Padding(
                      padding: EdgeInsets.only(top: 26.0, left: 0.0),
                      child: Text("Timeline",
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 14.0,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500)),
                    )
                  : Container(),
              // ],
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
                padding: EdgeInsets.only(left: 5, right: 5),
                width: MediaQuery.of(context).size.width * 0.23,
                margin: const EdgeInsets.only(left: 30.0, top: 16.0),
                height: 48.0,
                decoration: BoxDecoration(
                  color: const Color(0xff1e293b),

                  // const Color(0xff334155),
                  //border: Border.all(color:  const Color(0xff1E293B)),
                  borderRadius: BorderRadius.circular(
                    42.0,
                  ),
                ),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    TextField(
                      controller: searchController,
                      //   suggestions: input_list,
                      //key: key,
                      onChanged: (val) {
                        try {
                          _debouncer.run(() {
                            if (_selectedIndex == 1) {
                              Provider.of<DataIdelClass>(context, listen: false)
                                  .getPeopleIdel(searchText: val);
                            } else if (_selectedIndex == 2) {
                              Provider.of<PeopleIdelClass>(context,
                                      listen: false)
                                  .getPeopleDataList(searchText: val);
                            } else if (_selectedIndex == 3) {
                              print(_selectedIndex);
                            }
                          });
                        } catch (e) {
                          print(e);
                          print(val);
                        }
                      },

                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 16.0),
                        prefixIcon: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Icon(
                              Icons.search,
                              color: Color(0xff64748B),
                            )),
                        hintText: _selectedIndex == 1
                            ? 'Search Project'
                            : _selectedIndex == 2
                                ? 'Search People'
                                : 'Search',
                        hintStyle: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff64748B),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                      ),

                      keyboardType: TextInputType.text,

                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    )
                  ],
                ),
              ),
              Container(
                  width: 40.0,
                  height: 40.0,
                  margin: const EdgeInsets.only(
                    top: 16.0,
                    right: 5.0,
                    left: 10.0,
                  ),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('images/images.jpeg'),
                    /*  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('images/images.jpeg'),
                   //   AssetImage(images/image.png),
                  )*/
                  )),
              LogOut(returnValue: () {}),
              // Container(
              //   width: 24.0,
              //   height: 24.0,
              //   decoration: BoxDecoration(
              //     color: const Color(0xff334155),
              //     border: Border.all(color: const Color(0xff334155)),
              //     borderRadius: BorderRadius.circular(
              //       10.0,
              //     ),
              //   ),
              //   margin: const EdgeInsets.only(
              //     top: 26.0,
              //     left: 8.0,
              //     right: 20.0,
              //   ),
              //   child:

              //    Padding(
              //     padding: const EdgeInsets.all(6.0),
              //     child: SvgPicture.asset(
              //       "images/drop_arrow.svg",
              //     ),
              //   ),
              // ),
              // Container(
              //   width: 24.0,
              //   height: 24.0,
              //   decoration: BoxDecoration(
              //     color: const Color(0xff334155),
              //     border: Border.all(color: const Color(0xff334155)),
              //     borderRadius: BorderRadius.circular(
              //       10.0,
              //     ),
              //   ),
              //   margin: const EdgeInsets.only(
              //     top: 26.0,
              //     left: 6.0,
              //     right: 40.0,
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(6.0),
              //     child: SvgPicture.asset(
              //       "images/drop_arrow.svg",
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
            ],
          ),
        ),
        body: Row(
          children: <Widget>[
            LayoutBuilder(builder: (context, constraint) {
              return Theme(
                data: ThemeData(
                  highlightColor: Colors.transparent,
                  colorScheme: ColorScheme.light(primary: Color(0xff0F172A)),
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: (int index) {
                          isIndex = index;
                          position = index;
                          print(index);
                          if (index == 0) {
                            if (add1.length == 1) {
                              showAlertDialog(context);
                            } else if (add1[add1.length - 1] == 1) {
                              showAlertDialog(context);
                            } else if (add1[add1.length - 1] == 2) {
                              print('sizeeee' + _addtag.length.toString());
                              showAddPeople(context);
                            }
                          } else {
                            //
                            setState(() {
                              _selectedIndex = index;
                              searchController.clear();
                              add1.add(index);
                              print(
                                  '<<<<<<<<<<<<<<_selectedIndex>>>>>>>>>>>>>>');
                              print(_selectedIndex);
                            });
                          }
                        },
                        // groupAlignment: 0.1,
                        // elevation: 0.0,

                        labelType: NavigationRailLabelType.selected,
                        //type: BottomNavigationBarType.fixed,
                        backgroundColor: const Color(0xff0F172A),
                        destinations: <NavigationRailDestination>[
                          // navigation destinations

                          NavigationRailDestination(
                            icon: Container(
                              width: 46.0,
                              height: 46.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff93C5FD),
                                border:
                                    Border.all(color: const Color(0xff93C5FD)),
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                top: 40.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(
                                  "images/plus.svg",
                                ),
                              ),
                            ),
                            // selectedIcon: Icon(Icons.favorite),
                            label: const Text(''),
                          ),

                          NavigationRailDestination(
                            icon: Container(
                              margin: const EdgeInsets.only(
                                top: 40.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: SvgPicture.asset(
                                  "images/notification_icon.svg",
                                ),
                              ),
                            ),
                            selectedIcon: Container(
                              width: 56.0,
                              height: 32.0,
                              margin: const EdgeInsets.only(
                                top: 40.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SvgPicture.asset(
                                      "images/notification_icon.svg",
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 3,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 8,
                                        minHeight: 8,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            label: const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25, top: 5),
                                  child: Text(
                                    'Projects',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                          ),

                          // NavigationRailDestination(
                          //     icon: Container(
                          //       width: 20.0,
                          //       height: 18.0,
                          //       margin: const EdgeInsets.only(
                          //         top: 0.0,
                          //         left: 20.0,
                          //         right: 0.0,
                          //       ),
                          //       child: SvgPicture.asset(
                          //         "images/camera.svg",
                          //       ),
                          //     ),
                          //     label: Text('')),

                          NavigationRailDestination(
                            icon: Column(
                              children: [
                                Container(
                                  width: 20.0,
                                  height: 18.0,
                                  margin: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 20.0,
                                    right: 0.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {},
                                    onHover: (ishover) {
                                      print(ishover);
                                      print("99999999999999999999999999999");
                                      setState(() {
                                        ishover = true;
                                      });
                                      //
                                    },
                                    child: SvgPicture.asset(
                                      "images/camera.svg",
                                    ),
                                  ),
                                ),
                                ishover
                                    ? Text("People",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white))
                                    : Text('')
                              ],
                            ),
                            selectedIcon: Container(
                              width: 56.0,
                              height: 32.0,
                              margin: const EdgeInsets.only(
                                top: 0.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Positioned(
                                  //   child: Container(
                                  //       height: 8,
                                  //       width: 8,
                                  //       decoration: BoxDecoration(
                                  //           color: Color(0xffEF4444),
                                  //           borderRadius:
                                  //               BorderRadius.circular(100))),
                                  // ),

                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SvgPicture.asset(
                                      "images/camera.svg",
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 8,
                                        minHeight: 8,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            label: const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25, top: 5),
                                  child: Text(
                                    'People',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                          ),

                          NavigationRailDestination(
                            icon: Container(
                              margin: const EdgeInsets.only(
                                top: 0.0,
                                left: 20.0,
                                bottom: 0.0,
                              ),
                              child: SvgPicture.asset(
                                "images/people.svg",
                              ),
                            ),
                            selectedIcon: Container(
                              width: 56.0,
                              height: 32.0,
                              margin: const EdgeInsets.only(
                                top: 0.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SvgPicture.asset(
                                      "images/people.svg",
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 8,
                                        minHeight: 8,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            label: const Text(''),
                          ),

                          NavigationRailDestination(
                            icon: Container(
                              width: 20.0,
                              height: 18.0,
                              margin: const EdgeInsets.only(
                                top: 0.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              child: SvgPicture.asset(
                                "images/button.svg",
                              ),
                            ),
                            selectedIcon: Container(
                              width: 56.0,
                              height: 32.0,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(
                                top: 0.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SvgPicture.asset(
                                      "images/button.svg",
                                    ),
                                  ),
                                  Positioned(
                                    right: 2,
                                    top: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 8,
                                        minHeight: 8,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            label: const Text(''),
                          ),

                          NavigationRailDestination(
                            icon: Container(
                              width: 20.0,
                              height: 18.0,
                              margin: const EdgeInsets.only(
                                top: 0.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              child: SvgPicture.asset(
                                "images/bell.svg",
                              ),
                            ),
                            selectedIcon: Container(
                              width: 56.0,
                              height: 32.0,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(
                                top: 0.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SvgPicture.asset(
                                      "images/bell.svg",
                                    ),
                                  ),
                                  Positioned(
                                    right: 3,
                                    top: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 8,
                                        minHeight: 8,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            label: const Text(''),
                          ),

                          NavigationRailDestination(
                            icon: Container(
                              width: 20.0,
                              height: 18.0,
                              margin: const EdgeInsets.only(
                                top: 0.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              child: SvgPicture.asset(
                                "images/setting.svg",
                              ),
                            ),
                            selectedIcon: Container(
                              width: 56.0,
                              height: 32.0,
                              margin: const EdgeInsets.only(
                                top: 0.0,
                                left: 20.0,
                                right: 0.0,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SvgPicture.asset(
                                      "images/setting.svg",
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 8,
                                        minHeight: 8,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            label: const Text(''),
                          ),
                        ],
                        selectedIconTheme:
                            const IconThemeData(color: Colors.white),
                        unselectedIconTheme:
                            const IconThemeData(color: Colors.black),
                        selectedLabelTextStyle:
                            const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            }),
            const VerticalDivider(thickness: 0, width: 0),
            Expanded(child: _mainContents[_selectedIndex]),
          ],
        ),
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
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getCustomer() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("https://zeus-api.zehntech.net/api/v1/customer"),
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
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getCurrency() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("https://zeus-api.zehntech.net/api/v1/currencies"),
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
        });
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getSelectStatus() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("https://zeus-api.zehntech.net/api/v1/status"),
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
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getTimeline() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("https://zeus-api.zehntech.net/api/v1/time-zone/list"),
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
        });
        //var res = response.body;
        //  print('helloDepartment' + res);
        //  DepartmentResponce peopleList = DepartmentResponce.fromJson(json.decode(res));
        // return peopleList;

        // final stringRes = JsonEncoder.withIndent('').convert(res);
        //  print(stringRes);
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getAddpeople() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("https://zeus-api.zehntech.net/api/v1/tags"),
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
        //var res = response.body;
        //  print('helloDepartment' + res);
        //  DepartmentResponce peopleList = DepartmentResponce.fromJson(json.decode(res));
        // return peopleList;

        // final stringRes = JsonEncoder.withIndent('').convert(res);
        //  print(stringRes);
      } else {
        print("failed to much");
      }
      return value;
    }
  }

  Future<String?> getTagpeople() async {
    String? value;
    if (value == null) {
      var token = 'Bearer ' + storage.read("token");
      var response = await http.get(
        Uri.parse("https://zeus-api.zehntech.net/api/v1/skills"),
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
      } else {
        print("failed to much");
      }
      return value;
    }
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
    // '${startTime1}-${endTime2}';
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
        Uri.parse("https://zeus-api.zehntech.net/api/v1/departments"),
        headers: {
          "Accept": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body.toString());
        List<dynamic> mdata = map["data"];
        setState(() {
          _department.clear();
          _department = mdata;
        });
      } else {
        print("failed to much");
      }
      return value;
    }
  }
}
