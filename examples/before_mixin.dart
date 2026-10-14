import 'package:lecture3/lecture3.dart';


class LoggingBase {
  void log(String message) => print('[$runtimeType] $message');
}

class GradeBookBefore extends LoggingBase {
  final List<Student> students;
  GradeBookBefore(this.students);
  int get countPassed => students.where((s) => s.passed).length;
}

void main() {
  final students = [Student('01', '李华', 92), Student('02', '王芳', 55)];
  final before = GradeBookBefore(students);
  final after = GradeBook(students);
  before.log('及格人数: ${before.countPassed}');
  after.log('及格人数: ${after.countPassed}');
}
