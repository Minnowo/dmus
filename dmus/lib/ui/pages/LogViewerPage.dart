import 'dart:async';

import 'package:dmus/core/data/LogBuffer.dart';
import 'package:dmus/ui/dialogs/Util.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../lookfeel/CommonTheme.dart';

const TextStyle _logTextStyle = TextStyle(fontFamily: 'monospace', fontSize: 12);

class LogViewerPage extends StatefulWidget {
  const LogViewerPage({super.key});

  @override
  State<LogViewerPage> createState() => _LogViewerPageState();
}

class _LogViewerPageState extends State<LogViewerPage> {
  final List<String> _lines = [];
  final ScrollController _scrollController = ScrollController();

  StreamSubscription<String>? _subscription;

  bool _autoScroll = true;
  bool _wordWrap = true;

  // Tracks the widest line seen so far, so the unwrapped view can give the whole
  // log a single fixed width and scroll it horizontally as one unit, rather than
  // scrolling each line independently
  String _longestLine = '';
  double _longestLineWidth = 0;

  @override
  void initState() {
    super.initState();

    _lines.addAll(LogBuffer.recent);

    for (final line in _lines) {
      _considerLongest(line);
    }

    _subscription = LogBuffer.onLine.listen((line) {
      setState(() {
        _lines.add(line);
        _considerLongest(line);
      });
      _scrollToBottom();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _considerLongest(String line) {
    if (line.length <= _longestLine.length) return;

    _longestLine = line;

    final painter = TextPainter(
      text: TextSpan(text: line, style: _logTextStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    _longestLineWidth = painter.width;
  }

  void _scrollToBottom() {
    if (!_autoScroll) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.logViewer),
        actions: [
          IconButton(
            icon: Icon(_wordWrap ? Icons.wrap_text : Icons.notes),
            tooltip: S.current.wordWrap,
            onPressed: () => setState(() => _wordWrap = !_wordWrap),
          ),
          IconButton(
            icon: Icon(_autoScroll ? Icons.vertical_align_bottom : Icons.vertical_align_bottom_outlined),
            tooltip: S.current.autoScroll,
            onPressed: () => setState(() {
              _autoScroll = !_autoScroll;
              _scrollToBottom();
            }),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: S.current.exportLogFile,
            onPressed: () => exportLogFile(context),
          ),
        ],
      ),
      body: _lines.isEmpty
          ? Center(child: Text(S.current.noLogsYet))
          : SelectionArea(
              child: _wordWrap ? _buildWrapped() : _buildUnwrapped(),
            ),
    );
  }

  /// Lines wrap within the available width, so a plain vertically scrolling list is enough
  Widget _buildWrapped() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _lines.length,
      itemBuilder: (context, index) => _buildLine(_lines[index], wrap: true),
    );
  }

  /// Lines are laid out at their natural width inside a fixed-width column, and that whole
  /// column is scrolled horizontally as a single unit, so every line moves together like in
  /// a regular text editor instead of each line scrolling independently
  Widget _buildUnwrapped() {
    return LayoutBuilder(builder: (context, constraints) {
      final contentWidth = (_longestLineWidth + HORIZONTAL_PADDING * 2).clamp(constraints.maxWidth, double.infinity);

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: contentWidth,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _lines.length,
            itemBuilder: (context, index) => _buildLine(_lines[index], wrap: false),
          ),
        ),
      );
    });
  }

  Widget _buildLine(String line, {required bool wrap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        line,
        softWrap: wrap,
        overflow: wrap ? TextOverflow.clip : TextOverflow.visible,
        style: _logTextStyle.copyWith(color: _colorForLine(line)),
      ),
    );
  }

  Color? _colorForLine(String line) {
    if (line.startsWith('SEVERE') || line.startsWith('SHOUT')) return RED;
    if (line.startsWith('WARNING')) return Colors.orange;
    return null;
  }
}
