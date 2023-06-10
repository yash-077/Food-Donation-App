import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/screens/filterResult.dart';

import 'const.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<int> duration = [1, 2, 3, 4, 5, 6];

  late String Query = '';
  late String value1 = '';
  late String updatename;
  TextEditingController searchController1 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
        backgroundColor: Const.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("Date",style:Theme.of(context).textTheme.headline5?.copyWith(color: Theme.of(context).accentColor,)),
                // DateFilter(),
                // SizedBox(height: 15,),
                // Text("Address" ,style:Theme.of(context).textTheme.headline5?.copyWith(color: Theme.of(context).accentColor,)),
                // AddressFilter(),
                // SizedBox(height: 15,),
                Text("Duration",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Theme.of(context).accentColor,
                        )),
                DurationFilter(),
                SizedBox(
                  height: 15,
                ),
                Text("Quantity",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Theme.of(context).accentColor,
                        )),
                QuantityFilter(),
                SizedBox(
                  height: 15,
                ),
                Text("Category",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Theme.of(context).accentColor,
                        )),
                CategoryFilter(),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FilteredPage()));
                    },
                    child: Text("Apply"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width/3, 50),
                      shape: const StadiumBorder(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DurationFilter extends StatefulWidget {
  const DurationFilter({Key? key}) : super(key: key);

  @override
  State<DurationFilter> createState() => _DurationFilterState();
}

class _DurationFilterState extends State<DurationFilter> {
  List<int> duration = [1, 2, 3, 4, 5, 6];

  int _selectedIndex = -1;

  TextEditingController searchController1 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection("Posts")
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          try {
            return SingleChildScrollView(
              child: Container(
                height: 55,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: duration.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      try {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (_selectedIndex == index) {
                                  _selectedIndex = -1;
                                } else {
                                  _selectedIndex = index;
                                }

                                Condition.condition=duration[index];
                                Condition.attribute='duration';
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: index == _selectedIndex
                                    ? Const.secondary
                                    : Colors.white,
                                // color: Colors.white,
                              ),
                              child: Text('${duration[index]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                        color: Colors.black,
                                      )),
                            ),
                          ),
                        );
                      } catch (e) {
                        return Container();
                      }
                    }),
              ),
            );
          } catch (e) {
            return Container();
          }
        });
  }
}

class QuantityFilter extends StatefulWidget {
  const QuantityFilter({Key? key}) : super(key: key);

  @override
  State<QuantityFilter> createState() => _QuantityFilterState();
}

class _QuantityFilterState extends State<QuantityFilter> {
  List<String> quantity = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 55,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: quantity.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              try {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_selectedIndex == index) {
                          _selectedIndex = -1;
                        } else {
                          _selectedIndex = index;
                          // Condition.condition1 = quantity[index];
                          // Condition.attribute1 = '';
                        }
                        Condition.condition = quantity[index];
                        Condition.attribute = 'quantity';
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: index == _selectedIndex
                            ? Const.secondary
                            : Colors.white,
                      ),
                      child: Text('${quantity[index]}',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.black,
                                  )),
                    ),
                  ),
                );
              } catch (e) {
                return Container();
              }
            }),
      ),
    );
  }
}

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({Key? key}) : super(key: key);

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  List category = ["Veg", "Non-Veg"];
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 55,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: category.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              try {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_selectedIndex == index) {
                        _selectedIndex = -1;

                      } else {
                          _selectedIndex = index;
                          // Condition.condition2 = category[index];
                          // Condition.attribute2 = '';
                        }
                        Condition.condition = category[index];
                        Condition.attribute = 'category';
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      margin: const EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: index == _selectedIndex
                            ? Const.secondary
                            : Colors.white,
                      ),
                      child: Text('${category[index]}',
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Colors.black,
                                  )),
                    ),
                  ),
                );
              } catch (e) {
                return Container();
              }
            }),
      ),
    );
  }
}
//
//
