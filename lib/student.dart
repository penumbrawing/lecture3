/// 一个学生。成绩必须是 0 到 100 的有限数值。
class Student {
  final String id;
  final String name;
  double _score;

  Student(this.id, this.name, [double score = 0])
    : _score = _validateScore(score);

  Student.fromJson(Map<String, dynamic> json)
    : this(
        json['id'] as String,
        json['name'] as String,
        (json['score'] as num).toDouble(),
      );

  double get score => _score;

  set score(double value) {
    _score = _validateScore(value);
  }

  // 构造函数与 setter 共用校验，避免创建时绕过规则。
  static double _validateScore(double value) {
    if (!value.isFinite || value < 0 || value > 100) {
      throw ArgumentError.value(value, 'score', '成绩必须是 0 到 100 的有限数值');
    }
    return value;
  }

  bool get passed => _score >= 60;

  @override
  String toString() => '$id $name ${score.toStringAsFixed(1)}';
}
