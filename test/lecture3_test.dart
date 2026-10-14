import 'package:lecture3/lecture3.dart';
import 'package:test/test.dart';

void main() {
  group('Student validation', () {
    test('default score and passing boundary', () {
      final student = Student('01', 'Li Hua');
      expect(student.score, 0);
      expect(student.passed, isFalse);
      student.score = 59.9;
      expect(student.passed, isFalse);
      student.score = 60;
      expect(student.passed, isTrue);
      student.score = 100;
      expect(student.score, 100);
    });

    test('invalid update throws and preserves previous score', () {
      final student = Student('01', 'Li Hua', 92);
      for (final score in [-1.0, 101.0, double.nan, double.infinity]) {
        expect(() => student.score = score, throwsArgumentError);
        expect(student.score, 92);
      }
    });

    test('constructor also rejects invalid scores', () {
      for (final score in [-1.0, 101.0, double.nan, double.negativeInfinity]) {
        expect(() => Student('01', 'Li Hua', score), throwsArgumentError);
      }
    });

    test('fromJson accepts integer and decimal numbers', () {
      expect(
        Student.fromJson({'id': '01', 'name': 'Li', 'score': 92}).score,
        92,
      );
      expect(
        Student.fromJson({'id': '02', 'name': 'Wang', 'score': 92.5}).score,
        92.5,
      );
    });

    test('fromJson shares score validation', () {
      expect(
        () => Student.fromJson({'id': '01', 'name': 'Li', 'score': 101}),
        throwsArgumentError,
      );
    });

    test('fromJson rejects missing or incorrectly typed fields', () {
      expect(
        () => Student.fromJson({'id': '01', 'name': 'Li'}),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => Student.fromJson({'id': '01', 'name': 'Li', 'score': '92'}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('GradeBook statistics', () {
    late GradeBook book;
    setUp(() {
      book = GradeBook([
        Student('01', 'Li Hua', 92),
        Student('02', 'Wang Fang', 55),
        Student('03', 'Zhang Ming', 80),
        Student('04', 'Chen Chen', 60),
        Student('05', 'Liu Yang', 73),
      ]);
    });

    test('normal data has independently calculated results', () {
      expect(book.average, 72);
      expect(book.maxBy?.id, '01');
      expect(book.countPassed, 4);
      expect(
        book.groupByGrade.map((key, value) => MapEntry(key, value.length)),
        {'优秀': 1, '良好': 1, '及格': 2, '不及格': 1},
      );
    });

    test('five-method chain sums top three passing scores', () {
      expect(book.topPassingTotal(3), 245);
      expect(book.topPassingTotal(20), 305);
      expect(book.topPassingTotal(0), 0);
      expect(() => book.topPassingTotal(-1), throwsArgumentError);
      expect(book.students.map((student) => student.id).toList(), [
        '01',
        '02',
        '03',
        '04',
        '05',
      ]);
    });

    test('empty book has no average or highest student', () {
      final empty = GradeBook([]);
      expect(empty.average, isNull);
      expect(empty.maxBy, isNull);
      expect(empty.countPassed, 0);
      expect(empty.topPassingTotal(3), 0);
      expect(empty.groupByGrade.values.every((group) => group.isEmpty), isTrue);
    });

    test('grade boundaries put each student in exactly one group', () {
      final boundaries = GradeBook([
        Student('01', 'A', 100),
        Student('02', 'B', 90),
        Student('03', 'C', 89.9),
        Student('04', 'D', 80),
        Student('05', 'E', 79.9),
        Student('06', 'F', 60),
        Student('07', 'G', 59.9),
        Student('08', 'H', 0),
      ]);
      expect(
        boundaries.groupByGrade.map(
          (key, value) => MapEntry(key, value.length),
        ),
        {'优秀': 2, '良好': 2, '及格': 2, '不及格': 2},
      );
    });

    test('ties keep first highest student', () {
      final tied = GradeBook([Student('01', 'A', 90), Student('02', 'B', 90)]);
      expect(tied.maxBy?.id, '01');
    });

    test('list membership is protected but student updates are reflected', () {
      final student = Student('01', 'A', 50);
      final input = [student];
      final single = GradeBook(input);
      input.clear();
      expect(single.students, hasLength(1));
      expect(() => single.students.clear(), throwsUnsupportedError);
      student.score = 80;
      expect(single.average, 80);
      expect(single.countPassed, 1);
    });

    test('mixin logs with runtime type', () {
      expect(() => book.log('ready'), prints('[GradeBook] ready\n'));
    });
  });
}
