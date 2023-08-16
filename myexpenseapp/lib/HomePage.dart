import 'package:flutter/material.dart';
import 'package:myexpenseapp/AddExpensePage.dart';
import 'package:sqflite/sqflite.dart';
import 'ExpenseClass.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';
import 'Utils/AppColors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Requried variables
  var expenseList;
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  
  // dashboard variables
  var spendAmount,creditedAmount,availableAmount;

  // Calender variables
  bool isDisplayCalnder = false;
  var _month; 
  var _year;
  var _initialStartDay;
  var _comparingStartDate;
  var _comparingLastDate;


  updateTime()async{
      setState(() {
        _month =  DateTime.now().month;
        _year = DateTime.now().year;
        _initialStartDay = DateTime.utc(_year,_month,1);
        _comparingStartDate = DateFormat('yyyy-MM-dd').format(_initialStartDay);
        _comparingLastDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      });
      // print(_initialStartDay);
  }

  @override
  void initState(){
    super.initState();
    updateTime();
  }

  @override
  Widget build(BuildContext context) {
    if(expenseList == null){
      expenseList = <Expenses>[];
      updateTheListView();
    }
    return Scaffold(
      backgroundColor: AppColors.appBodyBackgroundColor,
      appBar: AppBar(
        title: const Text('My Expenses'),
        actions: [
          IconButton(
            onPressed: (){
              displayCalender();
              setState(() {
                isDisplayCalnder = !isDisplayCalnder;
              });
            },
            icon: const Icon(
              Icons.calendar_month,
            ),
          )
        ],
      ),
      body: count > 0 ? Column(
          children: [
            expensesManagesDashboard(),
            Expanded(
              child: getTheExpenseList(),
            ),
          ],
        ) 
        : Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            tileColor: const Color.fromARGB(255, 221, 216, 216),
            title: const Text(
              'Oopss !! No Data found',
              style: TextStyle(
                fontSize: 20.0
              ),
            ),
          ),
        ),
      // body: getTheExpenseList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          moveToModifyExpense(Expenses('', 0,'Debit',DateTime.now()),'Add Expense');
        },
        tooltip: 'Add new Expense',
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35.0,
        ),
      ),
    );
  }



  

  // Getting the listview
  ListView getTheExpenseList(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index){

        return Card(
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          clipBehavior: Clip.none,

          color: expenseList[index].mode == 'Credit'
                 ? AppColors.backgroundCardColor2
                 : AppColors.backgroundCardColor1
          ,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: 
              Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                tileColor: AppColors.tileColors,
                // tileColor: expenseList[index].mode == 'Credit' 
                //            ? AppColors.homePageTileColor2
                //            : AppColors.homePageTileColor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                       Text(
                        'Reason : ${expenseList[index].reason}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 15.0),
                      child: 
                      Text(
                        'Rupees : ${(expenseList[index].rupees).toString()}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  '${expenseList[index].date}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 16.0,
                    // color: Colors.white,
                  )
                ),
                onTap: (){
                  moveToModifyExpense(expenseList[index],'Edit Expense');
                },
              ),
            ),
          ),
        );
      },
    );
  }


  // Small Dashboard part
  Widget expensesManagesDashboard(){
    return Card(     
      // color: Color.fromARGB(192, 4, 136, 244),
      color: Colors.deepPurple[400],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                  ),
                  color: AppColors.homePageDashBoardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Text(
                          'Speand',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: AppColors.homePageDashBoardTextColor,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 5.0)),
                        Row(
                          children: [
                            Text(
                              spendAmount.toString(),
                              style: const TextStyle(
                                fontSize: 22.0,
                                color: AppColors.homePageDashBoardTextColor,
                              )
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5.0)),
                            const Icon(
                              Icons.arrow_downward_sharp,
                              size: 28.0,
                              color: AppColors.homePageDashBoardIconDebitedColor,
                            )
                          ],
                        )
                      ]
                    ),
                  )
                ),
      
                Card(
                   shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15.0), bottomLeft: Radius.circular(15.0)),
                  ),
                  color: AppColors.homePageDashBoardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Text(
                          'Deposite',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: AppColors.homePageDashBoardTextColor,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 5.0)),
                        Row(
                          children: [
                            Text(
                              creditedAmount.toString(),
                              style: const TextStyle(
                                fontSize: 22.0,
                                color: AppColors.homePageDashBoardTextColor,
                              )
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5.0)),
                            const Icon(
                              Icons.arrow_upward_sharp,
                              size: 28.0,
                              color: AppColors.homePageDashBoardCreditedColor,
                            )
                          ],
                        )
                      ]
                    ),
                  )
                ),
              ],
            ),
      
            Container(
              width: 160.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                color: AppColors.homePageDashBoardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Available',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: AppColors.homePageDashBoardTextColor,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 5.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              availableAmount.toString(),
                              style: const TextStyle(
                                fontSize: 22.0,
                                color: AppColors.homePageDashBoardTextColor,
                              )
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5.0)),
                            const Icon(
                              Icons.align_vertical_bottom_sharp,
                              size: 28.0,
                              color: AppColors.homePageDashBoardIconBargraphColor,
                            )
                          ],
                        )
                      ]
                    ),
                  )
                ),
              ),
            ],
          ),
      )
    );
  }


  // Moving the Adding the expenses page
  moveToModifyExpense(Expenses object, String title)async{
    bool listUpdateResult = 
    await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context){
          return ExpensePage(expenseClassObject: object, appBarTitle: title);
        }
    ));
    if(listUpdateResult == true){
      updateTheListView();
    }
  }

  // Getting the List of expenses from the database
  updateTheListView()async{
    final Future<Database> dbFuture =  databaseHelper.initializeDatabase();
    dbFuture.then((value)async{
      Future<List<Expenses>> list = databaseHelper.getExpensesClassList(_comparingStartDate,_comparingLastDate);
      int spendAmount = await databaseHelper.getTotalAmountSpeand();
      int creditedAmount = await databaseHelper.getTotalAmountCredit();
      int availableAmount = await databaseHelper.getTotalAvailableAmount();
      list.then((newList){
        setState(() {

          this.spendAmount = spendAmount;
          this.creditedAmount = creditedAmount;
          this.availableAmount = availableAmount;
          print(this.availableAmount);
          
          expenseList = newList;
          count = newList.length;

        });
      });
    });
  }

  displayCalender()async{
    await showDateRangePicker(
      context: context, 
      firstDate: DateTime.utc(2023,8,1), 
      lastDate: DateTime.now(),
      currentDate: DateTime.utc(2023,8,2),
      initialDateRange: DateTimeRange(start: _initialStartDay, end: DateTime.now()),
    ).then((value){
      // print(value);
      // print(value!.start);
      // print(value.end);
      if(value != null){
        setState(() {
          _comparingStartDate = DateFormat('yyyy-MM-dd').format(value.start);
          _comparingLastDate = DateFormat('yyyy-MM-dd').format(value.end);
        });
        // print(_comparingStartDate);
        updateTheListView();
      }
    });
  }
}