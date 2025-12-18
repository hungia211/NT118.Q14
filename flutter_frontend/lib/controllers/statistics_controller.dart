class StatisticsController {
  List<int> getMonths() {
    return List.generate(12, (i) => i + 1);
  }

  String monthName(int month) {
    const names = [
      "Tháng 1","Tháng 2","Tháng 3","Tháng 4","Tháng 5","Tháng 6",
      "Tháng 7","Tháng 8","Tháng 9","Tháng 10","Tháng 11","Tháng 12"
    ];
    return names[month - 1];
  }
}
