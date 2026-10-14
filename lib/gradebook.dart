import 'logger.dart';
import 'student.dart';

class GradeBook with Logger {
  final List<Student> _students;

  // 固定集合成员；Student 的成绩仍可通过校验 setter 修改。
  GradeBook(List<Student> students)
    : _students = List<Student>.unmodifiable(students);

  List<Student> get students => _students;

  double? get average {
    if (_students.isEmpty) return null;
    return _students
            .map((s) => s.score)
            .fold<double>(0, (sum, score) => sum + score) /
        _students.length;
  }

  // 按指南命名；本作业固定比较成绩，并非任意字段的通用 maxBy。
  Student? get maxBy {
    if (_students.isEmpty) return null;
    return _students.reduce(
      (best, current) => current.score > best.score ? current : best,
    );
  }

  int get countPassed => _students.where((s) => s.passed).length;

  Map<String, List<Student>> get groupByGrade => {
    '优秀': _students.where((s) => s.score >= 90).toList(),
    '良好': _students.where((s) => s.score >= 80 && s.score < 90).toList(),
    '及格': _students.where((s) => s.score >= 60 && s.score < 80).toList(),
    '不及格': _students.where((s) => s.score < 60).toList(),
  };

  /// 及格学生中成绩最高的前 limit 人的总分。
  /// where → map → toList → sort → take → fold；只排序新建的成绩列表。
  double topPassingTotal(int limit) {
    if (limit < 0) throw ArgumentError.value(limit, 'limit', '不能为负数');
    return (_students.where((s) => s.passed).map((s) => s.score).toList()
          ..sort((a, b) => b.compareTo(a)))
        .take(limit)
        .fold<double>(0, (sum, score) => sum + score);
  }
}
