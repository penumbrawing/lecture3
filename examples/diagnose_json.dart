import 'package:lecture3/lecture3.dart';


void main() {
  try {
    Student.fromJson({'id': '01', 'name': '李华', 'score': '92'});
  } on TypeError catch (error) {
    print('诊断实验：JSON score 为字符串时转换失败。');
    print(error);
  }
  final student = Student.fromJson({'id': '01', 'name': '李华', 'score': 92});
  print('修正为数值后: ${student.score}');
}
