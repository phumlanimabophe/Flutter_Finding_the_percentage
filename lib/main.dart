import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool loading=false;
  var stateSet;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.8),
          title: Text('Average Marks Calculator'),
          actions: [
            IconButton(icon: Icon(Icons.refresh), onPressed: () { 
              stateSet((){
                loading=true;
              });

                Future.delayed(Duration(seconds: 5), () {
                  stateSet((){
                loading=false;
              });
                });
             },)
          ],
        ),
        body: Stack(
          children: [
             Positioned(
              top: 0.0,bottom: 0.0,left: 0.0,right: 0.0,
              child: Builder(
              builder: (context) {
                int currentImageIndex = 0;
                var setContext;
                List<String> imageUrls = [
                  'https://images.pexels.com/photos/13381062/pexels-photo-13381062.jpeg',
                  'https://images.pexels.com/photos/13905748/pexels-photo-13905748.jpeg',
                  'https://images.pexels.com/photos/12778064/pexels-photo-12778064.jpeg'
                ];

                Timer.periodic(Duration(seconds: 10), (timer) {
                try{
                      currentImageIndex = (currentImageIndex + 1) % imageUrls.length;
           
                  (setContext as Element).markNeedsBuild(); // Trigger widget rebuild
                  
                }catch(e){
                
                }
                  
                });

                return StatefulBuilder(
                  builder: (context, setState) {
                    setContext=context;
                    return Container(
                      color: Colors.blue,
                      child: IndexedStack(
                        alignment: Alignment.center,
                        index: currentImageIndex,
                        children: List.generate(imageUrls.length, (index) {
                          return Center(
                            child: SizedBox.expand(
                              child: FadeTransition(
                                opacity: AlwaysStoppedAnimation<double>(
                                  index == currentImageIndex ? 1.0 : 0.0,
                                ),
                                child: Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                );
              },
            ),
          ),
            StatefulBuilder(
        builder: (context,state) {
          stateSet=state;
          if(loading){
            return Positioned(
              top: 0.0,bottom: 0.0,left: 0.0,right: 0.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new CircularProgressIndicator(),
                  new Text("Loading"),
                ],
              ),
            );
          }
                return AverageMarksCalculator();
              }
            ),
          ],
        ),
      ),
    );
  }
}

class AverageMarksCalculator extends StatefulWidget {
  @override
  _AverageMarksCalculatorState createState() => _AverageMarksCalculatorState();
}

class _AverageMarksCalculatorState extends State<AverageMarksCalculator> {
  String _selectedStudent = ''; 
  String _averageMarksResult = '';

  Map<String, List<int>> studentMarks = {
    'Krishna': [67, 68, 69],
    'Arjun': [70, 98, 63],
    'Malika': [52, 56, 60],
  };

  void _calculateAverageMarks() {
    setState(() {
      if (_selectedStudent.isNotEmpty) {
        List<int>? marks = studentMarks[_selectedStudent];
        for (int v in marks!) {
          if (v < 0 || v > 100) {
            _averageMarksResult = "0 <= v <= 100: failed!";
            return;
          }
        }

        if (marks.length != "3") {
          
          double averageMarks = marks.reduce((a, b) => a + b) / marks.length;
          _averageMarksResult = averageMarks.toStringAsFixed(2);
        } else {
        
          _averageMarksResult = "length of marks array = 3: failed!";
        }
      } else {
        _averageMarksResult = "Please select a student!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildStudentMarksTable(studentMarks),
          Container(
            width: 400.0,
            child: Card(
              color:Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  DropdownButton<String>(
                    dropdownColor:Colors.black,
                    value: _selectedStudent.isNotEmpty ? _selectedStudent : null, // Handle the null case
                    hint: Text('Select a student',style:TextStyle(color: Colors.white)),
                    items: studentMarks.keys.map((String student) {
                      return DropdownMenuItem<String>(
                        
                        value: student,
                        child: Text(student,style:TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStudent = newValue ?? '';
                      });
                    },
                  ),
                 SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _calculateAverageMarks,
                  child: Text('Calculate Average Marks'),
                ),
                SizedBox(height: 16),
                Text(
                  'Average Marks: $_averageMarksResult',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                ),
          
                
                ],
              ),
            ),
          ),
          ],
      ),
    );
  }


Widget buildStudentMarksTable(Map<String, List<int>> studentMarks) {
  return Expanded(
    child: Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        title: Text('Student Marks'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: studentMarks.length,
          itemBuilder: (BuildContext context, int index) {
            String studentName = studentMarks.keys.elementAt(index);
            List<int> marks = studentMarks[studentName]!;

            return Card(
              elevation: 4,
              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  studentName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                subtitle: Wrap(
                
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (int mark in marks) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$mark',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              
              ),
            );
          },
        ),
      ),
    ),
  );
}

}