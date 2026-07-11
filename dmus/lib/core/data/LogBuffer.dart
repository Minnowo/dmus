import 'dart:async';
import 'dart:collection';

/// Keeps a rolling buffer of recently formatted log lines and publishes new
/// lines as they come in
///
/// Used to power the in-app log viewer so users can see recent logs without
/// pulling the log file off the device
final class LogBuffer {
  LogBuffer._();

  static const int maxLines = 1000;

  static final Queue<String> _lines = Queue<String>();

  static final _controller = StreamController<String>.broadcast();

  /// Publishes each new formatted log line as it is written
  static Stream<String> get onLine => _controller.stream;

  /// The most recent log lines, oldest first
  static List<String> get recent => List.unmodifiable(_lines);

  static void add(String line) {
    _lines.addLast(line);

    while (_lines.length > maxLines) {
      _lines.removeFirst();
    }

    _controller.add(line);
  }
}
