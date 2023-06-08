import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/calculation.dart';
import '../model/student.dart';
import '../view_model/student_viewmodel.dart';

class ResultView extends ConsumerStatefulWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultViewState();
}

class _ResultViewState extends ConsumerState<ResultView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController marksController = TextEditingController();
  List<String> moduleList = [
    'Mobile Application',
    'Web API',
    'Design Thinking',
    'Individual Project'
  ]; // List of values for dropdown
  String? selectedModule =
      'Mobile Application'; // Initially selected dropdown value

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var resultState = ref.watch(resultViewModelProvider);

    int getTotalMarks() {
      List<Result> results = resultState.marks;
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      return ResultUtils.getTotalMarks(results, firstName, lastName);
    }

    String getResult() {
      List<Result> results = resultState.marks;
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();

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

      if (hasFailedSubject) {
        return 'Fail';
      } else {
        int totalMarks = getTotalMarks();
        return ResultUtils.getResult(totalMarks, results, firstName, lastName);
      }
    }

    String getDivision() {
      int totalMarks = getTotalMarks();
      return ResultUtils.getDivision(totalMarks);
    }

    List<Result> results = resultState.marks;

    List<DataRow> dataTableRows = [];

    for (Result result in results) {
      if (result.firstname == firstNameController.text.trim() &&
          result.lastname == lastNameController.text.trim()) {
        dataTableRows.add(
          DataRow(
            cells: [
              DataCell(Text(result.module![0])),
              DataCell(Text(result.marks!.join(', '))),
              DataCell(
                IconButton(
                  onPressed: () {
                    ref
                        .read(resultViewModelProvider.notifier)
                        .removeResult(result); // Pass the result object
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marksheet'),
        backgroundColor: Colors.blue, // Updated color
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter first name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter last name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a module';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Select Module',
                ),
                value: selectedModule,
                onChanged: (newValue) {
                  setState(() {
                    selectedModule = newValue;
                  });
                },
                items: moduleList.map<DropdownMenuItem<String>>(
                  (String module) {
                    return DropdownMenuItem<String>(
                      value: module,
                      child: Text(
                        module,
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  },
                ).toList(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: marksController,
                decoration: const InputDecoration(
                  hintText: 'Enter Marks',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Updated color
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Result result = Result(
                        firstname: firstNameController.text.trim(),
                        lastname: lastNameController.text.trim(),
                        marks: marksController.text.trim().split(','),
                        module: [selectedModule!],
                      );

                      ref
                          .read(resultViewModelProvider.notifier)
                          .addResult(result);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Marks added'),
                        ),
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ),
              const SizedBox(height: 10),
              if (dataTableRows.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            Text(
                              'Student Name: ${firstNameController.text.trim()} ${lastNameController.text.trim()}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Module')),
                            DataColumn(label: Text('Marks')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: dataTableRows,
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Text(
                              'Total Marks: ${getTotalMarks()}',
                            ),
                            Text(
                              'Result: ${getResult()}',
                            ),
                            Text(
                              'Division: ${getDivision()}',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
