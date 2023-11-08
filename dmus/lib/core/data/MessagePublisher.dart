

import 'dart:async';

import 'package:dmus/core/data/DataEntity.dart';

/// Handles publishing events for any reason
///
/// This allows the ui part of the app to show required stuff when the core has problems
///
/// This allows the ui to show snackbars and other information whenever
final class MessagePublisher {

  MessagePublisher._();


  static final _somethingFailedStreamController = StreamController<String>.broadcast();

  static final _rawErrorStreamController = StreamController<Exception>.broadcast();

  static final _showSnackbarStreamController = StreamController<SnackBarData>.broadcast();


  /// Publishes text when something has gone wrong, whatever that may be
  static Stream<String> get onSomethingWentWrong {
    return _somethingFailedStreamController.stream;
  }

  /// Publishes raw exceptions
  static Stream<Exception> get onRawError {
    return _rawErrorStreamController.stream;
  }

  /// Publishes snackbars
  static Stream<SnackBarData> get onShowSnackbar {
    return _showSnackbarStreamController.stream;
  }



  /// Publish a something went wrong message
  static void publishSomethingWentWrong(String pub) {
    _somethingFailedStreamController.add(pub);
  }


  /// Publish a raw exception
  static void publishRawException(Exception pub) {
    _rawErrorStreamController.add(pub);
  }


  /// Publish a snackbar
  static void publishSnackbar(SnackBarData pub) {
    _showSnackbarStreamController.add(pub);
  }
}