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
import 'package:zeus/helper_widget/custom_dropdown.dart';
import 'package:zeus/people_module/people_home/people_home.dart';
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
  bool peopleListTapIcon = false;
  bool projectListTapIcon = true;
  bool cameraTapIcon = false;
  bool circleTapIcon = false;
  bool bellTapIcon = false;
  bool settingIcon = false;

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

      setState(() {
        loading = false;
      });
    } else if (response.statusCode == 401) {
      AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
    } else {
      print("Error getting users.");
    }
  }

  //Add people Api
  createPeople(BuildContext context, StateSetter setStateView) async {
    String commaSepratedString = selectedDaysList.join(", ");

    print("add People---------------------------------------------------");
    var token = 'Bearer ' + storage.read("token");

    var request =
        http.MultipartRequest('POST', Uri.parse('${AppUrl.baseUrl}/resource'));
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
    request.fields['availibilty_day'] = commaSepratedString;
    request.fields['availibilty_time'] = '${startTime1}-${endTime2}';
    request.fields['country'] = _country.text;
    request.fields['city'] = _enterCity.text;
    request.fields['time_zone'] = _time!;

    for (int i = 0; i < abc.length; i++) {
      request.fields['skills[$i]'] = '${abc[i]}';
    }

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
    } else if (response.statusCode == 401) {
      SmartDialog.dismiss();
      AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
    } else {
      Map<String, dynamic> responseJson = json.decode(responseString);
      print("Error response ------------------------ ${responseJson}");

      SmartDialog.dismiss();

      Fluttertoast.showToast(
        msg: responseJson['message'] ?? 'Something Went Wrong',
        backgroundColor: Colors.grey,
      );
    }
  }

  //Create project_detail Api
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
          "estimation_hours": '80',
          "status": _status,
        }),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        var responseJson =
            jsonDecode(response.body.toString()) as Map<String, dynamic>;
        final stringRes = JsonEncoder.withIndent('').convert(responseJson);
        print(stringRes);
        print("yes Creaete");
        print(response.body);
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
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

  bool _addSubmitted = true;
  String name = '';

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

  var isIndex = 0;
  var isLoading = false;

  @override
  void initState() {
    Provider.of<ProjectHomeViewModel>(context, listen: false)
        .getPeopleIdel(searchText: '');
    getUsers();
    change();
    _isSelected = false;
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

  final ScrollController verticalScroll = ScrollController();

  Future<void> _selectDate(setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: const Color(0xff0F172A),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              colorScheme: ColorScheme.light(primary: const Color(0xff0F172A))
                  .copyWith(secondary: const Color(0xff0F172A)),
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
    ProjectHome(),
    Container(
      color: const Color(0xff0F172A),
      alignment: Alignment.center,
      child: const Text(
        'Coming Soon',
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    ),
    PeopleHomeView(),
    // Container(
    //   child: const Navigator(
    //     onGenerateRoute: generateRoute,
    //     initialRoute: '/peopleList',
    //   ),
    // ),
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
                  child: RawScrollbar(
                    controller: verticalScroll,
                    thumbColor: const Color(0xff4b5563),
                    crossAxisMargin: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    thickness: 8,
                    child: ListView(
                      controller: verticalScroll,
                      shrinkWrap: true,
                      children: [
                        Container(
                            height: 87,
                            decoration: const BoxDecoration(
                              color: Color(0xff283345),
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
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30.0, top: 10.0, bottom: 10.0),
                                  child: const Text(
                                    "Add People",
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontSize: 22.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 97.0,
                                  margin: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0),
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff334155),
                                    borderRadius: BorderRadius.circular(
                                      40.0,
                                    ),
                                  ),
                                  child: InkWell(
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
                                    margin: const EdgeInsets.only(
                                        top: 10.0, right: 30.0, bottom: 10.0),
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7DD3FC),
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
                                                  left: 48.0, top: 57.0),
                                              decoration: BoxDecoration(
                                                color: const Color(0xff334155),
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
                                                    child: const Icon(
                                                        Icons.camera_alt,
                                                        size: 18,
                                                        color:
                                                            Color(0xffFFFFFF)),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 30.0, top: 30.0),
                                    child: const Text(
                                      "About you",
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 18.0,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Inter-Bold',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 30.0, right: 25.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          errorWidget2(validateName)
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 11.0,
                                          left: 45.0,
                                        ),
                                        child: const Text(
                                          "Name",
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              letterSpacing: 0.5,
                                              color: Color(0xff64748B),
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _name,
                                        cursorColor: const Color(0xffFFFFFF),
                                        style: const TextStyle(
                                            color: Color(0xffFFFFFF)),
                                        textAlignVertical:
                                            TextAlignVertical.bottom,
                                        keyboardType: TextInputType.text,
                                        minLines: 1,
                                        maxLength: 30,
                                        decoration: const InputDecoration(
                                            counterText: "",
                                            contentPadding: EdgeInsets.only(
                                              bottom: 16.0,
                                              top: 36.0,
                                              right: 10,
                                              left: 45.0,
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize: 14, height: 0.20),
                                            border: InputBorder.none,
                                            hintText: 'Enter name',
                                            hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                letterSpacing: 0.25,
                                                color: Color(0xffFFFFFF),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400)),
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        validator: (value) {
                                          RegExp regex = RegExp(r'^[a-z A-Z]+$',
                                              caseSensitive: false);
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
                                                top: 5.0,
                                                right: 25.0,
                                                bottom: 10),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 14.0, left: 45.0),
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
                                              top: 45.0,
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
                                                fontWeight: FontWeight.w400)),
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        validator: (value) {
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
                                            ),
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
                                              bottom: 10.0,
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
                                                fontWeight: FontWeight.w400)),
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        validator: (value) {
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
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
                                                  color:
                                                      const Color(0xff334155),
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
                                                    ),
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
                                                        color:
                                                            Color(0xff64748B),
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )),
                                              TextFormField(
                                                controller: _designation,
                                                // inputFormatters: [
                                                //   UpperCaseTextFormatter()
                                                // ],
                                                maxLength: 20,
                                                cursorColor:
                                                    const Color(0xffFFFFFF),
                                                style: const TextStyle(
                                                    color: Color(0xffFFFFFF)),
                                                textAlignVertical:
                                                    TextAlignVertical.bottom,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
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
                                                        border:
                                                            InputBorder.none,
                                                        hintText: 'Enter',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Color(
                                                                0xffFFFFFF),
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                autovalidateMode: _addSubmitted
                                                    ? AutovalidateMode
                                                        .onUserInteraction
                                                    : AutovalidateMode.disabled,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (text) =>
                                                    setStateView(
                                                        () => name1 = text),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 16.0,
                                                            right: 30),
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff334155),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8.0,
                                                      ),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color:
                                                              Color(0xff475569),
                                                          offset: Offset(
                                                            0.0,
                                                            2.0,
                                                          ),
                                                          blurRadius: 0.0,
                                                          spreadRadius: 0.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 4.0,
                                                                      left:
                                                                          16.0),
                                                              child: const Text(
                                                                "Department",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    color: Color(
                                                                        0xff64748B),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                          StatefulBuilder(builder:
                                                              (BuildContext
                                                                      context,
                                                                  StateSettersetState) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      right: 4,
                                                                      top: 2),
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                      child:
                                                                          CustomDropdownButton(
                                                                isDense: true,
                                                                dropdownColor:
                                                                    Color(
                                                                        0xff0F172A),
                                                                value: _depat,
                                                                underline:
                                                                    Container(),
                                                                hint:
                                                                    const Text(
                                                                  "Select",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      color: Color(
                                                                          0xffFFFFFF),
                                                                      fontFamily:
                                                                          'Inter',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  color: Color(
                                                                      0xff64748B),
                                                                ),
                                                                elevation: 12,
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
                                                                              15.0,
                                                                          color: Color(
                                                                              0xffFFFFFF),
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w500),
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
                                                              )),
                                                            );
                                                          }),
                                                        ]),
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
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.99,
                                        margin: const EdgeInsets.only(
                                            left: 30.0, top: 10.0, right: 26.0),
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
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
                                            ),
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
                                        autovalidateMode: _addSubmitted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        validator: (value) {
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
                                                0.10,
                                            margin: const EdgeInsets.only(
                                                left: 30.0,
                                                top: 16.0,
                                                bottom: 16.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                8.0,
                                              ),
                                            ),
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 13.0, right: 18.0),
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
                                                          Icons.arrow_drop_down,
                                                          color:
                                                              Color(0xff64748B),
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
                                                  0.12,
                                              margin: const EdgeInsets.only(
                                                  top: 16.0, bottom: 16.0),
                                              height: 56.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff334155),
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
                                                  ),
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
                                    MediaQuery.of(context).size.height * 1.2,
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
                                              color: const Color(0xff334155),
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
                                                )
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
                                            left: 30.0,
                                            right: 30.0,
                                            top: 26,
                                            bottom: 10),
                                        height: 20.0,
                                        child: Container(child: StatefulBuilder(
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
                                                    Icons.arrow_drop_down,
                                                    color: Color(0xff64748B),
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
                                  selectedDaysList.isNotEmpty
                                      ? SizedBox(
                                          height: 30,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 26),
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  selectedDaysList.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 12.0),
                                                  child: InputChip(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
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
                                                    onSelected:
                                                        (bool selected) {
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
                                        )
                                      : Container(),
                                  selectedDaysList.isNotEmpty
                                      ? const SizedBox(
                                          height: 15,
                                        )
                                      : Container(),
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
                                                left: 30.0, top: 0.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
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
                                                ),
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
                                    height: 20.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 30.0, bottom: 12),
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
                                            right: 60,
                                          ),
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
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        margin: const EdgeInsets.only(
                                            left: 30.0, top: 16.0),
                                        height: 55.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
                                          borderRadius: BorderRadius.circular(
                                            48.0,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            loading
                                                ? CircularProgressIndicator()
                                                : searchTextField =
                                                    AutoCompleteTextField<
                                                        Datum>(
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
                                                                  top: 4.0,
                                                                  right: 21,
                                                                  left: 27),
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
                                                      return row(item);
                                                    },
                                                  )
                                          ],
                                        ),
                                      ),
                                      handleAllerrorWidget(selectSkill),
                                      Padding(
                                        padding: EdgeInsets.only(left: 30),
                                        child: Wrap(
                                          spacing: 5,
                                          runSpacing: 5,
                                          children: List.generate(
                                            abc.length,
                                            (index) {
                                              return Container(
                                                height: 32,
                                                margin: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                child: InputChip(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                  deleteIcon: const Icon(
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
                                                  onSelected: (bool selected) {
                                                    setState(() {
                                                      _isSelected = selected;
                                                    });
                                                  },
                                                  onDeleted: () {
                                                    setState(() {
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
                                ],
                              ),
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 1.2,
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
                                                ),
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
                                                left: 30.0, top: 7.0),
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff334155),
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          errorWidget2(validateCity)
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 12.0, left: 45.0),
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
                                              top: 40.0,
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
                                            left: 30.0, top: 7.0),
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
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
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 12.0, left: 45.0),
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
                                              top: 40.0,
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
                                            left: 30.0, top: 20.0),
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
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
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 25.0, left: 45.0),
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
                                            top: 26.0, left: 30.0),
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff334155),
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 16.0, right: 20.0),
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
                                                      "Select timezone",
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
                                                      Icons.arrow_drop_down,
                                                      color: Color(0xff64748B),
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
          // resizeToAvoidBottomInset: true,
          backgroundColor: Color(0xff0F172A),
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            toolbarHeight: 70.0,
            backgroundColor: const Color(0xff0F172A),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      width: 475,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff1e293b),
                        borderRadius: BorderRadius.circular(
                          42.0,
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
                          contentPadding: EdgeInsets.only(top: 16.0),
                          prefixIcon: const Padding(
                              padding: EdgeInsets.only(
                                  top: 4.0, left: 15, right: 20),
                              child: Icon(
                                Icons.search,
                                color: Color(0xff64748B),
                              )),
                          hintText: projectListTapIcon
                              ? 'Search Project'
                              : peopleListTapIcon
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
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                        width: 40.0,
                        height: 40.0,
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('images/images.jpeg'),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    LogOut(returnValue: () {}),
                    SizedBox(
                      width: 30,
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
                    width: 18.0,
                    height: 12.0,
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
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 12),
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
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Container(
                                              width: 25,
                                              height: 3,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xff93C5FD),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  3),
                                                          topRight:
                                                              Radius.circular(
                                                                  3))),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        projectListTapIcon
                                            // _selectedIndex == 1
                                            ? Text("Timeline",
                                                style: TextStyle(
                                                    color: Color(0xffffffff),
                                                    fontSize: 14.0,
                                                    fontFamily: 'Inter',
                                                    fontWeight:
                                                        FontWeight.w500))
                                            : Container(),
                                      ],
                                    ),
                                  )
                                : Container(),
                            projectListTapIcon == false
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 22.0),
                                    child: const Text("Profile",
                                        style: TextStyle(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 22.0,
                                            fontFamily: 'Inter',
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
          body: Row(children: [
            Column(
              children: [
                Container(
                  width: 46.0,
                  height: 46.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff93C5FD),
                    border: Border.all(color: const Color(0xff93C5FD)),
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                  ),
                  margin: const EdgeInsets.only(
                    top: 40.0,
                    left: 10.0,
                    right: 0.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        projectListTapIcon
                            ? showAlertDialog(context)
                            : Container();
                        peopleListTapIcon
                            ? showAddPeople(context)
                            : Container();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        "images/plus.svg",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    children: [
                      projectListTapIcon
                          ? Container(
                              // height: 40,
                              // width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8, bottom: 8),
                                child: SvgPicture.asset(
                                  "images/notification_icon.svg",
                                ),
                              ),
                            )
                          : InkWell(
                              child: SvgPicture.asset(
                                "images/notification_icon.svg",
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
                      SizedBox(height: 40),
                      peopleListTapIcon
                          ? Container(
                              // height: 40,
                              // width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8, bottom: 8),
                                child: SvgPicture.asset(
                                  "images/people.svg",
                                ),
                              ),
                            )
                          : InkWell(
                              child: SvgPicture.asset(
                                "images/people.svg",
                              ),
                              onTap: () {
                                setState(() {
                                  bellTapIcon = false;
                                  settingIcon = false;
                                  projectListTapIcon = false;
                                  peopleListTapIcon = true;
                                  cameraTapIcon = false;
                                  circleTapIcon = false;
                                });
                              },
                            ),
                      peopleListTapIcon
                          ? Text('People',
                              style: TextStyle(color: Colors.white))
                          : Container(),
                      SizedBox(height: 40),
                      cameraTapIcon
                          ? Container(
                              // height: 40,
                              // width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8, bottom: 8),
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
                                bellTapIcon = false;
                                settingIcon = false;
                                projectListTapIcon = false;
                                peopleListTapIcon = false;
                                cameraTapIcon = true;
                                circleTapIcon = false;
                              },
                            ),
                      SizedBox(height: 40),
                      circleTapIcon
                          ? Container(
                              // height: 40,
                              // width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8, bottom: 8),
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
                      SizedBox(height: 40),
                      bellTapIcon
                          ? Container(
                              // height: 40,
                              // width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8, bottom: 8),
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
                      SizedBox(height: 40),
                      settingIcon
                          ? Container(
                              // height: 40,
                              // width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff334155),
                                border:
                                    Border.all(color: const Color(0xff334155)),
                                borderRadius: BorderRadius.circular(
                                  18.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 8, bottom: 8),
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
            Column(
              children: [
                SizedBox(
                  width: 25,
                ),
              ],
            ),
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
        AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
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
        AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
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
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
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
        AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
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
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
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
        AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
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
        AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
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
          _department.clear();
          _department = mdata;
        });
      } else if (response.statusCode == 401) {
        AppUtil.showErrorDialog(context,'Your Session has been expired, Please try again!');
      } else {
        print("failed to much");
      }
      return value;
    }
    return null;
  }
}
