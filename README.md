# Lecture 3 Dart 面向对象与集合

完成:用 Student 封装成绩，用 GradeBook 执行集合统计，用 Logger mixin 复用日志，并以单元测试检查正常与异常路径。

## 运行

```powershell
dart pub get
dart run
dart test --reporter expanded
dart analyze
```

环境：Dart 3.13.3；沿用原项目的 pubspec.yaml 与 pubspec.lock。
## 项目结构

```text
bin/lecture3.dart              命令行入口
lib/student.dart              学生对象与统一成绩校验
lib/gradebook.dart             四项基础统计与链式扩展
lib/logger.dart                日志 mixin
lib/lecture3.dart              对外导出
test/lecture3_test.dart        13 个测试
examples/before_mixin.dart     可运行的继承改造前后对比
examples/diagnose_json.dart    字符串成绩的类型诊断实验
docs/ai-debugging-record.md    实际诊断记录
evidence/                     运行日志，学生复核时可重新生成
progress.md                   十节进度报告
```

## 验收结果

示例学生成绩：92、55、80、60、73。独立手算总分 360，平均分 72，及格人数 4；最高分学生为李华。分档人数为优秀 1、良好 1、及格 2、不及格 1。及格成绩降序为 92、80、73、60，前三名总分 245。

## 设计约定

- 学号、姓名为 final String；
- 成绩为 0 到 100 的有限数值，拒绝 NaN、无穷大及越界值。构造函数、fromJson、setter 都走同一校验。
- fromJson 要求 id/name 为字符串、score 为 num。
- 不传成绩时默认 0；
- 空成绩册 average/maxBy 返回 null，countPassed 返回 0，四个分组保留但为空，前三名总分为 0。
- 分档:优秀 [90,100]，良好 [80,90)，及格 [60,80)，不及格 [0,60)。教师未提供阈值；此处补齐低分组，保证所有学生都被归入一组。
- 最高分并列时返回输入列表中第一位；maxBy 是按指南使用的名称，固定比较成绩。
- 构造时固定集合成员，防止外部 add/clear 改动成绩册；Student 对象本身仍能修改成绩，统计 getter 会反映新成绩。
- topPassingTotal 的负数 limit 抛 ArgumentError，零返回 0，超过人数时使用全部及格成绩。

## 集合方法组合

`topPassingTotal` 求“及格学生中成绩最高的前 N 人总分”：

1. where：筛选及格学生。
2. map：将学生转换为成绩。
3. toList：物化成独立成绩列表。
4. sort：原地排序这份新列表，使用 `..` 保留列表作为表达式结果。
5. take：取前 N 项。
6. fold：从 0 累加。

共使用六种方法；sort 通过级联连接，其余通过方法调用组合。GradeBook 统计实现没有手写 for 循环。
## mixin 改造

运行 `dart run examples/before_mixin.dart`。

改造前：`GradeBookBefore extends LoggingBase`，为了调用 log 占用了一层继承。
改造后：`GradeBook with Logger`，日志实现作为能力混入，成绩册统计职责不变。
示例保留最小可运行的改造前类，并与最终类比较及格统计及日志输出。它是教学对比文件，不冒充已发生的历史 Git 提交。

## AI 使用与提交状态

代码、测试和报告由 trae实际运行验证。
