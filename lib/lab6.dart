import 'package:flutter/material.dart';


import 'listDatabase.dart';
import 'shoppingList.dart';
import 'listDAO.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

      ),
      home: const MyHomePage(title: "Flutter Demo Home Page"),
    );
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var myFontSize = 30.0;
  List<ShoppingList> items = [];



  late ListDatabase database;
  late ListDAO dao;

  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    $FloorListDatabase.databaseBuilder('listFile.db').build()
        .then((database) {
      this.database = database;
      dao = database.listDAO;

      dao.getAllItems().then((listOfItems) {
        setState(() {
          items = listOfItems;
        });
      });
    });
  }
  Widget ListPage() {
    return Column(children: [

      Center(
        child:SizedBox(
          width:950,
          child:Row(
            children: [

              Expanded(
                child: TextField(
                  controller: itemController,
                  decoration: InputDecoration(
                    hintText: "Type the item here",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 2),

              Expanded(
                child: TextField(
                  controller: quantityController,
                  decoration:  InputDecoration(
                    hintText: "Type the quantity here",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 2),

              ElevatedButton(
                child:
                const Text("Add"),
                onPressed: () async  {
                  int qty = int.tryParse(quantityController.text) ?? 0;
                  final item = ShoppingList(
                    ShoppingList.ID++,
                    itemController.text,
                    qty,
                  );
                  await dao.insertItem(item);
                  setState(() {
                    items.add(item);
                    itemController.clear();
                    quantityController.clear();
                  }
                  );
                },
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10),

      Expanded(
        child: items.isEmpty ? const Center(
          child: Text("There is no item in the list"),
        )
            :ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Delete Item"),
                      content: const Text("Do you want to delete this item?"),
                      actions: [
                        TextButton(
                          child: const Text("Yes"),
                          onPressed: () async {
                            await dao.deleteItem(items[index]);
                            setState(() {
                              items.removeAt(index);

                            });
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text("No"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    "${index + 1}: ${items[index].name} quantity: ${items[index].quantity}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            );
          },
        ),
      )
    ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding:const EdgeInsets.all(15),
        child:ListPage(),
      ),
    );
  }
}