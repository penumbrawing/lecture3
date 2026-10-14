import 'package:lecture3/lecture3.dart';

void main() {
  final book = GradeBook([
    Student.fromJson({'id': '01', 'name': '李华', 'score': 92}),
    Student('02', '王芳', 55),
    Student('03', '张明', 80),
    Student('04', '陈晨', 60),
    Student('05', '刘洋', 73),
  ]);

  book.log('课程成绩册');
  print('学生人数: ${book.students.length}');
  print('平均分: ${book.average?.toStringAsFixed(2) ?? '暂无数据'}');
  print('最高分学生: ${book.maxBy ?? '暂无数据'}');
  print('及格人数: ${book.countPassed}');
  book.groupByGrade.entries
      .map(
        (entry) =>
            '${entry.key}: ${entry.value.length} 人 '
            '[${entry.value.map((s) => s.name).join(', ')}]',
      )
      .forEach(print);
  print('及格学生前三名总分: ${book.topPassingTotal(3).toStringAsFixed(2)}');

  final student = Student('06', '校验示例', 60);
  try {
    student.score = 101;
  } on ArgumentError catch (error) {
    print('非法修改已拒绝: $error');
  }
  print('拒绝修改后的成绩: ${student.score.toStringAsFixed(1)}');

  final empty = GradeBook([]);
  print(
    '空成绩册: average=${empty.average}, maxBy=${empty.maxBy}, '
    'countPassed=${empty.countPassed}',
  );
}
