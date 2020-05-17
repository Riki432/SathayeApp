import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:toast/toast.dart';

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

  int prnColumn = 0; 

  Color uploadBtnColor = Colors.deepPurple;

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
                         label: Text("$column"),
                         tooltip: column
                       );
                     }).toList();

                    dataRows.clear();
                     for(int i = 1; i < rowCount; i++){
                       final row = table.rows[i];
                       List<DataCell> cells = [];
                       for(int j = 0; j < columnCount; j++){
                         cells.add(DataCell(
                            Text("${row[j]}"),
                            onTap: (){
                              if(RegExp(r"[0-9]{16}").hasMatch(row[j]))
                                prnColumn = j;
                            }
                           )
                          );
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


           Visibility(
             visible: dataVisibility == 1.0,
             replacement: Container(),
              child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: uploadBtnColor,
              child: Text("Upload", style: TextStyle(color: Colors.white,)),
              onPressed: (){
                final count = table.maxRows;
                
                /// Doing this to determine the PRN cell.
                final testRow = table.rows[1];
                for(int i = 0; i < testRow.length; i++){
                  if(RegExp(r"[0-9]{16}").hasMatch(testRow[i].toString()))
                    prnColumn = i; 
                }

                ///Firebase has a limit of 500 batch operations so we do all the rows,
                ///excluding the first one because that row is the column name,
                /// every 500th iteration or on the last iteration, we commit the batch.
                /// This works clearer and faster.
                var batch = Firestore.instance.batch();
                for(int i = 1; i < count; i++){
                  final row = table.rows[i];
                  final prn = row[prnColumn];
                  
                  batch.setData(
                    Firestore.instance.collection("PRNs").document(prn), 
                    { "TimeStamp" : Timestamp.now()}
                  );

                  if(i == count - 1 || (i % 500 == 0 && i != 0)){
                    print("Commiting the current batch at $i");
                    try{
                       batch.commit();
                    }
                    catch(ex){
                      Toast.show("Something went wrong", context);
                    }
                    batch = Firestore.instance.batch();
                  }
                }

                setState(() {
                  Toast.show("Done!", context, duration: Toast.LENGTH_LONG);
                  uploadBtnColor = Colors.green;
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
                Tooltip(
                  message: "Tap on the correct column if this is incorrect.",
                  child: Text("PRN Column : ${prnColumn + 1}", style: TextStyle(fontSize: scale.getTextSize(10)),),
                ),
                Text("Count: ${dataRows.length}", style: TextStyle(fontSize: scale.getTextSize(10))),
              ],
            ),
          ),

            Divider(), 

            // Visibility(
            //   visible: dataVisibility == 1.0,
            //   replacement: Container(),
            //   child: 
            // ),

           

            AnimatedOpacity(
              curve: Curves.decelerate,
              duration: Duration(seconds: 1),
              opacity: dataVisibility,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                  columns: dataColumns, 
                  rows: dataRows,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}