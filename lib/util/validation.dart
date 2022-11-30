nameValidation(value) {
  RegExp regex = RegExp(r'^[a-z A-Z]+$');
  if (value!.isEmpty) {
    return 'Please enter';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter valid name';
  }
  return " ";
}

countryValidation(value) {
  RegExp regex = RegExp(r'^[a-z A-Z]+$');
  if (value!.isEmpty) {
    return 'Please enter';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter valid  country name';
  }
  return " ";
}

cityValidation(value) {
  RegExp regex = RegExp(r'^[a-z A-Z]+$');
  if (value!.isEmpty) {
    return 'Please enter';
  } else if (!regex.hasMatch(value)) {
    return 'Please enter valid  country name';
  }
  return " ";
}
