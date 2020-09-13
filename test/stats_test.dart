import 'package:flutter_test/flutter_test.dart';
import '../lib/utils/stats.dart';

void main() {
  test('Average', () {
    final list = [4, 7, 23, 3];
    final avg = Stats.average(list);
    expect(avg, 9);
  });

  test('Median even length', () {
    final list = [4, 7, 23, 3];
    final med = Stats.median(list);
    expect(med, 6);
  });

  test('Median odd length', () {
    final list = [4, 7, 23, 3, 13];
    final med = Stats.median(list);
    expect(med, 7);
  });
}
