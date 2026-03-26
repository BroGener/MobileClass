import 'package:flutter/material.dart';

class Lab6 extends StatefulWidget {
  const Lab6({super.key});

  @override
  State<Lab6> createState() => _Lab6State();
}

class _Lab6State extends State<Lab6> {

  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  List<Map<String, String>> shoppingList = [];

  void addItem() {

    String item = itemController.text.trim();
    String quantity = quantityController.text.trim();

    if(item.isEmpty || quantity.isEmpty){
      return;
    }

    setState(() {
      shoppingList.add({
        "item": item,
        "quantity": quantity
      });
    });

    itemController.clear();
    quantityController.clear();
  }

  void deleteItem(int index){

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Delete Item"),
            content: const Text("Do you want to delete this item?"),
            actions: [

              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),

              TextButton(
                onPressed: (){
                  setState(() {
                    shoppingList.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text("Yes"),
              )

            ],
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Flutter Demo Home Page"),
        backgroundColor: Colors.deepPurple[200],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(

          children: [

            /// INPUT ROW
            Row(
              children: [

                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: itemController,
                    decoration: InputDecoration(
                      hintText: "Type the item here",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Type the quantity here",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Click here"),
                )

              ],
            ),

            const SizedBox(height: 30),

            /// LIST
            Expanded(
              child: shoppingList.isEmpty
                  ? const Center(
                child: Text(
                  "There are no items in the list",
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(

                itemCount: shoppingList.length,

                itemBuilder: (context, index){

                  var item = shoppingList[index];

                  return GestureDetector(

                    onLongPress: (){
                      deleteItem(index);
                    },

                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            "${index + 1}: ${item["item"]}",
                            style: const TextStyle(fontSize: 18),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            "quantity: ${item["quantity"]}",
                            style: const TextStyle(fontSize: 18),
                          ),

                        ],
                      ),
                    ),
                  );

                },
              ),
            )

          ],
        ),
      ),
    );
  }
}