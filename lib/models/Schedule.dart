class Schedule {
  ScheduleDetail morning;
  ScheduleDetail afternoon;
  ScheduleDetail night;

  Schedule({required this.morning, required this.afternoon, required this.night});
}

class ScheduleDetail {
  int id;
  String title;
  String timeOfDay;
  String plan;
  String regionName;

  ScheduleDetail({
    required this.id,
    required this.title,
    required this.timeOfDay,
    required this.plan,
    required this.regionName,
  });
}

Schedule parseScheduleData(Map<String, dynamic> jsonData) {
  dynamic morningScheduleDetailData = jsonData['morning']['scheduleDetail'];
  dynamic afternoonScheduleDetailData = jsonData['afternoon']['scheduleDetail'];
  dynamic nightScheduleDetailData = jsonData['night']['scheduleDetail'];

  print(morningScheduleDetailData);
  print(afternoonScheduleDetailData);
  print(nightScheduleDetailData);

  ScheduleDetail morningScheduleDetail = morningScheduleDetailData != null
      ? ScheduleDetail(
    id: morningScheduleDetailData['id'],
    title: morningScheduleDetailData['title'],
    timeOfDay: 'MORNING',
    plan: morningScheduleDetailData['plan'],
    regionName: morningScheduleDetailData['regionName'],
  )
      : ScheduleDetail(
    id: 0,
    title: '',
    timeOfDay: '',
    plan: '',
    regionName: '',
  );


  ScheduleDetail afternoonScheduleDetail = afternoonScheduleDetailData != null
      ? ScheduleDetail(
    id: afternoonScheduleDetailData['id'],
    title: afternoonScheduleDetailData['title'],
    timeOfDay: 'AFTERNOON',
    plan: afternoonScheduleDetailData['plan'],
    regionName: afternoonScheduleDetailData['regionName'],
  )
      : ScheduleDetail(
    id: 0,
    title: '',
    timeOfDay: '',
    plan: '',
    regionName: '',
  );

  ScheduleDetail nightScheduleDetail = nightScheduleDetailData != null
      ? ScheduleDetail(
    id: nightScheduleDetailData['id'],
    title: nightScheduleDetailData['title'],
    timeOfDay: 'NIGHT',
    plan: nightScheduleDetailData['plan'],
    regionName: nightScheduleDetailData['regionName'],
  )
      : ScheduleDetail(
    id: 0,
    title: '',
    timeOfDay: '',
    plan: '',
    regionName: '',
  );

  Schedule schedule = Schedule(
    morning: morningScheduleDetail,
    afternoon: afternoonScheduleDetail,
    night: nightScheduleDetail,
  );

  return schedule;
}
