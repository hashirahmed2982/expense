import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'loading_circle.dart';
import 'plus_button.dart';
import 'top_card.dart';
import 'transaction.dart';
import 'config.dart';
import 'dart:convert';
import 'dart:math';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // collect user input
  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerTYPE = TextEditingController();
  final _textcontrollerNAME = TextEditingController();
  String type = "expense";
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  List? items;
  void initState() {
    // TODO: implement initState
    super.initState();

    getlist();
  }
  // CALCULATE THE TOTAL INCOME!
  double calculateIncome() {
   double totalIncome = 0;
   if(items != null) {
     for (int i = 0; i < items!.length; i++) {
       if (items![i]['type'] == 'income') {
         totalIncome += items![i]['amount'].toDouble();
       }
     }
   }
   return totalIncome;
   }
  // CALCULATE THE TOTAL EXPENSE!
  double calculateExpense() {
   double totalExpense = 0;
   if(items != null) {
     for (int i = 0; i < items!.length; i++) {
       if (items![i]['type'] == 'expense') {
         totalExpense += items![i]['amount'].toDouble();
       }
     }
   }
    return totalExpense;
   }
  void getlist() async {

    var response =  await http.get(Uri.parse(students),
        headers: {"Content-Type":"application/json"}
    );
    var jsonResponse = jsonDecode(response.body);
    items = jsonResponse;
    print(items);
    setState(() {});
  }


  // enter the new transaction into the spreadsheet
  void _enterTransaction() async {
    if(_isIncome){type = "income";}
    else{type = "expense";}

    var regBody = {
      "name":_textcontrollerNAME.text,
      "type": type,
      "amount": int.parse(_textcontrollerAMOUNT.text),
    };
    var response =  await http.post(Uri.parse(createstudent),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );
    var jsonResponse = jsonDecode(response.body);

   // if(jsonResponse['status']){
   //   print(jsonResponse['status']);
   // }else{
   //   print("SomeThing Went Wrong");
    _textcontrollerNAME.clear();
    _textcontrollerAMOUNT.clear();
    getlist();
  }
  void deleteItem(id) async{
    var regBody = {
      "_id":id
    };
    var response = await http.delete(Uri.parse(deleteurl + id),
        headers: {"Content-Type":"application/json"},
    );
    var jsonResponse = jsonDecode(response.body);

    getlist();

  }

  // new transaction
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('N E W  T R A N S A C T I O N'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Expense'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('Income'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'NAME?',
                              ),
                              controller: _textcontrollerNAME,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      

                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child:
                    Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: Text('Enter', style: TextStyle(color: Colors.white)),
                    onPressed: () {

                        _enterTransaction();
                        Navigator.of(context).pop();

                    },
                  )
                ],
              );
            },
          );
        });
  }

  // wait for the data to be fetched from google sheets


  @override
  Widget build(BuildContext context) {
    // start loading until the data arrives


    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TopNeuCard(
              balance: (calculateIncome() -
                  calculateExpense())
                  .toString(),
              income: calculateIncome().toString(),
              expense: calculateExpense().toString(),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: items == null
                            ? LoadingCircle()
                            : ListView.builder(
                            itemCount:
                            items!.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                  key: UniqueKey(),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  dismissible: DismissiblePane(onDismissed: () {
                                    print('${items![index]['_id']}');
                                    deleteItem('${items![index]['_id']}');
                                  }),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,

                                      label: 'Delete',

                                      onPressed: (BuildContext context) {

                                        print('${items![index]['_id']}');
                                        deleteItem('${items![index]['_id']}');
                                      },
                                    ),
                                  ],
                                ),
                              child : MyTransaction(
                                name:
                                    items![index]['name'],
                                type:
                                    items![index]['type'],
                                amount:
                                items![index]['amount'],
                              )
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            PlusButton(
              function: _newTransaction,
            ),
          ],
        ),
      ),
    );
  }
}