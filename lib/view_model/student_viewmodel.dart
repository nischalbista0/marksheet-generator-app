import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/student.dart';
import '../state/student_state.dart';

final resultViewModelProvider =
    StateNotifierProvider<ResultViewModel, ResultState>(
        (ref) => ResultViewModel());

class ResultViewModel extends StateNotifier<ResultState> {
  //providing initial state
  ResultViewModel() : super(ResultState.initial());

  //Add marks
  void addResult(Result result) {
    state = state.copyWith(isLoading: true);

    //Add result to list
    state.marks.add(result);

    // make progress bar stop
    state = state.copyWith(isLoading: false);
  }

 void removeResult(Result result) { // Receive the result object
  state = state.copyWith(isLoading: true);

  // Remove result from list
  state.marks.remove(result);

  // Make progress bar stop
  state = state.copyWith(isLoading: false);
}

}
