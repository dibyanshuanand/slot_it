import 'package:flutter/foundation.dart';
import 'package:slot_it/utils/appoint_type_coding.dart';

enum AppointmentType {
  gen_check,
  gen_check_usg,
  preg_usg,
  foll_study,
  gyna_usg,
  growth_scan_doppler,
  anom_scan_spl,
  nt_scan_spl
}

class Appointment extends ChangeNotifier {
  String _name;
  String _phone;
  String _dob;
  String _address;
  String _appointType;
  String _appointDate;

  // Appointment.empty();

  // Appointment(this._name, this._phone, this._dob, this._address);

  String get getName => _name;

  String get getPhone => _phone;

  String get getDOB => _dob;

  String get getAddress => _address;

  String get getAppointmentType => _appointType;

  Map<String, String> getBasicData() {
    var data = {
      'name': _name,
      'phone': _phone,
      'dob': _dob,
      'address': _address,
    };

    return data;
  }

  Map<String, String> getCompleteData() {
    var data = {
      'name': _name,
      'phone': _phone,
      'dob': _dob,
      'address': _address,
      'type': _appointType,
      'appoint_date': _appointDate
    };

    return data;
  }

  void setBasicDetails(String name, String phone, String dob, String address) {
    _name = name;
    _phone = phone;
    _dob = dob;
    _address = address;
  }

  void setAppointType(AppointmentType type) {
    _appointType = CodeAppointType.getStringType(type);
  }

  void setAppointDate(String date) {
    _appointDate = date;
  }
}
