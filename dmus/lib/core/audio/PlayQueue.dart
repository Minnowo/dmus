import 'dart:async';
import 'dart:collection';
import 'dart:math';

import '../Util.dart';
import '../data/DataEntity.dart';

/// What state the queue is in
enum QueueState {
  empty,
  single,
  start,
  middle,
  end,
}

/// The play queue
///
/// Handles songs, what is up next, what was played and where the player is at
class PlayQueue {
  PlayQueue();

  final _queueChangedStream = StreamController<void>.broadcast();
  bool _supressUpdate = false;

  Stream<void> get onQueueChanged {
    return _queueChangedStream.stream;
  }

  /// Get the current position
  int get currentPosition => _currentPosition;

  int get length => _queue.length;

  /// Get the state of the queue
  QueueState get state => _queueState;

  /// Get a list of songs from the queue
  UnmodifiableListView<Song> get readQueue {
    return UnmodifiableListView(_queue);
  }

  /// The private queue
  final List<Song> _queue = [];

  /// The private position
  int _currentPosition = -1;

  /// The private state
  QueueState _queueState = QueueState.empty;

  /// Moves to the previous item position in the queue and returns the song
  Song? advancePrevious() {
    if (_queueState == QueueState.start || _queueState == QueueState.single) {
      return null;
    }

    setPosition(_currentPosition - 1);

    return _queue[_currentPosition];
  }

  /// Moves to the next item position in the queue and returns the song
  Song? advanceNext() {
    if (_queueState == QueueState.end || _queueState == QueueState.single) {
      return null;
    }

    setPosition(_currentPosition + 1);

    return _queue[_currentPosition];
  }

  /// Moves to a random item position in the queue and returns the song
  Song? advanceRandom() {
    if (_queue.isEmpty) {
      return null;
    }

    if (_queue.length == 1) {
      return _queue.firstOrNull;
    }

    int pos = _currentPosition;

    do {
      setPosition(Random().nextInt(_queue.length));
    } while (_currentPosition == pos);

    return _queue[_currentPosition];
  }

  /// Gets the current song
  Song? current() {
    if (_queue.isEmpty) {
      return null;
    }

    return _queue[_currentPosition];
  }

  /// Set the current position in the queue
  ///
  /// If the given index is out of range, it sets the position to the start or end of the queue
  void setPosition(int index) {
    if (_queue.length == 1) {
      _currentPosition = 0;
      _queueState = QueueState.single;
      _fireChanged();
      return;
    }

    if (index <= 0) {
      _currentPosition = 0;
      _queueState = QueueState.start;
      _fireChanged();
      return;
    }

    if (index >= _queue.length - 1) {
      _currentPosition = _queue.length - 1;
      _queueState = QueueState.end;
      _fireChanged();
      return;
    }

    _currentPosition = index;
    _queueState = QueueState.middle;
    _fireChanged();
  }

  /// Jumps the position to the given index
  ///
  /// If the index is invalid do nothing
  void jumpToIndex(int index) {
    if (!canJump(index)) {
      return;
    }

    setPosition(index);
  }

  /// Jumps the position to the current song
  ///
  /// If the song is after the current position jump forward
  ///
  /// If the song is before the current position jump backward
  ///
  /// If the song is not in the queue add it next and jump
  void jumpTo(Song s) {
    if (_queue.isEmpty) {
      return queueAdvanceNext(s);
    }

    for (int i = _currentPosition; i < _queue.length; i++) {
      if (_queue[i] == s) {
        setPosition(i);
        return;
      }
    }

    for (int i = _currentPosition; i > -1; i--) {
      if (_queue[i] == s) {
        setPosition(i);
        return;
      }
    }

    queueAdvanceNext(s);
  }

  /// Returns true if the index is valid for jumping
  bool canJump(int index) {
    return _queue.isNotEmpty && index >= 0 && index < _queue.length;
  }

  /// Add the song to the next position in the queue and move the position forward
  void queueAdvanceNext(Song s) {
    _queue.insert(_currentPosition + 1, s);
    setPosition(_currentPosition + 1);
  }

  /// Add the song to the next position in the queue
  void queueNext(Song s) {
    _queue.insert(_currentPosition + 1, s);
    setPosition(_currentPosition);
  }

  /// Append the song to the queue
  void addToQueue(Song s) {
    _queue.add(s);
    setPosition(_currentPosition);
  }

  /// Removes the queue at the given index
  Song? removeAt(int i) {
    if (i < 0 || i > _queue.length) return null;

    Song? s;

    if (_queue.length == 1) {
      s = current();
      clear();
      return s;
    }

    s = _queue.removeAt(i);

    setPosition(_currentPosition);

    return s;
  }

  /// Append the list of songs to the queue
  void addAllToQueue(Iterable<Song> s) {
    _queue.addAll(s);
    setPosition(_currentPosition);
  }

  void addAllToQueueNext(Iterable<Song> s) {
    if (_currentPosition + 1 >= _queue.length) {
      _queue.addAll(s);
    } else {
      _queue.insertAll(_currentPosition + 1, s);
    }

    setPosition(_currentPosition);
  }

  /// Shuffles the queue
  void shuffleQueue() {
    if (_queue.isEmpty) return;

    Song? s = current();

    if (s == null) return;

    logging.info("Shuffle queue ------------------------");
    _queue.shuffle();
    jumpTo(s);

    _fireChanged();
  }

  /// Replace the queue contents with the given iterable
  ///
  /// Does not fire a queuechanged event
  void replaceWithNoChange(Iterable<Song> s) {
    _supressUpdate = true;
    _queue.replaceRange(0, _queue.length, s);
    setPosition(_currentPosition);
    _supressUpdate = false;
  }

  /// Empty the queue
  void clear() {
    _queue.clear();
    _currentPosition = -1;
    _queueState = QueueState.empty;
    _fireChanged();
  }

  void _fireChanged() {
    if (!_supressUpdate) {
      _queueChangedStream.add(null);
    }
  }
}
