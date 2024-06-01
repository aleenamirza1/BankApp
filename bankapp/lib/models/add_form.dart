import 'package:bankapp/controllers/appvalidator.dart';
import 'package:bankapp/models/app_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  var type = "credit";
  var category = "Grocery";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isloader = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isloader = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      try {
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        var amount = int.parse(amountEditController.text);
        DateTime date = DateTime.now();

        var id = uid.v4();
        String monthyear = DateFormat('MMM y').format(date);

        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        int remainingAmount = userDoc['remainingAmount'];
        int totalCredit = userDoc['totalCredit'];
        int totalDebit = userDoc['totalDebit'];

        if (type == 'credit') {
          remainingAmount += amount;
          totalCredit += amount;
        } else {
          remainingAmount -= amount;
          totalDebit -= amount;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          "remainingAmount": remainingAmount,
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "updatedAt": timestamp
        });

        var data = {
          "id": id,
          "title": titleEditController.text,
          "amount": amount,
          "type": type,
          "timestamp": timestamp,
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "remainingAmount": remainingAmount,
          "monthyear": monthyear,
          "category": category,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection("transactions")
            .doc(id)
            .set(data);

        Navigator.pop(context);
      } catch (error) {
        print("Error submitting form: $error");
      } finally {
        setState(() {
          isloader = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleEditController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: appValidator.isEmptyCheck,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextFormField(
                controller: amountEditController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: appValidator.isEmptyCheck,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Amount"),
              ),
              CategoryDropDown(
                  cattype: category,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        category = value;
                      });
                    }
                  }),
              DropdownButtonFormField(
                  value: "credit",
                  items: [
                    DropdownMenuItem(
                      child: Text("Credit"),
                      value: "credit",
                    ),
                    DropdownMenuItem(
                      child: Text("Debit"),
                      value: "debit",
                    )
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        type = value;
                      });
                    }
                  }),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (isloader == false) {
                      _submitForm();
                    }
                  },
                  child: isloader
                      ? Center(child: CircularProgressIndicator())
                      : Text("Add Transactions"))
            ],
          )),
    );
  }
}

class CategoryDropDown extends StatelessWidget {
  CategoryDropDown({super.key, required this.cattype, required this.onChanged});

  final String cattype;
  final ValueChanged<String?> onChanged;
  final appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: cattype,
      isExpanded: true,
      hint: Text("Select Category"),
      items: appIcons.homeExpensesCategories.map((category) {
        return DropdownMenuItem<String>(
          value: category['name'],
          child: Row(
            children: [
              Icon(
                category['icon'],
                color: Colors.black45,
              ),
              SizedBox(width: 10),
              Text(
                category['name'],
                style: TextStyle(color: Colors.black45),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        print('Selected category: $value');
        onChanged(value);
      },
    );
  }
}
