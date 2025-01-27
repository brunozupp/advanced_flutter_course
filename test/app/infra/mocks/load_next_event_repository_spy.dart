import 'package:advanced_flutter_course/app/domain/entities/next_event.dart';

/// Mock, Spy, Stub
/// When I test both input and output it's a spy;
/// When I am worried only about the input it's a mock;
/// When I am worried only about the output it's a stub;
class LoadNextEventRepositorySpy {

  /// These properties make sense just in this case, when I make a Mock
  /// There is no sense doing this in a real repository implementation.
  /// But in the case of mocks it's acceptable to test things like if
  /// the inputs (parameters) are correct.
  String? groupId;
  var callsCount = 0;

  NextEvent? output;

  Error? error;

  Future<NextEvent> loadNextEvent({required String groupId}) async {
    this.groupId = groupId;
    callsCount++;

    if(error != null) throw error!;

    return output!;
  }
}