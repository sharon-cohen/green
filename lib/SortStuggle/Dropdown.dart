import 'package:flutter/material.dart';
class ListItem {
  List<String> listItem;
  ListItem(List<String> engine) {
    this.listItem = engine;

  }
}
class allDrop extends StatefulWidget {
  @override
  _allDropState createState() => _allDropState();
}

class _allDropState extends State<allDrop> {
  int _count = 0;
  ListItem item=new ListItem([
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    '...',
  ]);
  void _update(int count) {
    setState(() => _count = count);
    print(_count);
  }

  @override
  void initState() {

    super.initState();
  }
  @override

  ListItem  renderItem(){
    setState(() {

    });
    return item;
  }
  Widget build(BuildContext context) {
    return Container(

      child:Column(
        children: [

          Expanded(child: DropDown(update: _update,spinnerItems:renderItem())),
          Expanded(child: DropDown(update: _update,spinnerItems:renderItem())),
          Expanded(child: DropDown(update: _update,spinnerItems:renderItem())),
          Expanded(child: DropDown(update: _update,spinnerItems:renderItem())),
          Expanded(child: DropDown(update: _update,spinnerItems:renderItem())),
        ],

      ),
    );
  }
}

class DropDown extends StatefulWidget {
  ListItem spinnerItems;
  final ValueChanged<int> update;
  DropDown({this.spinnerItems,this.update});
  @override
  DropDownWidget createState() => DropDownWidget();
}

class DropDownWidget extends State<DropDown> {
  List <String> listItem;
  String dropdownValue = '...';
  @override
  void initState() {
    setState(() {

    });
    super.initState();
  }
  void deleteList(String s){

    widget.spinnerItems.listItem.remove(s);
  }
  List<String>getnewL(){
    return widget.spinnerItems.listItem;
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child :
        Column(children: <Widget>[

          DropdownButton<String>(
            value: null,
            isDense: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.red, fontSize: 18),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String data) {
              setState(() {
                dropdownValue = data;
                int i=widget.spinnerItems.listItem.indexOf(data);

                widget.spinnerItems.listItem.remove(data);
                widget.update(1);

              });
            },
            items: getnewL().map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          Text('Selected Item = ' + '$dropdownValue',
              style: TextStyle
                (fontSize: 22,
                  color: Colors.black)),
        ]),
      ),
    );
  }
}
