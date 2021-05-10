class TimeSlot {
  Map<String, List> timeSlots;
  int numSlots;
  Map<String, int> slotsForType;

  TimeSlot() {
    timeSlots = {
      '09_00': [true, '09 : 00 AM'],
      '09_15': [true, '09 : 15 AM'],
      '09_30': [true, '09 : 30 AM'],
      '09_45': [true, '09 : 45 AM'],
      '10_00': [true, '10 : 00 AM'],
      '10_15': [true, '10 : 15 AM'],
      '10_30': [true, '10 : 30 AM'],
      '10_45': [true, '10 : 45 AM'],
      '11_00': [true, '11 : 00 AM'],
      '11_15': [true, '11 : 15 AM'],
      '11_30': [true, '11 : 30 AM'],
      '11_45': [true, '11 : 45 AM'],
      '12_00': [true, '12 : 00 AM'],
      '12_15': [true, '12 : 15 AM'],
      '12_30': [true, '12 : 30 AM'],
      '12_45': [true, '12 : 45 AM'],
      '13_00': [true, '01 : 00 PM'],
      '13_15': [true, '01 : 15 PM'],
      '13_30': [true, '01 : 30 PM'],
      '13_45': [true, '01 : 45 PM'],
      '14_00': [true, '02 : 00 PM'],
      '14_15': [true, '02 : 15 PM'],
      '14_30': [true, '02 : 30 PM'],
      '14_45': [true, '02 : 45 PM'],
      '15_00': [true, '03 : 00 PM'],
      '15_15': [true, '03 : 15 PM'],
      '15_30': [true, '03 : 30 PM'],
      '15_45': [true, '03 : 45 PM'],
      '16_00': [true, '04 : 00 PM'],
      '16_15': [true, '04 : 15 PM'],
      '16_30': [true, '04 : 30 PM'],
      '16_45': [true, '04 : 45 PM'],
      '17_00': [true, '05 : 00 PM'],
      '17_15': [true, '05 : 15 PM'],
      '17_30': [true, '05 : 30 PM'],
      '17_45': [true, '05 : 45 PM'],
    };
    numSlots = timeSlots.length;

    // Rounded the time required for appointment to 15 min. ceiling
    slotsForType = {
      'General Checkup': 1,
      'General Checkup with USG': 2,
      'Pregnancy USG': 1,
      'Follicular Study': 1,
      'Gynaecology USG': 2,
      'Growth Scan (Doppler)': 2,
      'Anomaly Scan - Special': 3,
      'NT Scan - Special': 2,
    };
  }

  Map<String, List> get getTimeSlots => timeSlots;
  int get getNumSlots => numSlots;

  void updateSlotStatus(String key, bool newStatus) {
    timeSlots[key][0] = newStatus;
  }

  bool slotStatus(String key) => timeSlots[key][0];

  String slotTime(String key) => timeSlots[key][1];

  /// The key supplied here should be the full string name of the
  /// appointment type, not code
  int appointLen(String key) => slotsForType[key];

// static const List<String> timeSlotsKeys = [
//   '09_00',
//   '09_15',
//   '09_30',
//   '09_45',
//   '10_00',
//   '10_15',
//   '10_30',
// ];

}
