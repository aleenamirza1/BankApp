import 'package:bankapp/models/app_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardOne extends StatelessWidget {
  const CardOne({
    super.key,
    required this.color,
    required this.heading,
    required this.amount,
  });
  final Color color;
  final String heading;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: TextStyle(color: color, fontSize: 14),
                  ),
                  Text(
                    "Rs ${amount}",
                    style: TextStyle(
                        color: color,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                    heading == "Credit"
                        ? Icons.arrow_upward_outlined
                        : Icons.arrow_downward_outlined,
                    color: color),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  HeroCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Text('User not logged in');
    }

    String userId = user.uid;

    final Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _usersStream,
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        var data = snapshot.data!.data()!;
        print(data);
        return Cards(
          data: data,
        );
      },
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.data,
  });
  final Map data;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Balance",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Rs ${data['remainingAmount']}",
                  style: TextStyle(
                    fontSize: 44,
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: const Color.fromARGB(255, 232, 225, 225)),
            child: Row(
              children: [
                CardOne(
                  color: Colors.green,
                  heading: 'Credit',
                  amount: '${data['totalCredit']}',
                ),
                SizedBox(width: 4),
                CardOne(
                    color: Colors.blue,
                    heading: 'Debit',
                    amount: '${data['totalDebit']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TransactionCards extends StatelessWidget {
  TransactionCards({super.key});
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                )
              ],
            ),
            RecentTransactionList()
          ],
        ),
      ),
    );
  }
}

class RecentTransactionList extends StatelessWidget {
  RecentTransactionList({
    super.key,
  });
  final userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection("transactions")
            .orderBy("timestamp", descending: false)
            .limit(20)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No Transactions found"),
            );
          }
          var data = snapshot.data!.docs;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var cardData = data[index];
                return Transactions(data: cardData);
              });
        });
  }
}

// ignore: must_be_immutable
class Transactions extends StatelessWidget {
  Transactions({
    super.key,
    required this.data,
  });
  final dynamic data;
  var appIcons = AppIcons();
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    String formatedDate = DateFormat('d MMM hh:mma').format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            color: Colors.grey.withOpacity(0.09),
            blurRadius: 10.0,
            spreadRadius: 4.0,
          )
        ]),
        child: ListTile(
          minVerticalPadding: 10,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
          leading: Container(
            width: 70,
            height: 100,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: data['type'] == 'credit'
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2)),
              child: Center(
                child: FaIcon(
                    appIcons.getExpenseCategoryIcons("${data['category']}"),
                    color:
                        data['type'] == 'credit' ? Colors.green : Colors.red),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(child: Text("${data['title']}")),
              Text(
                "${data['type'] == "credit" ? "+" : "-"}Rs ${data["amount"]}",
                style: TextStyle(
                    color:
                        data['type'] == 'credit' ? Colors.green : Colors.red),
              )
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Rs ${data['remainingAmount']}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
              Text(
                formatedDate,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
