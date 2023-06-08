import '../model/student.dart';

class ResultUtils {
  static int getTotalMarks(
      List<Result> results, String firstName, String lastName) {
    int total = 0;
    for (Result result in results) {
      if (result.firstname == firstName.trim() &&
          result.lastname == lastName.trim()) {
        for (String mark in result.marks!) {
          int markValue = int.tryParse(mark) ?? 0;
          total += markValue;
        }
      }
    }
    return total;
  }

  static String getResult(
      int totalMarks, List<Result> results, String firstName, String lastName) {
    bool hasFailedSubject = false;

    for (Result result in results) {
      if (result.firstname == firstName && result.lastname == lastName) {
        for (String mark in result.marks!) {
          int markValue = int.tryParse(mark) ?? 0;
          if (markValue < 40) {
            hasFailedSubject = true;
            break;
          }
        }
        if (hasFailedSubject) {
          break;
        }
      }
    }

    if (totalMarks >= 160 && !hasFailedSubject) {
      return 'Pass';
    } else {
      return 'Fail';
    }
  }

  static String getDivision(int totalMarks) {
    double percentage = (totalMarks / 400) * 100;

    if (percentage >= 60) {
      return '1st Division';
    } else if (percentage >= 50) {
      return '2nd Division';
    } else if (percentage >= 40) {
      return '3rd Division';
    } else {
      return 'Fail';
    }
  }
}
