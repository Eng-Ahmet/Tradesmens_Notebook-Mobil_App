class SelectedDate {
  static Map<String, TimeType> timeMap = {
    "years": TimeType(
        dateValue: "2022",
        dateList: List.generate(2, (index) => "202${2 + index}")),
    "months": TimeType(
        dateValue: "12",
        dateList: List.generate(
            12, (index) => index < 9 ? "0" "${index + 1}" : "${index + 1}")),
    "days": TimeType(
        dateValue: "01",
        dateList: List.generate(
            30, (index) => index < 9 ? "0${index + 1}" : "${index + 1}")),
  };
}

class TimeType {
  TimeType({required this.dateList, required this.dateValue});
  List<String> dateList;
  String dateValue;
}
