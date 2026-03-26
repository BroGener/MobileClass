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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  var isChecked = false;
  var myFontSize = 0.0;
  late TextEditingController _controller; //late means promise to initialize it later

  //can't be async, because it overrides from parent
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); //doing your promise to initialize

    //want to load any existing data into the arraylist
    //to open the database:

    $FloorItemDatabase.databaseBuilder('ItemFile.db').build()
        .then( (database){
      itemDAO = database.myDAO;

      //query all data:
      itemDAO.getAllItems().then( (listOfItems ) {
        setState(() { //redraw the GUI
          list1.addAll(listOfItems); //put the items in the list:
        });
      });
    }  );
  }

  //you are being removed
  @override
  void dispose() {
    super.dispose();
    //free memory:
    _controller.dispose();
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



    if( (width>height) && (width > 720)) {
      //tablet
      return Row( children:[
        Expanded(child: ListPage(),    flex:2), //Left side 40%
        Expanded(child: DetailsPage(), flex:3) //Right side, 60%
      ]);
    }
    else{ //Portrait mode / Phone
      if( selectedItem== null)
        return ListPage(); //show the list
      else
        return DetailsPage(); //show the details
    }
  }

  Widget DetailsPage() {
    if(selectedItem != null){
      return Center(child:Column( children: [
        Text("Name: ${selectedItem!.name}", style: TextStyle(fontSize: 40.0),),
        Text("Quantity: ${selectedItem!.quantity}", style: TextStyle(fontSize: 40.0)),
        Spacer(),//balloon that expands to fill the space
        OutlinedButton(onPressed: (){
          setState(() { selectedItem = null; });
        }, child: Text("Delete")),


        OutlinedButton(onPressed: (){
          setState(() { selectedItem = null; });
        }, child: Text("Close"))

      ], mainAxisAlignment: MainAxisAlignment.center,)
      ); //show what's been selected
    }
    else{
      return Text("Please select an item from the list",style: TextStyle(fontSize: 30.0));
    }
  }

  Widget ListPage()
  {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[
            Flexible(
                flex:1,
                child: ElevatedButton( child:Text("Add item"), onPressed:() {
                  setState(() {
                    //Unique IDs
                    Item newItem = Item(Item.ID++, 1, _controller.value.text);

                    itemDAO.insertItem(newItem);//insert to database
                    list1.add(newItem);
                    _controller.text = "";
                  });
                } )

            ),

            Flexible( flex:4, child:TextField(controller: _controller ))
          ]),

          Expanded(child:
          ListView.builder(
              itemCount: list1.length,
              itemBuilder:(context, rowNum) =>
                  GestureDetector(child:Text("Row $rowNum, Name: ${list1[rowNum].name} Quantity: ${list1[rowNum].quantity }") ,

                      onTap: () {
                        setState(() {  selectedItem = list1[rowNum]; });
                      },


                      onLongPress: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete this?'),
                              content: const Text('are you sure?'),
                              actions: <Widget>[
                                FilledButton(child:Text("Yes"), onPressed:() {
                                  setState(() {
                                    list1.removeAt(rowNum);
                                  });

                                  Navigator.pop(context);
                                }),
                                FilledButton(child:Text("Cancel"), onPressed:() {
                                  Navigator.pop(context);

                                }),
                              ],
                            )
                        );

                      })
          )
          )
        ]);
  }
}
