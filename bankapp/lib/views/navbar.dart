import 'package:bankapp/models/add_form.dart';
import 'package:bankapp/views/cardpage.dart';
import 'package:bankapp/views/transaction.dart';
import 'package:bankapp/views/homepage.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<IconData> navIcons = [
    Icons.home_filled,
    Icons.bar_chart_rounded,
    Icons.credit_card
  ];

  int selectedIndex = 0;

  _dailogueBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: AddForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _navBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
    );
  }

  Widget _navBar() {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(
        right: 50,
        left: 50,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.black,
            Color.fromARGB(137, 79, 77, 77),
            Color.fromARGB(245, 77, 77, 79)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...navIcons.asMap().entries.map((entry) {
            int index = entry.key;
            IconData icon = entry.value;
            bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding: const EdgeInsets.all(5),
                decoration: isSelected
                    ? BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade500, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      )
                    : null,
                child: Icon(
                  icon,
                  color: isSelected ? Colors.grey.shade200 : Colors.grey,
                ),
              ),
            );
          }).toList(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                _dailogueBuilder(context);
              },
              child: const Icon(Icons.add),
              shape: const CircleBorder(),
              mini: true,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _pages = [
    HomePage(),
    const TransactionPage(),
    const Cards(),
  ];
}
