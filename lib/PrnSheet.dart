import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';

class PRNSheet extends StatefulWidget {
  @override
  _PRNSheetState createState() => _PRNSheetState();
}

class _PRNSheetState extends State<PRNSheet> {
  // Just for showing the user what file he has selected.
  final pathController = TextEditingController();

  // Manages the visibility of data.
  double dataVisibility = 0;

  // Manages data rows
  List<DataRow> dataRows = [
    DataRow(
      cells: [
        DataCell(Text(""))
      ]
    )
  ];

  //Manages data columns
  List<DataColumn> dataColumns = [
    DataColumn(
      label: Text(""),
    ),
  ];

  excel.DataTable table;

  @override
  Widget build(BuildContext context) {
    ScreenScaler scale = ScreenScaler()..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("New PRNs"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            
            Visibility(
              replacement: Container(),
              visible: dataVisibility != 1.0,
              child: Padding(
              padding: scale.getPadding(1, 1),
              child: TextField(
                controller: pathController,
                enabled: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
            ),
            ),

            Visibility(
              replacement: Container(),
              visible: dataVisibility != 1.0,
                child: RaisedButton(
                child: Text("Select File", style: TextStyle(color: Colors.white)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Colors.deepPurple,
                onPressed: () async {
                   final file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: [".xls", "xlsx"]);
                   pathController.text = file.path;
                   final bytes = file.readAsBytesSync();
                   final _excel = excel.Excel.decodeBytes(bytes, update: true);
                   for(final sheet in _excel.tables.keys){
                     table = _excel.tables[sheet];
                     
                     final rowCount = table.maxRows;
                     final columnCount = table.maxCols;

                     if(rowCount < 1) return;

                     final columns = table.rows[0];

                     dataColumns = columns.map((column){
                       return DataColumn(
                         label: Text(column),
                         tooltip: column
                       );
                     }).toList();

                    dataRows.clear();
                     for(int i = 1; i < rowCount; i++){
                       final row = table.rows[i];
                       List<DataCell> cells = [];
                       for(int j = 0; j < columnCount; j++){
                         cells.add(DataCell(Text(row[j])));
                       }
                       dataRows.add(DataRow(cells: cells));   
                     }

                     break;
                   }
                   setState(() {
                    dataVisibility = 1.0;   
                   });
                },
              ),
            ),
     
           Divider(), 
           
            AnimatedOpacity(
              curve: Curves.decelerate,
              duration: Duration(seconds: 1),
              opacity: dataVisibility,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Count: ${dataRows.length}"),
                RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  color: Colors.deepPurple,
                  child: Text("Upload", style: TextStyle(color: Colors.white,)),
                  onPressed: (){
                    print("Uploading");
                    var prnColumn = 0;
                    final count = table.maxRows;
                    
                    /// Doing this to determine the PRN cell.
                    final testRow = table.rows[1];
                    for(int i = 0; i < testRow.length; i++){
                      if(RegExp(r"[0-9]{16}").hasMatch(testRow[i].toString()))
                        prnColumn = i; 
                    }

                    
                    var batch = Firestore.instance.batch();
                    for(int i = 1; i < count; i++){
                      final row = table.rows[i];
                      // final cell = row[0];
                      final prn = row[prnColumn];
                      print(prn);
                      
                      // batch.setData(
                      //   Firestore.instance.collection("PRNs").document(prn), 
                      //   { "FirstName" : "First Name"}
                      // );

                    if(i == count - 1 || (i % 500 == 0 && i != 0)){
                      print("Commiting the current batch at $i");
                      // batch.commit();
                      // batch = Firestore.instance.batch();
                    }
                      
                    }
                    
                  },
                )
              ],
            ),
          ),

            Divider(), 

            AnimatedOpacity(
              curve: Curves.decelerate,
              duration: Duration(seconds: 1),
              opacity: dataVisibility,
              child: DataTable(
                columns: dataColumns, 
                rows: dataRows,
              ),
            ),

          ],
        ),
      ),
    );
  }
}