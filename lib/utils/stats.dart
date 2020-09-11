class Stats {
  static int median(List<int> list) {
    list.sort();

    final middleIndex = list.length ~/ 2;

    if (list.length.isEven) {
      return ((list[middleIndex - 1] + list[middleIndex]) / 2).round();
    }
    return list[middleIndex];
  }

  static int average(List<int> list) {
    return (list.reduce((a, b) => a + b ) / list.length).round();
  }
}
