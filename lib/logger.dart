/// 日志是可复用能力，无须为获得日志能力而占用父类。
mixin Logger {
  void log(String message) => print('[$runtimeType] $message');
}
