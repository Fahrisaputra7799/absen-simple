import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DateStudent extends StatefulWidget {
  const DateStudent({super.key});

  @override
  State<DateStudent> createState() => _DateStudentState();
}

class _DateStudentState extends State<DateStudent> {
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('dateStudent');

  // function Edit Data
  void _editDataStudent(
      String docId,
      String currentName,
      String currentEmail,
      String currentGender,
      String currentKelas,
      String currentNisn,
      String currentOrtu,
      String currentPhoneNumber) {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController emailController =
        TextEditingController(text: currentEmail);
    TextEditingController genderController =
        TextEditingController(text: currentGender);
    TextEditingController kelasController =
        TextEditingController(text: currentKelas);
    TextEditingController nisnController =
        TextEditingController(text: currentNisn);
    TextEditingController ortuController =
        TextEditingController(text: currentOrtu);
    TextEditingController phoneNumberController =
        TextEditingController(text: currentPhoneNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Data"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name")),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email")),
            TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: "Gender")),
            TextField(
                controller: kelasController,
                decoration: const InputDecoration(labelText: "Kelas")),
            TextField(
              controller: nisnController,
              decoration: const InputDecoration(labelText: "NISN"),
            ),
            TextField(
              controller: ortuController,
              decoration: const InputDecoration(labelText: "Ortu"),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: "Number"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await dataCollection.doc(docId).update({
                'name': nameController.text,
                'email': emailController.text,
                'gender': genderController.text,
                'kelas': kelasController.text,
                'nisn': nisnController.text,
                'ortu': ortuController.text,
                'phoneNumber': phoneNumberController.text,
              });
              Navigator.pop(context);
              setState(() {}); // Update screen after edit
            },
            child:
                const Text("Save", style: TextStyle(color: Colors.blueAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // Function Delete Data
  void _deleteData(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Data"),
        content: const Text("Are you sure want to delete this data?"),
        actions: [
          TextButton(
            onPressed: () async {
              await dataCollection.doc(docId).delete();
              Navigator.pop(context);
              setState(() {}); // Perbarui tampilan setelah delete
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 26, 0, 143),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          "Data siswa",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body:StreamBuilder<QuerySnapshot>(
          stream: dataCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              return data.isNotEmpty
                  ? ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var docId = data[index].id;
                        var name = data[index]['name'];
                        var email = data[index]['email'];
                        var gender = data[index]['gender'];
                        var kelas = data[index]['kelas'];
                        var nisn = data[index]['nisn'];
                        var ortu = data[index]['ortu'];
                        var phone_number = data[index]['phone_number'];

                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)],
                                  ),
                                  child: Center(child: Icon(Icons.person_pin)),
                                ),
                                const SizedBox(width: 19),

                                // Read Data
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name: $name",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Email: $email",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Gender: $gender",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Kelas: $kelas",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "NISN: $nisn",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Ortu: $ortu",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Number: $phone_number",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(width: 20,),

                                // Edit & Delete Button
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blueAccent),
                                      onPressed: () => _editDataStudent(
                                        docId,
                                        name,
                                        email,
                                        gender,
                                        kelas,
                                        nisn,
                                        ortu,
                                        phone_number,
                                      ),
                                    ),
                                    SizedBox(height: 25,),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _deleteData(docId),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text("Ups, there is no data!",
                          style: TextStyle(fontSize: 20)));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
    );
  }
}
