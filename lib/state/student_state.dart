import '../model/student.dart';

class ResultState {
  bool isLoading;
  List<Result> marks;

  ResultState({
    required this.isLoading,
    required this.marks,
  });

  //Initial state
  ResultState.initial()
      : this(
          isLoading: false,
          marks: [],
        );

//Copywith
  ResultState copyWith({
    bool? isLoading,
    List<Result>? students,
  }) {
    return ResultState(
      isLoading: isLoading ?? this.isLoading,
      marks: students ?? this.marks,
    );
  }
}
