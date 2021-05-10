import 'dart:developer';

import 'package:slot_it/models/appointment.dart';

class CodeAppointType {
  static String getStringType(AppointmentType type) {
    switch (type) {
      case AppointmentType.gen_check:
        return 'General Checkup';
        break;
      case AppointmentType.gen_check_usg:
        return 'General Checkup with USG';
        break;
      case AppointmentType.preg_usg:
        return 'Pregnancy USG';
        break;
      case AppointmentType.foll_study:
        return 'Follicular Study';
        break;
      case AppointmentType.gyna_usg:
        return 'Gynaecology USG';
        break;
      case AppointmentType.growth_scan_doppler:
        return 'Growth Scan (Doppler)';
        break;
      case AppointmentType.anom_scan_spl:
        log('Anomaly Scan - Special', name: 'CodeAppointType');
        break;
      case AppointmentType.nt_scan_spl:
        log('NT Scan - Special', name: 'CodeAppointType');
        break;
    }

    return '';
  }
}
