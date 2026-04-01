import 'package:flutter/material.dart';

import 'Item.dart';
import 'ItemDAO.dart';
import 'ItemDatabase.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const MyHomePage(title: 'Flutter Demo Lab7 Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> list1 = [];


  Item? selectedItem = null;//nothing is selected

  late ItemDAO itemDAO;
  late TextEditingController _quantityController;
  var isChecked = false;
  var myFontSize = 0.0;
  late TextEditingController _controller; //late means promise to initialize it later

  //can't be async, because it overrides from parent
  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _quantityController = TextEditingController();

    $FloorItemDatabase.databaseBuilder('ItemFile.db').build()
        .then((database) {
      itemDAO = database.myDAO;

      itemDAO.getAllItems().then((listOfItems) {
        setState(() {
          list1.addAll(listOfItems);
        });
      });
    });
  }
  //you are being removed
  @override
  void dispose() {

    //free memory:
    _controller.dispose();
    _quantityController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: reactiveLayout(), //decides how to lay out

    );
  }

  Widget reactiveLayout(){

    var size = MediaQuery.of(context).size; ///how big is the screen?
    var height = size.height;
    var width = size.width;



    if( (width>height) && (width > 480)) {
      //tablet landscape

      return Row( children:[
        Expanded(flex:2,child: listPage()    ), //Left side 40%
        Expanded(flex:5,child: detailsPage() ) //Right side, 60%
      ]);
    }
    else{ //Portrait mode / Phone
      if( selectedItem== null) {
        return listPage(); //show the list
      } else {
        return detailsPage(); //show the details
      }
    }
  }

  Widget detailsPage() {
    if(selectedItem != null){
      return Center(child:Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("ID: ${selectedItem!.id}", style: TextStyle(fontSize: 40.0),),
        Text("Name: ${selectedItem!.name}", style: TextStyle(fontSize: 40.0),),
        Text("Quantity: ${selectedItem!.quantity}", style: TextStyle(fontSize: 40.0)),
        Spacer(),//balloon that expands to fill the space
        OutlinedButton(onPressed: (){
          setState(() {
            list1.remove(selectedItem);
            itemDAO.deleteItem(selectedItem!); //
            selectedItem = null; });
        }, child: Text("Delete")),


        OutlinedButton(onPressed: (){
          setState(() { selectedItem = null; });
        }, child: Text("Close"))

      ], )
      ); //show what's been selected
    }
    else{
      return Text("Please select an item from the list",style: TextStyle(fontSize: 30.0));
    }
  }

  Widget listPage() {
    return Column(
      children: [

        // 🔥 输入区（关键）
        Row(
          children: [

            // 按钮
            Expanded(
              flex: 2,
              child: ElevatedButton(
                child: Text("Add"),
                onPressed: () {
                  setState(() {

                    int quantity =
                        int.tryParse(_quantityController.text) ?? 1;

                    Item newItem = Item(
                      Item.ID++,
                      quantity,
                      _controller.text,
                    );

                    itemDAO.insertItem(newItem);
                    list1.add(newItem);

                    _controller.text = "";
                    _quantityController.text = "";
                  });
                },
              ),
            ),

            // 名字输入框
            Expanded(
              flex: 4,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: "Item Name"),
              ),
            ),

            // 🔥 数量输入框（就在这里！！）
            Expanded(
              flex: 3,
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Quantity"),
              ),
            ),
          ],
        ),

        // 列表
        Expanded(
          child: ListView.builder(
            itemCount: list1.length,
            itemBuilder: (context, rowNum) {
              return GestureDetector(
                child: Text(
                    "Row $rowNum,ID: ${list1[rowNum].id}, Name: ${list1[rowNum].name}, Qty: ${list1[rowNum].quantity}"),
                onTap: () {
                  setState(() {
                    selectedItem = list1[rowNum];
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }}