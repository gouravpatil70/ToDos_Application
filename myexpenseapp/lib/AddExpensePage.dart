import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myexpenseapp/Utils/AppColors.dart';
import 'ExpenseClass.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class ExpensePage extends StatefulWidget{
  final String appBarTitle;
  final Expenses expenseClassObject;
  const ExpensePage({super.key, required this.expenseClassObject, required this.appBarTitle});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage>{
  

  // Required variables 
  final GlobalKey<FormState> _key = GlobalKey();
  var expenseTitle,expenseAmount;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  var switchValue;
  final TextEditingController _transactionController = TextEditingController();
  @override
  void initState(){
    super.initState();
    setState(() {
      switchValue = widget.expenseClassObject.mode == 'Debit'
                    ? false
                    : true;
      _transactionController.text = widget.expenseClassObject.mode;
    });
  }


  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: ()async{
        moveToHomeScreen();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
        ),
        backgroundColor: AppColors.appBodyBackgroundColor,
        body: Form(
          key: _key,
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right:8.0,top: 40.0,bottom: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // Taking the title/reason
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 10.0),
                          child: TextFormField(
                            initialValue: widget.expenseClassObject.reason,
                            validator: (input){
                              if(input!.isEmpty){
                                return 'Please Enter title';
                              }else if(input.length > 255){
                                return 'Please enter a smaller text';
                              }else{
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Title',
                              hintStyle: TextStyle(
                                fontSize: 19.0,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                )
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.list,
                                  size: 40.0,
                                ),
                              )
                            ),
                            onChanged: (input) => expenseTitle = input,
                          ),
                      ),

                      // Taking the Switch of creted or debit
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                        child: Row(
                          children: [
                            Switch(
                              value: switchValue, 
                              onChanged: (input){
                                setState(() {
                                  switchValue = !switchValue;
                                  switchValue ? _transactionController.text = 'Credit'
                                              : _transactionController.text = 'Debit';
                                });
                              },
                              activeColor: AppColors.switchActiveColor,
                              inactiveThumbColor: AppColors.switchInActiveColor,
                            ),
                            Expanded(
                              child: TextField(
                                enabled: false,
                                controller: _transactionController,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                    )
                                  ),
                                  
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // For entering money
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 10.0),
                          child: TextFormField(
                            initialValue: (widget.expenseClassObject.rupees).toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (input){
                              if(input!.isEmpty){
                                return 'Please enter amount';
                              }else{
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Amount',
                              hintStyle: TextStyle(
                                fontSize: 19.0,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                )
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.currency_rupee_sharp,
                                  size: 30.0,
                                ),
                              )
                            ),
                            onChanged: (input) => expenseAmount = int.parse(input)
                          ),
                      ),

                      // Submit button
                      const Padding(padding: EdgeInsets.only(top: 20.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              _save();
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColorAddExpense1,
                              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0)
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                              )
                            )
                          ),
                          ElevatedButton(
                            onPressed: (){
                              _dalete(widget.expenseClassObject.id);
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColorAddExpense2,
                              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0)
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                              )
                            )
                          ),
                        ],
                      )
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }


  _save()async{
    if(_key.currentState!.validate()){
      _key.currentState!.save();
      
      
      var date  = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // If null means if the user click on update the expense that time
      expenseTitle ??= widget.expenseClassObject.reason;
      expenseAmount ??= widget.expenseClassObject.rupees;
      
      widget.expenseClassObject.reason = expenseTitle;
      widget.expenseClassObject.rupees = expenseAmount;
      widget.expenseClassObject.mode = _transactionController.text;
      widget.expenseClassObject.date = date.toString();
      print(widget.expenseClassObject.mode);
      int result;
      
      if(widget.expenseClassObject.id == 0){
        result = await _databaseHelper.insertData(widget.expenseClassObject);
       moveToHomeScreen();
      }else{
        result = await _databaseHelper.updateData(widget.expenseClassObject);
        moveToHomeScreen();
      }

      if(result != 0){
        _showAlertDialog('Success', 'Data saved successfully');
      }else{
        _showAlertDialog('Error', 'Data not saved successfully');
      }
      
    }else{
      _showAlertDialog('Error','Something was wrong');
    }
  }

  _dalete(int newId)async{
    int result;
    if(newId != 0){
      result = await _databaseHelper.deleteData(newId);
      moveToHomeScreen();
      if(result != 0){
        _showAlertDialog('Success', 'Data deleted successfully');
      }else{
        _showAlertDialog('Error', 'Something was wrong');
      }
    }
  }

  _showAlertDialog(String title,String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_)=> alertDialog);
  }

  moveToHomeScreen(){
    Navigator.pop(context,true);
  }
}


//   children: [
//   // For the Reason
//   TextFormField(
//     initialValue: widget.expenseClassObject.reason,
//     validator: (input){
//       if(input!.isEmpty){
//         return 'Please enter a text';
//       }else if(input.length > 255){
//         return 'Please enter a smaller text';
//       }else{
//         return null;
//       }
//     },
//     decoration: const InputDecoration(
//       labelText: 'Enter Reason',
//       prefixIcon: Icon(
//         Icons.list_alt
//       ),
//       border: OutlineInputBorder(),
//     ),
//     onChanged: (input) => expenseReason = input,
//   ),


//   // For the Rupees
//   const Padding(padding: EdgeInsets.all(10.0)),
//   TextFormField(
//     initialValue: (widget.expenseClassObject.rupees).toString(),
//     keyboardType: TextInputType.number,
//     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//     validator: (input){
//       if(input!.isEmpty){
//         return 'Please enter amount';
//       }else{
//         return null;
//       }
//     },
//     decoration: const InputDecoration(
//       labelText: 'Enter Amount',
//       prefixIcon: Icon(
//         Icons.currency_rupee,
//       ),
//       border: OutlineInputBorder(),
//     ),
//     onChanged: (input)=> expenseRupees = int.parse(input),
//   ),

//   const Padding(padding: EdgeInsets.all(10.0)),
  
//   Row(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: [
//       ElevatedButton(
//         onPressed: (){
//           setState(() {
//             _save();
//           });
//         }, 
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red
//         ),
//         child: const Text(
//           'Save',
//           style: TextStyle(
//             fontSize: 25.0
//           ),
//         ),
//       ),
//       ElevatedButton(
//         onPressed: (){
//           _dalete(widget.expenseClassObject.id);
//         }, 
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red
//         ),
//         child: const Text(
//           'Delete',
//           style: TextStyle(
//             fontSize: 25.0
//           ),
//         ),
//       ),
//     ],
//   )
// ],
//  Form(
//           key: _key,
//           child: Center(
//             child: SingleChildScrollView(
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                       children: [

//                         // For Title input field
//                         Expanded(
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.list,
//                               ),
//                               TextFormField(
//                                 validator: (input){
//                                   if(input!.isEmpty){
//                                     return 'Please Enter title';
//                                   }else if(input.length > 255){
//                                     return 'Please enter a smaller text';
//                                   }else{
//                                     return null;
//                                   }
//                                 },
//                                 decoration: const InputDecoration(
//                                   labelText: 'Title',
//                                   border: UnderlineInputBorder(),
//                                 ),
//                                 onChanged: (input) => expenseTitle = input,
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                 ),
//               ),
//             ),
//           ),
//         )