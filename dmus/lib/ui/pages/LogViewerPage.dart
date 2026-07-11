import 'dart:async';

import 'package:dmus/core/data/LogBuffer.dart';
import 'package:dmus/ui/dialogs/Util.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../lookfeel/CommonTheme.dart';

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

  @override
  void initState() {
    super.initState();

    _lines.addAll(LogBuffer.recent);

    _subscription = LogBuffer.onLine.listen((line) {
      setState(() => _lines.add(line));
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
          : ListView.builder(
              controller: _scrollController,
              itemCount: _lines.length,
              itemBuilder: (context, index) {
                final line = _lines[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    line,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: _colorForLine(line),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color? _colorForLine(String line) {
    if (line.startsWith('SEVERE') || line.startsWith('SHOUT')) return RED;
    if (line.startsWith('WARNING')) return Colors.orange;
    return null;
  }
}
